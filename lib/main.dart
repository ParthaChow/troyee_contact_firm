import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/services.dart';
import 'app/services/upload_service.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init('auth_storage');
  await GetStorage.init('upload_queue');

  await Get.putAsync<AuthService>(() async {
    return await AuthService().init();
  });

  await Get.putAsync<UploadService>(() async {
    return await UploadService().init();
  });

  runApp(TroyeeApp());
}

class TroyeeApp extends StatelessWidget {
  const TroyeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
    );
  }
}



