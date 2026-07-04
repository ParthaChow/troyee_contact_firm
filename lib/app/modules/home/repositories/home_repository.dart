import 'dart:async';

import '../models/farm_task.dart';

class HomeRepository {
  final List<FarmTask> _tasks = [
    FarmTask(
      id: 1,
      farmName: 'করিম পোল্ট্রি ফার্ম',
      ownerName: 'করিম উদ্দিন',
      phone: '01711111111',
      village: 'সাহাপুর',
      latitude: 23.9001,
      longitude: 89.1220,
      cycleDay: 28,
      distance: 23,
      status: VisitStatus.pending,
      isSynced: false,
      visitDate: DateTime.now(),
    ),
    FarmTask(
      id: 2,
      farmName: 'রহিম ব্রয়লার ফার্ম',
      ownerName: 'রহিম শেখ',
      phone: '01811111111',
      village: 'চরপাড়া',
      latitude: 23.9140,
      longitude: 89.1550,
      cycleDay: 18,
      distance: 15,
      status: VisitStatus.pending,
      isSynced: false,
      visitDate: DateTime.now(),
    ),
    FarmTask(
      id: 3,
      farmName: 'সালাম লেয়ার ফার্ম',
      ownerName: 'সালাম মোল্লা',
      phone: '01911111111',
      village: 'বেলতলী',
      latitude: 23.9300,
      longitude: 89.1900,
      cycleDay: 22,
      distance: 9,
      status: VisitStatus.completed,
      isSynced: true,
      visitDate: DateTime.now(),
    ),
  ];

  /// Fake API call
  Future<List<FarmTask>> getFarmTasks() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return List<FarmTask>.from(_tasks);
  }

  /// Pull-to-refresh
  Future<List<FarmTask>> refreshTasks() async {
    await Future.delayed(const Duration(seconds: 1));

    return List<FarmTask>.from(_tasks);
  }

  /// Complete a visit
  Future<FarmTask> completeVisit(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _tasks.indexWhere((e) => e.id == id);

    if (index == -1) {
      throw Exception("Task not found");
    }

    final updated = _tasks[index].copyWith(
      status: VisitStatus.completed,
      isSynced: false,
    );

    _tasks[index] = updated;

    return updated;
  }

  /// Mark synced
  Future<void> syncTasks() async {
    await Future.delayed(const Duration(seconds: 2));

    for (int i = 0; i < _tasks.length; i++) {
      if (!_tasks[i].isSynced) {
        _tasks[i] = _tasks[i].copyWith(isSynced: true);
      }
    }
  }

  Future<void> updateTask(FarmTask task) async {
    final index = _tasks.indexWhere((e) => e.id == task.id);

    if (index != -1) {
      _tasks[index] = task;
    }
  }

  Future<FarmTask?> getTask(int id) async {
    try {
      return _tasks.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  int get totalTasks => _tasks.length;

  int get completedTasks =>
      _tasks.where((e) => e.isCompleted).length;

  int get pendingTasks =>
      _tasks.where((e) => e.isPending).length;

  int get ongoingTasks =>
      _tasks.where((e) => e.isOngoing).length;

  int get pendingSyncCount =>
      _tasks.where((e) => !e.isSynced).length;
}