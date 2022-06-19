import 'package:get/get.dart';
import 'package:wts_support_engineer/controller/auth_controller.dart';
import 'package:wts_support_engineer/controller/home_controller.dart';


class RootScreenBindings extends Bindings {
  @override
  void dependencies() {
    // eager-loading authController and ContactController, also marking them as permanent
    // so that the same instance is available on different screens when we call Get.find() method
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);




  }
}
