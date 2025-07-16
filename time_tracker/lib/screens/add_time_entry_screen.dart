import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../providers/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Time Entry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: projectId,
                onChanged: (value) => setState(() => projectId = value),
                decoration: InputDecoration(labelText: 'Project'),
                items: projectProvider.projects
                    .map(
                      (proj) => DropdownMenuItem(
                        value: proj.id,
                        child: Text(proj.name),
                      ),
                    )
                    .toList(),
                validator: (value) => value == null ? 'Select a project' : null,
              ),
              DropdownButtonFormField<String>(
                value: taskId,
                onChanged: (value) => setState(() => taskId = value),
                decoration: InputDecoration(labelText: 'Task'),
                items: projectProvider.tasks
                    .map(
                      (task) => DropdownMenuItem(
                        value: task.id,
                        child: Text(task.name),
                      ),
                    )
                    .toList(),
                validator: (value) => value == null ? 'Select a task' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter time';
                  if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${date.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label: Text('Select Date'),
                    onPressed: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (selected != null) {
                        setState(() => date = selected);
                      }
                    },
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter notes' : null,
                onSaved: (value) => notes = value!,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<TimeEntryProvider>(
                      context,
                      listen: false,
                    ).addTimeEntry(
                      TimeEntry(
                        id: DateTime.now().toString(),
                        projectId: projectId!,
                        taskId: taskId!,
                        totalTime: totalTime,
                        date: date,
                        notes: notes,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
