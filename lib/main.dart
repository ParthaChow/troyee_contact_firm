import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'l10n/app_localizations.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/services.dart';
import 'app/services/upload_service.dart';
import 'app/services/theme_service.dart';
import 'app/services/locale_service.dart';
import 'app/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('bn_BD', null);

  await GetStorage.init();
  await GetStorage.init('auth_storage');
  await GetStorage.init('upload_queue');
  await GetStorage.init('theme_storage');
  await GetStorage.init('locale_storage');

  await Get.putAsync<AuthService>(() async {
    return await AuthService().init();
  });

  await Get.putAsync<UploadService>(() async {
    return await UploadService().init();
  });

  await Get.putAsync<ThemeService>(() async {
    return ThemeService();
  });

  await Get.putAsync<LocaleService>(() async {
    return await LocaleService().init();
  });

  runApp(const TroyeeApp());
}

class TroyeeApp extends StatelessWidget {
  const TroyeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final localeService = Get.find<LocaleService>();
    
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.light,
        darkTheme: AppThemes.dark,
        themeMode: themeService.theme,
        locale: localeService.locale,
        fallbackLocale: const Locale('en', 'US'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: Routes.splash,
        getPages: AppPages.routes,
      ),
    );
  }
}
