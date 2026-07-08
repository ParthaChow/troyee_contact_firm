import 'package:get/get.dart';
import '../../modules/sign_in/binding/sign_in_binding.dart';
import '../../modules/sign_in/view/sign_in_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../../modules/splash/binding/splash_binding.dart';
import 'app_routes.dart';
import '../../modules/splash/view/splash_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.auth,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
