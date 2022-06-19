import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:wts_support_engineer/model/dashboard_info_model.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/repo/home_repo.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/status.dart';


class HomeController extends GetxController {
  var status = Status.LOADING.obs;
  var isUser = true.obs;
  var isLoading = false.obs;
  var pageIndex =0.obs;
  var selectedTab =0;

   Rx<DashBoardInfoModel?> dashBoardInfoModel = Rx(null);
  //
   HomeRepository _homeRepo = HomeRepositoryImpl();

  @override
  void onInit() {
    super.onInit();
    // getUser();
  }

  Future<void> getDashBoardData() async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? userId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    bool? isSupportEngi = (await MySharedPreference.getBoolean(SharedPrefKey.ISSUPPORT_ENGINEER));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map ={"lang": lang,};
    if(isSupportEngi==true){
      map['support_engineer']=userId;
    }
print('...................dashboard data.............>>>${map}......................');
    try {
      var res = await _homeRepo.dashboard(map);
      isLoading.value = false;
      if (res is DashBoardInfoModel) {
        dashBoardInfoModel.value = res;
        status.value = Status.SUCCESS;
      } else {
        status.value = Status.ERROR;
      }
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
    }
  }

  Future<String?> changeProfilePic(String filePath) async {
    String? picUrl = null;
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    try {
      var res = await _homeRepo.changeProfilePic(customerId!, filePath);
      isLoading.value = false;
      if (res is String) {
        picUrl = res;
        String? strUserInfo =
            (await MySharedPreference.getString(SharedPrefKey.USER_INFO));
        UserInfoModel userInfoModel =
            UserInfoModel.fromJson(jsonDecode(strUserInfo ?? ''));
        userInfoModel.photo = res;
        MySharedPreference.setString(SharedPrefKey.USER_INFO,jsonEncode(userInfoModel).toString());
        status.value = Status.SUCCESS;
      } else {
        status.value = Status.ERROR;
      }
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
    }
    return picUrl;
  }
}
