import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/services.dart';
import 'app/services/upload_service.dart';
import 'app/services/theme_service.dart';
import 'app/core/theme/app_theme.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await GetStorage.init();
  await GetStorage.init('auth_storage');
  await GetStorage.init('upload_queue');

  await Get.putAsync<AuthService>(() async {
    return await AuthService().init();
  });

  await Get.putAsync<UploadService>(() async {
    return await UploadService().init();
  });

  Get.put(ThemeService());

  runApp(TroyeeApp());
}

class TroyeeApp extends StatelessWidget {
  const TroyeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeService.theme,
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
    );
  }
}



