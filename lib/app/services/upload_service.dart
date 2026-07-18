import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/theme/app_colors.dart';
import 'api_fetch.dart';
import 'services.dart';

class UploadService extends GetxService {
  final ApiFetch _apiFetch = ApiFetch();
  final AuthService _authService = Get.find<AuthService>();
  final GetStorage _storage = GetStorage('upload_queue');
  final Connectivity _connectivity = Connectivity();

  final RxList<Map<String, dynamic>> _queue = <Map<String, dynamic>>[].obs;
  final RxBool isConnected = true.obs;
  bool _isUploading = false;

  Future<UploadService> init() async {
    _loadQueue();
    
    // Check initial connectivity
    checkInitialConnectivity();

    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      isConnected.value = results.isNotEmpty && !results.contains(ConnectivityResult.none);
      if (isConnected.value) {
        _processQueue();
      }
    });
    return this;
  }

  Future<void> checkInitialConnectivity() async {
    var results = await _connectivity.checkConnectivity();
    isConnected.value = results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  void _loadQueue() {
    final List<dynamic>? storedQueue = _storage.read('queue');
    if (storedQueue != null) {
      _queue.assignAll(storedQueue.cast<Map<String, dynamic>>());
    }
  }

  void _saveQueue() {
    _storage.write('queue', _queue.toList());
  }

  void addToQueue({
    required int visitId,
    required String imagePath,
  }) {
    _queue.add({
      'visitId': visitId,
      'imagePath': imagePath,
      'timestamp': DateTime.now().toIso8601String(),
    });
    _saveQueue();
    _processQueue();
  }

  Future<void> _processQueue() async {
    if (_isUploading || _queue.isEmpty) return;

    var connectivityResults = await _connectivity.checkConnectivity();
    if (connectivityResults.contains(ConnectivityResult.none)) return;

    _isUploading = true;

    while (_queue.isNotEmpty) {
      final item = _queue.first;
      try {
        final baseUrl = _authService.baseUrl;

        if (baseUrl == null || !(await _authService.ensureValidToken())) {
          _isUploading = false;
          return;
        }

        final token = _authService.accessToken!;

        final file = File(item['imagePath']);
        if (file.existsSync()) {
          await _apiFetch.uploadVisitImage(
            baseUrl: baseUrl,
            token: token,
            visitId: item['visitId'],
            imagePath: item['imagePath'],
          );

          // Delete the file from local storage after successful upload
          if (file.existsSync()) {
            await file.delete();
            print("Deleted local file after upload: ${item['imagePath']}");
          }
          
          Get.snackbar(
            "সফল", 
            "ছবি সফলভাবে আপলোড হয়েছে (Visit ID: ${item['visitId']})",
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.primary.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }

        _queue.removeAt(0);
        _saveQueue();
      } catch (e) {
        print("Upload failed: $e");
        
        Get.snackbar(
          "ত্রুটি", 
          "ছবি আপলোড করতে ব্যর্থ হয়েছে। পুনরায় চেষ্টা করা হচ্ছে...",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        break; // Stop processing and retry later
      }
    }

    _isUploading = false;
  }
}
