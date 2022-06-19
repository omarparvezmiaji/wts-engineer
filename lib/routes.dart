import 'package:get/get.dart';
import 'package:wts_support_engineer/binding/auth_screen_binding.dart';
import 'package:wts_support_engineer/view/screen/add_complain_screen.dart';
import 'package:wts_support_engineer/view/screen/change_password_screen.dart';
import 'package:wts_support_engineer/view/screen/complain_details_screen.dart';
import 'package:wts_support_engineer/view/screen/completed_notcompleted_supportengineer_screen.dart';
import 'package:wts_support_engineer/view/screen/create_complain_select_customer_screen.dart';
import 'package:wts_support_engineer/view/screen/create_complain_select_product_screen.dart';
import 'package:wts_support_engineer/view/screen/home_page.dart';
import 'package:wts_support_engineer/view/screen/login_screen.dart';
import 'package:wts_support_engineer/view/screen/make_schedule_reschedule_screen.dart';
import 'package:wts_support_engineer/view/screen/make_scheduler_screen.dart';
import 'package:wts_support_engineer/view/screen/onboarding_screen.dart';
import 'package:wts_support_engineer/view/screen/otp_screen.dart';
import 'package:wts_support_engineer/view/screen/profile_statistics_screen.dart';
import 'package:wts_support_engineer/view/screen/splash_screen.dart';

import 'binding/home_page_binding.dart';

final List<GetPage> appPages = [
  GetPage(
    name: SplashScreen.pageId,
    page: () => SplashScreen(),
  ),
  GetPage(
      name: OnBoardingScreen.pageId,
      page: () => OnBoardingScreen(),
      // binding: LoginScreenBinding(),
      transition: Transition.upToDown),

  GetPage(
      name: LoginScreen.pageId,
      page: () => LoginScreen(),
      binding: AuthScreenBinding(),
      transition: Transition.upToDown),
  GetPage(
      name: HomePage.pageId,
      page: () => HomePage(),
      binding: HomePageBinding(),
      transition: Transition.upToDown),
  GetPage(
      name: CompletedNotCompletedSupportEngineerScreen.pageId,
      page: () => CompletedNotCompletedSupportEngineerScreen(),
      binding: HomePageBinding(),
      transition: Transition.upToDown),
  GetPage(
      name: MakeSchedulerScreen.pageId,
      page: () => MakeSchedulerScreen(),
      binding: HomePageBinding(),
      transition: Transition.upToDown),
  GetPage(
      name: MakeSchedulerRescheduleScreen.pageId,
      page: () => MakeSchedulerRescheduleScreen(),
      binding: HomePageBinding(),
      transition: Transition.upToDown),

  GetPage(
      name: ComplainDetailsScreen.pageId,
      page: () => ComplainDetailsScreen(),
      binding: HomePageBinding(),
      transition: Transition.upToDown),

  GetPage(
      name: ChangePasswordScreen.pageId,
      page: () => ChangePasswordScreen(),
      binding: HomePageBinding(),
      transition: Transition.cupertino),
  GetPage(
      name: ProfileeStatisticsScreen.pageId,
      page: () => ProfileeStatisticsScreen(),
      binding: HomePageBinding(),
      transition: Transition.cupertino),
  GetPage(
      name: AddComplainScreen.pageId,
      page: () => AddComplainScreen(),
      binding: HomePageBinding(),
      transition: Transition.cupertino),
  GetPage(
      name: CreateComplainSelectCustomerScreen.pageId,
      page: () => CreateComplainSelectCustomerScreen(),
      binding: HomePageBinding(),
      transition: Transition.cupertino),
  GetPage(
      name: CreateComplainSelectProductScreen.pageId,
      page: () => CreateComplainSelectProductScreen(),
      binding: HomePageBinding(),
      transition: Transition.cupertino),
  GetPage(
      name: OtpScreen.pageId,
      page: () => OtpScreen(),
      binding: HomePageBinding(),
      transition: Transition.cupertino),
  // GetPage(
  //     name: HomeScreen.pageId,
  //     page: () => HomeScreen(),
  //     //  binding: HomeScreenBinding(),
  //     transition: Transition.upToDown),
  // GetPage(
  //     name: ComplainScreen.pageId,
  //     page: () => ComplainScreen(),
  //     //  binding: HomeScreenBinding(),
  //     transition: Transition.upToDown),
];
