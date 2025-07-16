import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/time_entry.dart';

class TimeChart extends StatelessWidget {
  final List<TimeEntry> entries;
  final String groupBy; // 'project', 'task'

  const TimeChart({super.key, required this.entries, required this.groupBy});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, double>{};

    for (var entry in entries) {
      final key = groupBy == 'project' ? entry.projectId : entry.taskId;
      grouped[key] = (grouped[key] ?? 0) + entry.totalTime;
    }

    final sections = grouped.entries.map((e) {
      return PieChartSectionData(
        title: e.key,
        value: e.value,
        radius: 80,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();

    return PieChart(
      PieChartData(sections: sections, centerSpaceRadius: 30, sectionsSpace: 2),
    );
  }
}
