import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;

  String? projectId;
  String? taskId;
  String notes = '';

  Duration get elapsed => _elapsed;
  bool get isRunning => _isRunning;

  void startTimer() {
    _startTime = DateTime.now();
    _elapsed = Duration.zero;
    _isRunning = true;

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _elapsed = DateTime.now().difference(_startTime!);
      notifyListeners();
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resumeTimer() {
    _startTime = DateTime.now().subtract(_elapsed);
    _isRunning = true;

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _elapsed = DateTime.now().difference(_startTime!);
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _startTime = null;
    _elapsed = Duration.zero;
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }
}
