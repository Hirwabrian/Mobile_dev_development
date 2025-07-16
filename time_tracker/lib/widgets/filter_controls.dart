import 'package:flutter/material.dart';

class FilterControls extends StatelessWidget {
  final List<String> projects;
  final List<String> tasks;
  final String? selectedProject;
  final String? selectedTask;
  final DateTimeRange? dateRange;
  final String sortBy;
  final void Function(String?) onProjectChanged;
  final void Function(String?) onTaskChanged;
  final void Function(DateTimeRange?) onDateRangeChanged;
  final void Function(String) onSortChanged;

  const FilterControls({
    super.key,
    required this.projects,
    required this.tasks,
    required this.selectedProject,
    required this.selectedTask,
    required this.dateRange,
    required this.sortBy,
    required this.onProjectChanged,
    required this.onTaskChanged,
    required this.onDateRangeChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            DropdownButton<String>(
              value: selectedProject,
              hint: Text('Project'),
              onChanged: onProjectChanged,
              items: [null, ...projects]
                  .map(
                    (p) => DropdownMenuItem<String>(
                      value: p,
                      child: Text(p ?? 'All Projects'),
                    ),
                  )
                  .toList(),
            ),
            DropdownButton<String>(
              value: selectedTask,
              hint: Text('Task'),
              onChanged: onTaskChanged,
              items: [null, ...tasks]
                  .map(
                    (t) => DropdownMenuItem<String>(
                      value: t,
                      child: Text(t ?? 'All Tasks'),
                    ),
                  )
                  .toList(),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                onDateRangeChanged(picked);
              },
              icon: Icon(Icons.date_range),
              label: Text(
                dateRange == null
                    ? 'Date Range'
                    : '${dateRange!.start.toLocal()} → ${dateRange!.end.toLocal()}',
              ),
            ),
            DropdownButton<String>(
              value: sortBy,
              onChanged: (val) => onSortChanged(val ?? 'date'),
              items: [
                DropdownMenuItem(value: 'date', child: Text('Sort by Date')),
                DropdownMenuItem(
                  value: 'duration',
                  child: Text('Sort by Duration'),
                ),
                DropdownMenuItem(
                  value: 'project',
                  child: Text('Sort by Project'),
                ),
              ],
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
