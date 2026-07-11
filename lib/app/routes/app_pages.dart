import 'package:get/get.dart';
import '../../modules/farm_batch/binding/farm_batch_binding.dart';
import '../../modules/farm_batch/view/farm_batch_view.dart';
import '../../modules/farm_visit/binding/camera_visit_binding.dart';
import '../../modules/farm_visit/binding/farm_visit_binding.dart';
import '../../modules/farm_visit/binding/signature_binding.dart';
import '../../modules/farm_visit/view/camera_visit_view.dart';
import '../../modules/farm_visit/view/farm_visit_view.dart';
import '../../modules/farm_visit/view/signature_view.dart';
import '../../modules/sign_in/binding/sign_in_binding.dart';
import '../../modules/sign_in/view/sign_in_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
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
    GetPage(
      name: Routes.farm_batch,
      page: () => const FarmBatchView(),
      binding: FarmBatchBinding(),
    ),
    GetPage(
      name: Routes.farm_visit,
      page: () => const FarmVisitView(),
      binding: FarmVisitBinding(),
    ),
    GetPage(
      name: Routes.camera_visit,
      page: () => const CameraVisitView(),
      binding: CameraVisitBinding(),
    ),
    GetPage(
      name: Routes.signature_visit,
      page: () => const SignatureView(),
      binding: SignatureBinding(),
    ),
  ];
}
