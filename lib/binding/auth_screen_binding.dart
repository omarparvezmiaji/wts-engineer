import 'package:get/get.dart';
import 'package:wts_support_engineer/controller/auth_controller.dart';


class AuthScreenBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<AuthController>(() => AuthController());
  }
}