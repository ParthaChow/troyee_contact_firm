import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/core/theme/app_colors.dart';
import '../controller/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _HeaderSection(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                transform: Matrix4.translationValues(0, -30, 0),
                child: Form(
                  key: controller.formKey,
                  child: Obx(() {
                    final hasProfiles = controller.savedProfiles.isNotEmpty;
                    final showManual = controller.showManualLogin.value || !hasProfiles;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        if (hasProfiles) ...[
                          const Text(
                            "পছন্দের প্রোফাইল",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 85,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.savedProfiles.length,
                              itemBuilder: (context, index) {
                                final profile = controller.savedProfiles[index];
                                return _QuickProfileCard(
                                  profile: profile,
                                  onTap: () => controller.selectProfile(profile),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        if (!showManual && hasProfiles)
                          Center(
                            child: TextButton.icon(
                              onPressed: () => controller.showManualLogin.value = true,
                              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                              label: const Text(
                                "অন্য অ্যাকাউন্ট দিয়ে লগইন করুন",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),

                        if (showManual) ...[
                          if (hasProfiles) ...[
                            const Row(
                              children: [
                                Expanded(child: Divider(color: AppColors.divider)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text("অথবা", style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                                ),
                                Expanded(child: Divider(color: AppColors.divider)),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                          const Text(
                            "লগইন করুন",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Username
                          TextFormField(
                            controller: controller.usernameController,
                            validator: controller.validateUsername,
                            decoration: InputDecoration(
                              hintText: "ইউজারনেম",
                              prefixIcon: const Icon(Icons.person_outline, size: 22, color: AppColors.primary),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primary, width: 1),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// Password
                          TextFormField(
                            controller: controller.passwordController,
                            validator: controller.validatePassword,
                            obscureText: controller.obcsurePassword.value,
                            decoration: InputDecoration(
                              hintText: "পাসওয়ার্ড",
                              prefixIcon: const Icon(Icons.lock_outline, size: 22, color: AppColors.primary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obcsurePassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textGrey,
                                  size: 20,
                                ),
                                onPressed: controller.togglePassword,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primary, width: 1),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// Sign In Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value ? null : controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "লগইন",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),

                        Center(
                          child: Text(
                            "Version 1.0.0",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 20,
        24,
        60,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.agriculture_rounded,
            color: Colors.white,
            size: 48,
          ),
          SizedBox(height: 12),
          Text(
            "Troyee Contact Farm",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "ফিল্ড অফিসার লগইন",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final VoidCallback onTap;

  const _QuickProfileCard({required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile['fullName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    profile['zone'],
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
