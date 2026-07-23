import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../repositories/home_repository.dart';
import '../../weather/controller/weather_controller.dart';
import '../../profile/controller/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(
          () => HomeRepository(),
      fenix: true,
    );

    Get.lazyPut<HomeController>(
          () => HomeController(),
    );

    Get.lazyPut<WeatherController>(
          () => WeatherController(),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
          () => ProfileController(),
      fenix: true,
    );
  }
}
