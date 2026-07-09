import 'dart:async';
import 'package:get/get.dart';
import '../../../app/services/api_fetch.dart';
import '../../../app/services/services.dart';
import '../models/farm_task.dart';

class HomeRepository {
  final ApiFetch _api = ApiFetch();
  final AuthService _auth = Get.find<AuthService>();

  final List<FarmTask> _tasks = [];

  /// Fetch from actual API
  Future<List<FarmTask>> getFarmTasks() async {
    final baseUrl = _auth.baseUrl;
    final token = _auth.accessToken;

    if (baseUrl == null || token == null) {
      return List<FarmTask>.from(_tasks);
    }

    try {
      print("Fetching farms from: ${baseUrl}farm-list");
      final remoteTasks = await _api.getFarmList(baseUrl: baseUrl, token: token);
      _tasks.clear();
      _tasks.addAll(remoteTasks);
      return remoteTasks;
    } catch (e) {
      print("Error fetching from API: $e");
      return List<FarmTask>.from(_tasks);
    }
  }

  /// Pull-to-refresh
  Future<List<FarmTask>> refreshTasks() async {
    return await getFarmTasks();
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