import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/time_entry.dart';
import '../widgets/filter_controls.dart';
import '../providers/project_task_provider.dart';
import '../providers/time_entry_provider.dart';
import 'add_time_entry_screen.dart';
import 'timer_screen.dart';
import 'export_screen.dart';
import 'project_task_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _mainTabController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 3, vsync: this);
  }

  void switchToManageTab({required int subTabIndex}) {
    // Set main tab to Manage Projects & Tasks (index 2)
    _mainTabController.animateTo(2);

    // Let the ProjectTaskManagementScreen know which sub-tab to show
    Future.delayed(Duration(milliseconds: 300), () {
      ProjectTaskManagementScreen.of(context)?.jumpToTab(subTabIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Time Entries'),
        bottom: TabBar(
          controller: _mainTabController,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'All Entries'),
            Tab(icon: Icon(Icons.category), text: 'By Project'),
            Tab(icon: Icon(Icons.settings), text: 'Manage'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.timer),
            tooltip: 'Live Timer',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TimerScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Export',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExportScreen()),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Manage Projects'),
              onTap: () {
                Navigator.pop(context);
                switchToManageTab(subTabIndex: 0);
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Manage Tasks'),
              onTap: () {
                Navigator.pop(context);
                switchToManageTab(subTabIndex: 1);
              },
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _mainTabController,
        children: [
          // All Entries tab
          Consumer<TimeEntryProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  FilterControls(
                    projects: projectProvider.projects
                        .map((e) => e.id)
                        .toList(),
                    tasks: projectProvider.tasks.map((e) => e.id).toList(),
                    selectedProject: null,
                    selectedTask: null,
                    dateRange: null,
                    sortBy: 'date',
                    onProjectChanged: (val) =>
                        provider.setFilters(project: val),
                    onTaskChanged: (val) => provider.setFilters(task: val),
                    onDateRangeChanged: (val) =>
                        provider.setFilters(dateRange: val),
                    onSortChanged: provider.setSort,
                  ),
                  Expanded(
                    child: provider.filteredEntries.isEmpty
                        ? Center(child: Text("No time entries yet."))
                        : ListView.builder(
                            itemCount: provider.filteredEntries.length,
                            itemBuilder: (context, index) {
                              final entry = provider.filteredEntries[index];
                              return ListTile(
                                title: Text(
                                  '${entry.projectId} - ${entry.totalTime} hours',
                                ),
                                subtitle: Text(
                                  '${entry.date.toLocal().toString().split(" ")[0]} - Notes: ${entry.notes}',
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    provider.deleteTimeEntry(entry.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Entry deleted")),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),

          // Grouped by project tab
          Consumer<TimeEntryProvider>(
            builder: (context, provider, _) {
              final grouped = <String, List<TimeEntry>>{};
              for (var entry in provider.filteredEntries) {
                grouped.putIfAbsent(entry.projectId, () => []).add(entry);
              }

              if (grouped.isEmpty) return Center(child: Text("No entries"));

              return ListView(
                children: grouped.entries.map((group) {
                  final projectName = projectProvider.projects
                      .firstWhere(
                        (proj) => proj.id == group.key,
                        orElse: () =>
                            Project(id: group.key, name: "Unknown Project"),
                      )
                      .name;

                  return ExpansionTile(
                    title: Text(projectName),
                    children: group.value.map((entry) {
                      return ListTile(
                        title: Text('${entry.totalTime} hours'),
                        subtitle: Text(
                          '${entry.date.toLocal().toString().split(' ')[0]} - ${entry.notes}',
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            },
          ),

          // Manage Projects & Tasks (with subtabs inside)
          ProjectTaskManagementScreen.withControllerHook(),
        ],
      ),

      floatingActionButton: _mainTabController.index == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddTimeEntryScreen()),
                );
              },
              tooltip: 'Add Time Entry',
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
