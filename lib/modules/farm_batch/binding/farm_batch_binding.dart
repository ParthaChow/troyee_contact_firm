import 'package:get/get.dart';
import '../../../app/services/api_fetch.dart';
import '../controller/farm_batch_controller.dart';
import '../../../app/services/auth_repository.dart';

class FarmBatchBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ApiFetch>(() => ApiFetch());

    // 2. Load your Auth Repository (which depends on ApiFetch)
    Get.lazyPut<AuthRepository>(
          () => AuthRepository(Get.find<ApiFetch>()),
    );

    // 3. Load your Controller (THIS IS THE CRITICAL LINE)
    Get.lazyPut<FarmBatchController>(() => FarmBatchController());
  }


}
