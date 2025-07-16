import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../providers/time_entry_provider.dart';
import '../models/time_entry.dart';
import '../providers/project_task_provider.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final taskProvider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Live Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: timerProvider.projectId,
              hint: Text('Select Project'),
              onChanged: (value) {
                timerProvider.projectId = value;
                timerProvider.notifyListeners();
              },
              items: taskProvider.projects.map((proj) {
                return DropdownMenuItem(value: proj.id, child: Text(proj.name));
              }).toList(),
            ),
            DropdownButton<String>(
              value: timerProvider.taskId,
              hint: Text('Select Task'),
              onChanged: (value) {
                timerProvider.taskId = value;
                timerProvider.notifyListeners();
              },
              items: taskProvider.tasks.map((task) {
                return DropdownMenuItem(value: task.id, child: Text(task.name));
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              _formatDuration(timerProvider.elapsed),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!timerProvider.isRunning &&
                    timerProvider.elapsed == Duration.zero)
                  ElevatedButton(
                    onPressed: timerProvider.startTimer,
                    child: Text('Start'),
                  ),
                if (timerProvider.isRunning)
                  ElevatedButton(
                    onPressed: timerProvider.pauseTimer,
                    child: Text('Pause'),
                  ),
                if (!timerProvider.isRunning &&
                    timerProvider.elapsed > Duration.zero)
                  ElevatedButton(
                    onPressed: timerProvider.resumeTimer,
                    child: Text('Resume'),
                  ),
                SizedBox(width: 12),
                if (timerProvider.elapsed > Duration.zero)
                  ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<TimeEntryProvider>(
                        context,
                        listen: false,
                      );
                      if (timerProvider.projectId != null &&
                          timerProvider.taskId != null) {
                        provider.addTimeEntry(
                          TimeEntry(
                            id: DateTime.now().toString(),
                            projectId: timerProvider.projectId!,
                            taskId: timerProvider.taskId!,
                            totalTime: timerProvider.elapsed.inSeconds / 3600,
                            date: DateTime.now(),
                            notes: timerProvider.notes,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Time entry saved')),
                        );
                      }
                      timerProvider.resetTimer();
                    },
                    child: Text('Stop & Save'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
