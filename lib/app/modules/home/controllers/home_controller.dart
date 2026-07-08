import 'package:get/get.dart';

import '../../../core/utils/bengali_numbers.dart';
import '../../../routes/app_routes.dart';
import '../../../services/services.dart';
import '../models/farm_task.dart';
import '../repositories/home_repository.dart';

enum FarmFilter {
  all,
  pending,
  completed,
}

class HomeController extends GetxController {
  final HomeRepository _repository = HomeRepository();
  final AuthService _authService = Get.find<AuthService>();

  // Officer Information
  final officerName = 'রফিক';
  final zone = 'কুষ্টিয়া জোন';
  final statusLabel = 'সক্রিয়';

  // Dashboard
  final completedVisits = 0.obs;
  final totalVisits = 0.obs;
  final pendingSyncRecords = 0.obs;

  // Navigation
  final navIndex = 0.obs;

  // Search
  final searchText = ''.obs;

  // Filter
  final selectedFilter = FarmFilter.all.obs;

  // Loading
  final isLoading = false.obs;

  String get todayString {
    final now = DateTime.now();
    final day = toBengaliNumber(now.day);
    final year = toBengaliNumber(now.year);
    final month = _getBengaliMonth(now.month);
    return "$day $month, $year";
  }

  String _getBengaliMonth(int month) {
    const months = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর'
    ];
    return months[month - 1];
  }

  // Data
  final farmTasks = <FarmTask>[].obs;

  // Visible Data
  final filteredTasks = <FarmTask>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadFarmTasks();
  }

  Future<void> loadFarmTasks() async {
    isLoading.value = true;

    try {
      final tasks = await _repository.getFarmTasks();

      farmTasks.assignAll(tasks);

      applyFilter();

      updateDashboard();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    isLoading.value = true;

    try {
      final tasks = await _repository.refreshTasks();

      farmTasks.assignAll(tasks);

      applyFilter();

      updateDashboard();
    } finally {
      isLoading.value = false;
    }
  }

  void updateDashboard() {
    completedVisits.value =
        farmTasks.where((e) => e.isCompleted).length;

    totalVisits.value = farmTasks.length;

    pendingSyncRecords.value =
        farmTasks.where((e) => !e.isSynced).length;
  }

  int get remainingVisits =>
      totalVisits.value - completedVisits.value;

  double get progressValue {
    if (totalVisits.value == 0) {
      return 0;
    }

    return completedVisits.value / totalVisits.value;
  }

  void changeNavIndex(int index) {
    navIndex.value = index;
  }

  void search(String value) {
    searchText.value = value;
    applyFilter();
  }

  void clearSearch() {
    searchText.value = '';
    applyFilter();
  }

  void changeFilter(FarmFilter filter) {
    selectedFilter.value = filter;
    applyFilter();
  }

  void applyFilter() {
    List<FarmTask> list = List.from(farmTasks);

    if (searchText.value.isNotEmpty) {
      final keyword = searchText.value.toLowerCase();

      list = list.where((task) {
        return task.farmName.toLowerCase().contains(keyword) ||
            task.ownerName.toLowerCase().contains(keyword) ||
            task.village.toLowerCase().contains(keyword);
      }).toList();
    }

    switch (selectedFilter.value) {
      case FarmFilter.pending:
        list = list.where((e) => e.isPending).toList();
        break;

      case FarmFilter.completed:
        list = list.where((e) => e.isCompleted).toList();
        break;

      case FarmFilter.all:
        break;
    }

    filteredTasks.assignAll(list);
  }

  Future<void> startVisit(int id) async {
    final index = farmTasks.indexWhere((e) => e.id == id);

    if (index == -1) return;

    farmTasks[index] = farmTasks[index].copyWith(
      status: VisitStatus.ongoing,
      isSynced: false,
    );

    farmTasks.refresh();

    applyFilter();

    updateDashboard();

    await _repository.updateTask(farmTasks[index]);
  }

  Future<void> completeVisit(int id) async {
    final updated = await _repository.completeVisit(id);

    final index = farmTasks.indexWhere((e) => e.id == id);

    if (index == -1) return;

    farmTasks[index] = updated;

    farmTasks.refresh();

    applyFilter();

    updateDashboard();
  }

  Future<void> syncAll() async {
    await _repository.syncTasks();

    await loadFarmTasks();
  }

  void logout() {
    _authService.logout();
    Get.offAllNamed(Routes.auth);
  }

  int get pendingCount =>
      farmTasks.where((e) => e.isPending).length;

  int get completedCount =>
      farmTasks.where((e) => e.isCompleted).length;

  int get ongoingCount =>
      farmTasks.where((e) => e.isOngoing).length;
}