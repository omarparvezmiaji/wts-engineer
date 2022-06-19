import 'package:get/get.dart';
import 'package:wts_support_engineer/controller/auth_controller.dart';
import 'package:wts_support_engineer/controller/home_controller.dart';
import 'package:wts_support_engineer/controller/schedule_controller.dart';
import 'package:wts_support_engineer/controller/service_controller.dart';


class HomePageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<ScheduleController>(ScheduleController(), permanent: true);
    Get.put<ServiceController>(ServiceController(), permanent: true);
    Get.put<ServiceController>(ServiceController(), permanent: true);
  }
}