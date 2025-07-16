import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/time_entry_provider.dart';
import '../models/time_entry.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String _exportedText = '';
  String _format = 'json';

  String generateCSV(List<TimeEntry> entries) {
    final buffer = StringBuffer();
    buffer.writeln('ID,ProjectID,TaskID,TotalTime,Date,Notes');
    for (var e in entries) {
      buffer.writeln(
        '"${e.id}","${e.projectId}","${e.taskId}",${e.totalTime},"${e.date.toIso8601String()}","${e.notes}"',
      );
    }
    return buffer.toString();
  }

  String generateJSON(List<TimeEntry> entries) {
    final list = entries
        .map(
          (e) => {
            'id': e.id,
            'projectId': e.projectId,
            'taskId': e.taskId,
            'totalTime': e.totalTime,
            'date': e.date.toIso8601String(),
            'notes': e.notes,
          },
        )
        .toList();
    return const JsonEncoder.withIndent('  ').convert(list);
  }

  void handleExport(List<TimeEntry> entries) {
    final data = _format == 'csv'
        ? generateCSV(entries)
        : generateJSON(entries);
    setState(() => _exportedText = data);
  }

  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<TimeEntryProvider>(context).filteredEntries;

    return Scaffold(
      appBar: AppBar(title: Text('Export Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [_format == 'json', _format == 'csv'],
              onPressed: (index) {
                setState(() => _format = index == 0 ? 'json' : 'csv');
              },
              children: [Text('JSON'), Text('CSV')],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text('Generate Export'),
              onPressed: () => handleExport(entries),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _exportedText.isEmpty
                  ? Center(child: Text('No export yet'))
                  : SelectableText(
                      _exportedText,
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
