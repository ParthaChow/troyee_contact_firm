// UPDATED home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/core/theme/app_colors.dart';
import '../../../app/modules/home/controllers/home_controller.dart';
import '../../../app/modules/home/widgets/farm_task_tile.dart';
import '../../../app/modules/home/widgets/progress_summary_card.dart';

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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: controller.syncAll,
          backgroundColor: AppColors.primaryGreen,
          icon: const Icon(Icons.sync),
          label: const Text("Sync"),
        ),
        body: Column(
          children: [
            _HeaderSection(controller: controller),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                transform: Matrix4.translationValues(0, -20, 0),
                child: Obx(
                      () => RefreshIndicator(
                    onRefresh: () async => controller.refreshData(),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        ProgressSummaryCard(
                          completed: controller.completedVisits.value,
                          total: controller.totalVisits.value,
                          remaining: controller.remainingVisits,
                          pendingSync: controller.pendingSyncRecords.value,
                          progress: controller.progressValue,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          onChanged: controller.search,
                          decoration: InputDecoration(
                            hintText: 'ফার্ম, মালিক অথবা গ্রামের নাম লিখুন',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: Obx(() {
                              if (controller.searchText.value.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: controller.clearSearch,
                              );
                            }),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Obx(()=>FilterChip(
                                label: const Text("সব"),
                                selected: controller.selectedFilter.value==FarmFilter.all,
                                onSelected: (_)=>controller.changeFilter(FarmFilter.all),
                              )),
                              const SizedBox(width:10),
                              Obx(()=>FilterChip(
                                label: const Text("বাকি"),
                                selected: controller.selectedFilter.value==FarmFilter.pending,
                                onSelected: (_)=>controller.changeFilter(FarmFilter.pending),
                              )),
                              const SizedBox(width:10),
                              Obx(()=>FilterChip(
                                label: const Text("সম্পন্ন"),
                                selected: controller.selectedFilter.value==FarmFilter.completed,
                                onSelected: (_)=>controller.changeFilter(FarmFilter.completed),
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height:20),
                        const Text("আজকের পরিদর্শন তালিকা",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize:16)),
                        const SizedBox(height:12),
                        if(controller.filteredTasks.isEmpty)
                          const _EmptyTaskWidget()
                        else
                          ...controller.filteredTasks.map(
                                (e) => FarmTaskTile(
                              task: e,
                              onTap: () => controller.startVisit(e.id),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final HomeController controller;
  const _HeaderSection({required this.controller});

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      color: AppColors.primaryGreen,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top+12,20,36),
      child: Row(
        children:[
          Expanded(child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text('আসসালামু আলাইকুম, ${controller.officerName}',
                  style: const TextStyle(color: Colors.white,fontSize:20,fontWeight: FontWeight.bold)),
              const SizedBox(height:4),
              Text('ফিল্ড অফিসার - ${controller.zone}',
                  style: const TextStyle(color: Colors.white70)),
            ],
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal:12,vertical:6),
            decoration: BoxDecoration(
              color: AppColors.activeBadge,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(controller.statusLabel),
          )
        ],
      ),
    );
  }
}

class _EmptyTaskWidget extends StatelessWidget{
  const _EmptyTaskWidget();

  @override
  Widget build(BuildContext context){
    return const Padding(
      padding: EdgeInsets.symmetric(vertical:60),
      child: Column(
        children:[
          Icon(Icons.agriculture,size:70,color:Colors.grey),
          SizedBox(height:16),
          Text("কোনো ফার্ম পাওয়া যায়নি",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
          SizedBox(height:8),
          Text("সার্চ অথবা ফিল্টার পরিবর্তন করুন"),
        ],
      ),
    );
  }
}