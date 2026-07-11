import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/core/theme/app_colors.dart';
import '../controller/camera_visit_controller.dart';

class CameraVisitView extends GetView<CameraVisitController> {
  const CameraVisitView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _HeaderSection(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _CameraContainer(),
                    const SizedBox(height: 20),
                    const Text(
                      "| তোলা ছবি",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffD79A09),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ImageGallery(),
                    const SizedBox(height: 30),
                    _NextButton(),
                    const SizedBox(height: 20),
                  ],
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 10,
        20,
        30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                "ছবি তুলুন",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              "শেড, খাদ্য, পানি ও পরিবেশের ছবি",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraContainer extends GetView<CameraVisitController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff2A332F),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Obx(() {
          if (!controller.isInitialized.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              CameraPreview(controller.cameraController!),
              _buildFocusCorners(),
              Positioned(
                bottom: 20,
                child: GestureDetector(
                  onTap: () => controller.takePicture(),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffD79A09), width: 4),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFocusCorners() {
    return Stack(
      children: [
        Positioned(top: 30, left: 30, child: _corner(top: true, left: true)),
        Positioned(top: 30, right: 30, child: _corner(top: true, left: false)),
        Positioned(bottom: 30, left: 30, child: _corner(top: false, left: true)),
        Positioned(bottom: 30, right: 30, child: _corner(top: false, left: false)),
      ],
    );
  }

  Widget _corner({required bool top, required bool left}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: Color(0xffD79A09), width: 3) : BorderSide.none,
          bottom: !top ? const BorderSide(color: Color(0xffD79A09), width: 3) : BorderSide.none,
          left: left ? const BorderSide(color: Color(0xffD79A09), width: 3) : BorderSide.none,
          right: !left ? const BorderSide(color: Color(0xffD79A09), width: 3) : BorderSide.none,
        ),
      ),
    );
  }
}

class _ImageGallery extends GetView<CameraVisitController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.capturedImages.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.capturedImages.length) {
                return _AddButton();
              }
              return _GalleryItem(
                image: controller.capturedImages[index],
                index: index,
              );
            },
          )),
    );
  }
}

class _GalleryItem extends GetView<CameraVisitController> {
  final XFile image;
  final int index;
  const _GalleryItem({required this.image, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _viewImage(context, image),
          child: Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: FileImage(File(image.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 16,
          child: GestureDetector(
            onTap: () => controller.removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _viewImage(BuildContext context, XFile image) {
    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: InteractiveViewer(
            child: Image.file(File(image.path)),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends GetView<CameraVisitController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.pickFromGallery(),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: const Icon(Icons.add, color: Colors.grey, size: 32),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Get.snackbar("Info", "Next step: Signature");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "পরবর্তী: স্বাক্ষর →",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
