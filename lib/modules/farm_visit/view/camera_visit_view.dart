import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/services/upload_service.dart';
import '../../../app/routes/app_routes.dart';
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _CameraContainer(),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "| তোলা ছবি",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffD79A09),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ImageGallery(),
                    const SizedBox(height: 15),
                    Obx(() {
                      final isConnected = Get.find<UploadService>().isConnected.value;
                      return isConnected ? const SizedBox.shrink() : _AutoUploadBar();
                    }),
                    const SizedBox(height: 15),
                    _NextButton(),
                    const SizedBox(height: 5),
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
        MediaQuery.of(context).padding.top + 8,
        20,
        15,
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
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              "শেড, খাদ্য, পানি ও পরিবেশের ছবি",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
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
            fit: StackFit.expand,
            children: [
              CameraPreview(controller.cameraController!),
              _buildFocusCorners(),
              Positioned(
                bottom: 15,
                child: GestureDetector(
                  onTap: () => controller.takePicture(),
                  child: Container(
                    width: 60,
                    height: 60,
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
        Positioned(top: 25, left: 25, child: _corner(top: true, left: true)),
        Positioned(top: 25, right: 25, child: _corner(top: true, left: false)),
        Positioned(bottom: 25, left: 25, child: _corner(top: false, left: true)),
        Positioned(bottom: 25, right: 25, child: _corner(top: false, left: false)),
      ],
    );
  }

  Widget _corner({required bool top, required bool left}) {
    return Container(
      width: 20,
      height: 20,
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
      height: 70,
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
            width: 70,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: FileImage(File(image.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 12,
          child: GestureDetector(
            onTap: () => controller.removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 10,
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
        width: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: const Icon(Icons.add, color: Colors.grey, size: 24),
      ),
    );
  }
}

class _AutoUploadBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffFDE8E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync, color: Color(0xffE04F4F), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "নেটওয়ার্ক পেলে স্বয়ংক্রিয়ভাবে আপলোড হবে",
              style: TextStyle(
                color: const Color(0xffE04F4F),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextButton extends GetView<CameraVisitController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          final args = Map<String, dynamic>.from(Get.arguments ?? {});
          args['imagePaths'] = controller.capturedImages.map((e) => e.path).toList();
          Get.toNamed(Routes.signature_visit, arguments: args);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Next",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
