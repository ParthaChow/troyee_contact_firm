import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/app_pages.dart';
import 'app/services/services.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => AuthService().init());

  runApp(TroyeeApp()
  );
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



