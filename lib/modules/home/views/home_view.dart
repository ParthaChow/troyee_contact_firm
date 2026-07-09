import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/core/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../widgets/farm_task_tile.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          switch (controller.navIndex.value) {
            case 0:
              return _HomeSection(controller: controller);
            case 1:
              return _FarmListSection(controller: controller);
            case 2:
              return _SyncSection(controller: controller);
            case 3:
              return _ProfileSection(controller: controller);
            default:
              return _HomeSection(controller: controller);
          }
        }),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.navIndex.value,
            onTap: controller.changeNavIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'হোম',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                activeIcon: Icon(Icons.assignment),
                label: 'তালিকা',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sync_outlined),
                activeIcon: Icon(Icons.sync),
                label: 'সিঙ্ক',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'প্রোফাইল',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  final HomeController controller;
  const _HomeSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeaderSection(controller: controller),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            transform: Matrix4.translationValues(0, -30, 0),
            child: Obx(
              () => RefreshIndicator(
                onRefresh: () async => controller.refreshData(),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  children: [
                    const SizedBox(height: 10),
                    const SizedBox(height: 16),
                    if (controller.isLoading.value)
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ))
                    else if (controller.filteredTasks.isEmpty)
                      const _EmptyTaskWidget()
                    else
                      ...controller.filteredTasks.map(
                        (task) => FarmTaskTile(
                          task: task,
                          onTap: () {
                            controller.startVisit(task.id);
                            Get.toNamed(Routes.farm_batch, arguments: task);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FarmListSection extends StatelessWidget {
  final HomeController controller;
  const _FarmListSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeaderSection(controller: controller),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            transform: Matrix4.translationValues(0, -30, 0),
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "সম্পূর্ণ তালিকা",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...controller.farmTasks.map(
                          (task) => FarmTaskTile(
                            task: task,
                            onTap: () {
                              controller.startVisit(task.id);
                              Get.toNamed(Routes.farm_batch, arguments: task);
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SyncSection extends StatelessWidget {
  final HomeController controller;
  const _SyncSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeaderSection(controller: controller),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            transform: Matrix4.translationValues(0, -30, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sync, size: 80, color: AppColors.primary),
                  const SizedBox(height: 20),
                  Obx(() => Text(
                        "পেন্ডিং রেকর্ড: ${controller.pendingSyncRecords.value}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => controller.syncAll(),
                    icon: const Icon(Icons.sync),
                    label: const Text("সব সিঙ্ক করুন"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final HomeController controller;
  const _ProfileSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xff0F2D20),
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).padding.top + 20,
            20,
            40,
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                controller.officerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.zone,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'ব্যক্তিগত তথ্য',
                onTap: () {},
              ),
              _ProfileMenuItem(
                icon: Icons.settings_outlined,
                title: 'সেটিংস',
                onTap: () {},
              ),
              _ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'সহায়তা',
                onTap: () {},
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.logout, color: Colors.red),
                ),
                title: const Text(
                  'লগআউট',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('লগআউট'),
        content: const Text('আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('না', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text('হ্যাঁ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final HomeController controller;
  const _HeaderSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xff0F2D20), // Dark Green
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 10,
        20,
        60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.officerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ফিল্ড অফিসার - ${controller.zone}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: controller.isOnline.value
                        ? const Color(0xffE7A512)
                        : Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: controller.isOnline.value ? Colors.white : Colors.white54,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        controller.statusLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyTaskWidget extends StatelessWidget {
  const _EmptyTaskWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.agriculture_outlined, size: 70, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "কোনো ফার্ম পাওয়া যায়নি",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text("আজকের জন্য কোনো কাজ নির্ধারিত নেই"),
        ],
      ),
    );
  }
}
