import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 20),

                    /// Logo
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.lightGreen,
                      child: Icon(
                        Icons.agriculture_rounded,
                        color: Colors.blueAccent,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Troyee Contact Farm",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Sign in to continue",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),

                    const SizedBox(height: 40),

                    /// Base URL
                    // TextFormField(
                    //   controller: controller.baseUrlController,
                    //   validator: controller.validateBaseUrl,
                    //   keyboardType: TextInputType.url,
                    //   decoration: InputDecoration(
                    //     labelText: "Base URL",
                    //     hintText: "http://xxx.xxx.xxx/api/",
                    //     prefixIcon: const Icon(Icons.link),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 18),

                    /// Username
                    TextFormField(
                      controller: controller.usernameController,
                      validator: controller.validateUsername,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// Password
                    Obx(
                          () => TextFormField(
                        controller: controller.passwordController,
                        validator: controller.validatePassword,
                        obscureText: controller.obcsurePassword.value,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obcsurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.togglePassword,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Obx(
                            () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            "SIGN IN",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}