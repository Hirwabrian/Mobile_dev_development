import 'package:flutter/material.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }

  // Add to TimeEntryProvider
  String? _filterProject;
  String? _filterTask;
  DateTimeRange? _filterDateRange;
  String _sortBy = 'date';

  List<TimeEntry> get filteredEntries {
    List<TimeEntry> result = [..._entries];

    // Apply filters
    if (_filterProject != null) {
      result = result.where((e) => e.projectId == _filterProject).toList();
    }
    if (_filterTask != null) {
      result = result.where((e) => e.taskId == _filterTask).toList();
    }
    if (_filterDateRange != null) {
      result = result
          .where(
            (e) =>
                e.date.isAfter(
                  _filterDateRange!.start.subtract(Duration(days: 1)),
                ) &&
                e.date.isBefore(_filterDateRange!.end.add(Duration(days: 1))),
          )
          .toList();
    }

    // Sort
    result.sort((a, b) {
      switch (_sortBy) {
        case 'duration':
          return b.totalTime.compareTo(a.totalTime);
        case 'project':
          return a.projectId.compareTo(b.projectId);
        case 'date':
        default:
          return b.date.compareTo(a.date);
      }
    });

    return result;
  }

  void setFilters({String? project, String? task, DateTimeRange? dateRange}) {
    _filterProject = project;
    _filterTask = task;
    _filterDateRange = dateRange;
    notifyListeners();
  }

  void setSort(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }
}
