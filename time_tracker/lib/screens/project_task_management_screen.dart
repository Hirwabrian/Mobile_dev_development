import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_task_provider.dart';
import '../models/task.dart';
import '../models/project.dart';

class ProjectTaskManagementScreen extends StatefulWidget {
  /// Global key to allow external access to internal state (for tab switching)
  static final GlobalKey<_ProjectTaskManagementScreenState> _screenKey =
      GlobalKey<_ProjectTaskManagementScreenState>();

  ProjectTaskManagementScreen({Key? key}) : super(key: _screenKey);

  /// Access the internal state to control tabs externally
  static _ProjectTaskManagementScreenState? of(BuildContext context) {
    return _screenKey.currentState;
  }

  /// Used in TabBarView
  static Widget withControllerHook() {
    return ProjectTaskManagementScreen();
  }

  @override
  State<ProjectTaskManagementScreen> createState() =>
      _ProjectTaskManagementScreenState();
}

class _ProjectTaskManagementScreenState
    extends State<ProjectTaskManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _innerTabController;

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 2, vsync: this);
  }

  /// Called from outside to switch tabs (0: Projects, 1: Tasks)
  void jumpToTab(int index) {
    _innerTabController.animateTo(index);
  }

  @override
  void dispose() {
    _innerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectTaskProvider>(context);

    return Column(
      children: [
        TabBar(
          controller: _innerTabController,
          labelColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(text: 'Projects'),
            Tab(text: 'Tasks'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [
              // Projects tab
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.projects.length,
                      itemBuilder: (context, index) {
                        final project = provider.projects[index];
                        return ListTile(
                          title: Text(project.name),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              provider.deleteProject(project.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Project deleted')),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Add Project'),
                      onPressed: () => _showAddProjectDialog(context, provider),
                    ),
                  ),
                ],
              ),

              // Tasks tab
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.tasks.length,
                      itemBuilder: (context, index) {
                        final task = provider.tasks[index];
                        return ListTile(
                          title: Text(task.name),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              provider.deleteTask(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Task deleted')),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Add Task'),
                      onPressed: () => _showAddTaskDialog(context, provider),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddProjectDialog(
    BuildContext context,
    ProjectTaskProvider provider,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Project'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Project Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                provider.addProject(
                  Project(id: DateTime.now().toIso8601String(), name: name),
                );
              }
              Navigator.pop(context);
            },

            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, ProjectTaskProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Task'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Task Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                provider.addTask(
                  Task(id: DateTime.now().toIso8601String(), name: name),
                );
              }
              Navigator.pop(context);
            },

            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
