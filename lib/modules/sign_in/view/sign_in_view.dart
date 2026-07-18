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

                    if (showManual) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          /// url
                          TextFormField(
                            controller: controller.baseUrlController,
                            validator: controller.validateUsername,
                            decoration: InputDecoration(
                              hintText: "Base Url",
                              prefixIcon: const Icon(Icons.link_rounded, size: 22, color: AppColors.primary),
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

                          /// Username
                          TextFormField(
                            controller: controller.usernameController,
                            validator: controller.validateUsername,
                            decoration: InputDecoration(
                              hintText: "Username",
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
                              hintText: "Password",
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
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          if (hasProfiles) ...[
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () => controller.showManualLogin.value = false,
                                child: const Text(
                                  "Choose Account",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
                        ],
                      );
                    }

                    // Account Selection Layout
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 230,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // 1. Saved Profiles Section (Top 80%)
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 20),
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
                              ],
                            ),
                          ),

                          // 2. Fixed Bottom Section (Bottom 20%)
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () => controller.showManualLogin.value = true,
                                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                                  label: const Text(
                                    "Sign in with another account",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Version 1.0.0",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
        MediaQuery.of(context).padding.top + 22,
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
          const Text(
            "Troyee Contact Farm",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Field Officer Login",
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
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20), // Increased margin
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20), // Significantly increased padding for size
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // More rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06), // Slightly deeper shadow
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30, // Bigger avatar
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person, color: AppColors.primary, size: 36), // Bigger icon
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile['fullName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Bigger font
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profile['zone'],
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14, // Bigger font
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
