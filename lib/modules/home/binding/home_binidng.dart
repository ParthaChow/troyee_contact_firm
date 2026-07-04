import 'package:get/get.dart';

import '../../../app/modules/home/controllers/home_controller.dart';
import '../../../app/modules/home/repositories/home_repository.dart';

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
  }
}