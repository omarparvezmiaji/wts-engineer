import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/helping/helpers.dart';
import 'package:wts_support_engineer/mixins/print_log_mixin.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/repo/auth_repo.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/static_key.dart';
import 'package:wts_support_engineer/util/status.dart';
import 'package:wts_support_engineer/view/screen/home_page.dart';


class AuthController extends GetxController with PrintLogMixin {
  var status = Status.LOADING.obs;
  var isLoading = false.obs;
  var isForgetLoading = false.obs;
  var radioValue = 0.obs;
  Rx<String?> loginError = Rx(null);

  final userNameCon = TextEditingController();
  final mobileNumberCon = TextEditingController();
  final passwordCon = TextEditingController();

  // final AuthApiService _authService = AuthApiService.create();
  //
  // final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
  AuthRepository _authRepo = AuthRepositoryImpl();

  // User get user => _firebaseUser.value;

  //User setUser(User user) => _firebaseUser.value = user;

  @override
  onInit() {

    //  _firebaseUser.bindStream(_fireAuth.authStateChanges());

    getLanguageWiseContents();
  }





  Future<void> login(String phone, String password) async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(
        '..........................token=${token}...............................');
    loginError.value = null;
    isLoading.value = true;
    status.value = Status.LOADING;
    try {
      String? lang = await MySharedPreference.getLanguage();
      Map<String, dynamic> map = {
        'lang': lang,
        'username': phone,
        'password': password,
        'token': token
      };
      var result = await _authRepo.login(map);
      isLoading.value = false;
      if (result is UserInfoModel) {
        loginError.value = null;
        MySharedPreference.setString(
            SharedPrefKey.USER_INFO, (jsonEncode(result)));
        MySharedPreference.setInt(
            SharedPrefKey.USER_ID, (result as UserInfoModel).id!);
        MySharedPreference.setBoolean(SharedPrefKey.ISLOGIN, true);
        if (result.roleId == '4')
          MySharedPreference.setBoolean(SharedPrefKey.ISSUPPORT_ENGINEER, true);
        else
          MySharedPreference.setBoolean(
              SharedPrefKey.ISSUPPORT_ENGINEER, false);

        status.value = Status.SUCCESS;
        Get.offAllNamed(HomePage.pageId);
      } else if (result is String) {
        print(
            "...................................${result}...................");
        if (result == "error") {
          loginError.value =
          "Dear User, Please try to login by your registered mobile number with us, If you can not recognized, please call to the support number: ${StaticKey
              .SUPPORT_NUMBER}";
          status.value = Status.ERROR;
        } else {
          status.value = Status.SUCCESS;
        }
        Helpers.showSnackbar(title: 'Error',
            message: "Dear User, Please try to login by your registered mobile number with us, If you can not recognized, please call to the support number: ${StaticKey
                .SUPPORT_NUMBER}");
      }
    } catch (e) {
      loginError.value = e.toString();
      printLog(e);
      Helpers.showSnackbar(title: 'Error',
          message: "Dear User, Please try to login by your registered mobile number with us, If you can not recognized, please call to the support number: ${StaticKey
              .SUPPORT_NUMBER}");
      isLoading.value = false;
      status.value = Status.ERROR;
    }
  }

  Future<bool> getLanguageWiseContents() async {
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {"lang": lang};
    try {
      var res = await _authRepo.getLanguageWiseContents(map);
      if (res is Map<String, dynamic>) {
        print(
            '............................language........${res}...............');
        MySharedPreference.setString(
            SharedPrefKey.LANGUAGE_WISE_CONTENT, (jsonEncode(res)));
        return true;
      } else {
        print(
            '...............................controller language error.....error...............');
      }
    } catch (e) {}
    return false;
  }


  changePassword(String password) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {
      'user_id': customerId,
      'password': password,
      "lang": lang
    };
    try {
      var res = await _authRepo.changePassword(map);
      isLoading.value = false;
      if (res == 'success') {
        print('....................................${res}...............');

        status.value = Status.SUCCESS;
      } else {
        status.value = Status.ERROR;
      }
      Fluttertoast.showToast(msg: res);
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
    }
  }


  Future<dynamic> forgetPassword(String mobileNumber) async {
   // status.value = Status.LOADING;
    //isLoading.value = true;
    isForgetLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {
      'verify_key': mobileNumber,
      "lang": lang
    };
    try {
      var res = await _authRepo.forgetPassword(map);
     // isLoading.value = false;
      isForgetLoading.value = false;
      if (res == 'success') {
        print('....................................${res}...............');

       // status.value = Status.SUCCESS;
        return res;
      } else {
     //   status.value = Status.ERROR;
        return res;
      }
      Fluttertoast.showToast(msg: res);
    } catch (e) {
     // status.value = Status.ERROR;
      //isLoading.value = false;
      return 'error';
    }
  }

    Future<dynamic> verifyCode(String verify_code) async {
      status.value = Status.LOADING;
      isLoading.value = true;
      int? customerId = (await MySharedPreference.getInt(
          SharedPrefKey.USER_ID));
      String? lang = (await MySharedPreference.getLanguage());
      Map<String, dynamic> map = {
        'verify_code': verify_code,
        "lang": lang
      };
      try {
        var res = await _authRepo.verifyCode(map);
        isLoading.value = false;
        if (res == 'success') {
          print('....................................${res}...............');

          status.value = Status.SUCCESS;
          return res;
        } else {
          status.value = Status.ERROR;
          return res;
        }
        Fluttertoast.showToast(msg: res);
      } catch (e) {
        status.value = Status.ERROR;
        isLoading.value = false;
        return 'error';
      }
    }


    void signOutUser() async {
      try {
        // await Get.find<NotificationController>().fcmUnSubscribe();
        // await _authService.signOutUser();
        // Get.offAllNamed(RootScreen.pageId);
      } catch (e) {
        printLog(e);
        //Helpers.showSnackbar(title: 'Error', message: e.message);
      }
    }

}
