import 'package:flutter/material.dart';

import '../../../app/core/theme/app_colors.dart';

class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({
    super.key,
    required this.completed,
    required this.total,
    required this.remaining,
    required this.pendingSync,
    required this.progress,
  });

  final int completed;
  final int total;
  final int remaining;
  final int pendingSync;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          //------------------------------------------------
          // Progress Ring (Left)
          //------------------------------------------------
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 900),
            tween: Tween(begin: 0, end: progress),
            builder: (_, value, child) {
              return SizedBox(
                width: 75,
                height: 75,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xffECECEC),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xffE7A512),
                        ),
                      ),
                    ),
                    Text(
                      "${completed}/${total}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(width: 24),

          //------------------------------------------------
          // Info (Right)
          //------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "আজকের অগ্রগতি",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$totalটি টার্গেট - $remainingটি বাকি",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${pendingSync.toString().padLeft(2, '0')}টি রেকর্ড সিঙ্কের অপেক্ষায়",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xffD79A09),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
