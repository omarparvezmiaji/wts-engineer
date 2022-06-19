import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/model/schedule_info_model.dart';
import 'package:wts_support_engineer/repo/schedule_repo.dart';
import 'package:wts_support_engineer/repo/service_repo.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/status.dart';

class ServiceController extends GetxController {
  var status = Status.LOADING.obs;
  var isLoading = false.obs;
  Rx<List<ScheduleInfoModel>?> todayScheduleList = Rx(null);
  Rx<List<ScheduleInfoModel>?> upcomingScheduleList = Rx(null);
  Rx<List<ScheduleInfoModel>?> pastScheduleList = Rx(null);
  Rx<List<ScheduleInfoModel>?> setScheduleList = Rx(null);
  ServiceRepository _serviceRepo = ScrviceRepositoryImpl();

  String? selectedItemId = null;
  int selectedTab = 0;

  @override
  void onInit() {
    super.onInit();
    // getUser();
  }

  Future<void> getTodaySchedule(
      String? support_engineer, String? search, String? service_type) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if (support_engineer != null) map['support_engineer'] = support_engineer;

    if (search != null) map['search'] = search;
    if (service_type != null) map['service_type'] = service_type;

    try {
      var res = await _serviceRepo.scheduleToday(map);
      isLoading.value = false;
      if (res is List<ScheduleInfoModel>) {
        // ScheduleInfoModel sc = res[0];
        // res.add(sc);
        // res.add(sc);
        // res.add(sc);
        print(
            '........................getTodaySchedule............${res.length}...............');

        todayScheduleList.value = res;
        status.value = Status.SUCCESS;
      } else {
        status.value = Status.ERROR;
      }
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
    }
  }

  Future<void> getUpcomintSchedule(
      String? support_engineer, String? search, String? service_type) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if (support_engineer != null) map['support_engineer'] = support_engineer;

    if (search != null) map['search'] = search;
    if (service_type != null) map['service_type'] = service_type;

    try {
      var res = await _serviceRepo.scheduleUpcoming(map);
      isLoading.value = false;
      if (res is List<ScheduleInfoModel>) {
        print(
            '....................................${res.length}...............');
        upcomingScheduleList.value = res;
        status.value = Status.SUCCESS;
      } else {
        status.value = Status.ERROR;
      }
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
    }
  }

  Future<void> getPastSchedule(
      String? support_engineer, String? search, String? service_type) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if (support_engineer != null) map['support_engineer'] = support_engineer;

    if (search != null) map['search'] = search;
    if (service_type != null) map['service_type'] = service_type;

    try {
      var res = await _serviceRepo.schedulePast(map);
      isLoading.value = false;
      if (res is List<ScheduleInfoModel>) {
        print(
            '....................................${res.length}...............');
        pastScheduleList.value = res;
        status.value = Status.SUCCESS;
      } else {
        status.value = Status.ERROR;
      }
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
    }
  }

  Future<String> loadAllSchedull(
      String? support_engineer, String? search, String? service_type) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if (support_engineer != null) map['support_engineer'] = support_engineer;

    if (search != null&& search.length>0) map['search'] = search;
    if (service_type != null) map['service_type'] = service_type;
    print(
        '.....................loadAllSchedull...............${map}...............');
    try {
      var todayres = await _serviceRepo.scheduleToday(map);

      if (todayres is List<ScheduleInfoModel>)
        todayScheduleList.value = todayres;

      var pastres = await _serviceRepo.schedulePast(map);
      if (pastres is List<ScheduleInfoModel>) pastScheduleList.value = pastres;

      var upcomingSche = await _serviceRepo.scheduleUpcoming(map);
      if (upcomingSche is List<ScheduleInfoModel>)
        upcomingScheduleList.value = upcomingSche;

      var setScheres = await _serviceRepo.setSchedule(map);
      if (setScheres is List<ScheduleInfoModel>)
        setScheduleList.value = setScheres;

      isLoading.value = false;
      status.value = Status.SUCCESS;
      return "success";
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
      return "error";
    }
  }

  Future<void> getSetSchedule(
      String? support_engineer, String? search, String? service_type) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if (support_engineer != null) map['support_engineer'] = support_engineer;

    if (search != null) map['search'] = search;
    if (service_type != null) map['service_type'] = service_type;

    try {
      var res = await _serviceRepo.setSchedule(map);
      isLoading.value = false;
      if (res is List<ScheduleInfoModel>) {
        print(
            '....................................${res.length}...............');

        setScheduleList.value = res;
        status.value = Status.SUCCESS;
      } else {
        status.value = Status.ERROR;
      }
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
    }
  }

  Future<List<dynamic>> support_action() async {
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
  //  if (support_engineer != null) map['support_engineer'] = support_engineer;


    try {
      var res = await _serviceRepo.support_action(map);

      if (res is List<dynamic>) {
        return res;
      } else {
        throw throw Exception("Error");
      }
    } catch (e) {
      throw throw Exception("Error");
    }
  }

  Future<List<dynamic>> timeSlot() async {
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};

    try {
      var res = await _serviceRepo.timeSlot(map);

      if (res is List<dynamic>) {
        return res;
      } else {
        throw throw Exception("Error");
      }
    } catch (e) {
      throw throw Exception("Error");
    }
  }

  Future<List<dynamic>> supportEngineer() async {
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};

    try {
      var res = await _serviceRepo.supportEngineer();

      if (res is List<dynamic>) {
        return res;
      } else {
        throw throw Exception("Error");
      }
    } catch (e) {
      throw throw Exception("Error");
    }
  }

  Future<dynamic> statistics(String? support_engineer,String? last_month) async {
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if (support_engineer != null) map['support_engineer'] = support_engineer;
    if (last_month != null) map['last_month'] = last_month;


    print('................statistics......map..........${map}............');

    try {
      var res = await _serviceRepo.statistics(map);

      if (res is Map) {
        return res;
      } else {
        throw throw Exception("Error");
      }
    } catch (e) {
      throw throw Exception("Error");
    }
  }

  Future<List<dynamic>> spareParts(String product_id) async {
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    map["product_id"]= product_id;

    try {
      var res = await _serviceRepo.spareParts(map);

      if (res is List<dynamic>) {
        return res;
      } else {
        throw throw Exception("Error");
      }
    } catch (e) {
      throw throw Exception("Error");
    }
  }

  Future<List<dynamic>> item_wise_services(String? support_engineer,String? last_month ) async {
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if (support_engineer != null) map['support_engineer'] = support_engineer;
    if (last_month != null) map['last_month'] = last_month;


    print('................item_wise_services......map..........${map}............');
    try {
      var res = await _serviceRepo.item_wise_services(map);

      if (res is List<dynamic>) {
        return res;
      } else {
        throw throw Exception("Error");
      }
    } catch (e) {
      throw throw Exception("Error");
    }
  }



  Future<List<dynamic>> customerList(String? search) async {
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if(search!=null&& search.length>0) map['search']=search;

    print('...........customerList.........${map}.......');

    try {
      var res = await _serviceRepo.customerList(map);

      if (res is List<dynamic>) {
        return res;
      } else {
        throw throw Exception("Error");
      }
    } catch (e) {
      throw throw Exception("Error");
    }
  }


  Future<List<dynamic>> customerWisePorducts(String? customerId ) async {
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if (customerId != null) map['customer_id'] = customerId;
    try {
      var res = await _serviceRepo.customerWisePorducts(map);

      if (res is List<dynamic>) {
        return res;
      } else {
        throw throw Exception("Error");
      }
    } catch (e) {
      throw throw Exception("Error");
    }
  }

  Future<dynamic> createComplain(String? support_engineer,String? customer_id,String? product_id,String? product_code,
      String? service_note ) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    if (customer_id != null) map['customer_id'] = customer_id;
    if (support_engineer != null) map['support_engineer'] = support_engineer;
    if (product_id != null) map['product_id'] = product_id;
    if (product_code != null) map['product_code'] = product_code;
    if (service_note != null) map['service_note'] = service_note;
    try {
      var res = await _serviceRepo.createComplain(map);
      isLoading.value = false;
      if (res is String) {
        status.value = Status.SUCCESS;
        Fluttertoast.showToast(msg: res);
        return res;
      } else {
        status.value = Status.ERROR;
        Fluttertoast.showToast(msg: "Failed");
        throw throw Exception("Error");
      }
    } catch (e) {

      status.value = Status.ERROR;
      isLoading.value = false;
      Fluttertoast.showToast(msg: "Failed");
      throw throw Exception("Error");
    }
  }

}
