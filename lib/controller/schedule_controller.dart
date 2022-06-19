import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wts_support_engineer/model/complain_details_model.dart';
import 'package:wts_support_engineer/model/schedule_info_model.dart';
import 'package:wts_support_engineer/repo/schedule_repo.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';
import 'package:wts_support_engineer/util/status.dart';

class ScheduleController extends GetxController {
  var status = Status.LOADING.obs;
  var isLoading = false.obs;
  Rx<List<ScheduleInfoModel>?> completedList = Rx(null);
  Rx<List<ScheduleInfoModel>?> toBeCompletedList = Rx(null);
  Rx<List<ScheduleInfoModel>?> notCompletedList = Rx(null);
  Rx<ComplainDetailsModel?> complainDetailsModel = Rx(null);
  SchedulerRepository _scheduleRepo = SchedulerRepositoryImpl();

  Rx<int> completedPageNumber=Rx(0);
  var isCompletedNextPageLoaded=false.obs;

  String? selectedItemId = null;
  int selectedTab = 2;

  @override
  void onInit() {
    super.onInit();
    // getUser();
  }

  completed(String? support_engineer, String? from_date, String? to_date,
      String? search, String? service_type) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {"lang": lang};

    if (support_engineer != null) map['support_engineer'] = support_engineer;
    if (from_date != null) map['from_date'] = from_date;
    if (to_date != null) map['to_date'] = to_date;
    if (search != null) map['search'] = search;
    if (service_type != null) map['service_type'] = search;

    try {
      var res = await _scheduleRepo.completed(map);
      isLoading.value = false;
      if (res is List<ScheduleInfoModel>) {
        // ScheduleInfoModel sc = res[0];
        // res.add(sc);
        // res.add(sc);
        // res.add(sc);
        print(
            '........................getTodaySchedule............${res.length}...............');

        completedList.value = res;
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

  notCompleted(String? support_engineer, String? from_date, String? to_date,
      String? search, String? service_type) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {"lang": lang};

    if (support_engineer != null) map['support_engineer'] = support_engineer;
    if (from_date != null) map['from_date'] = from_date;
    if (to_date != null) map['to_date'] = to_date;
    if (search != null) map['search'] = search;
    if (service_type != null) map['service_type'] = search;

    try {
      var res = await _scheduleRepo.notCompleted(map);
      isLoading.value = false;
      if (res is List<ScheduleInfoModel>) {
        // ScheduleInfoModel sc = res[0];
        // res.add(sc);
        // res.add(sc);
        // res.add(sc);
        print(
            '........................getTodaySchedule............${res.length}...............');

        notCompletedList.value = res;
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

  toBeCompleted(String? support_engineer, String? from_date, String? to_date,
      String? search, String? service_type) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {"lang": lang};

    if (support_engineer != null) map['support_engineer'] = support_engineer;
    if (from_date != null) map['from_date'] = from_date;
    if (to_date != null) map['to_date'] = to_date;
    if (search != null) map['search'] = search;
    if (service_type != null) map['service_type'] = search;

    try {
      var res = await _scheduleRepo.toBeCompleted(map);
      isLoading.value = false;
      if (res is List<ScheduleInfoModel>) {
        // ScheduleInfoModel sc = res[0];
        // res.add(sc);
        // res.add(sc);
        // res.add(sc);
        print(
            '........................toBeCompleted............${res.length}...............');

        toBeCompletedList.value = res;
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


  Future<ComplainDetailsModel?> complainDetails(String? service_type, String? ticket_no) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {"lang": lang};

    if (service_type != null) map['service_type'] = service_type;
    if (ticket_no != null) map['ticket_no'] = ticket_no;


    try {
      var res = await _scheduleRepo.complainDetails(map);
      isLoading.value = false;
      if (res is ComplainDetailsModel) {
        // ScheduleInfoModel sc = res[0];
        // res.add(sc);
        // res.add(sc);
        // res.add(sc);
        print(
            '........................complainDetails............${res}...............');

        complainDetailsModel.value = res;
        status.value = Status.SUCCESS;
        return res;
      } else {
        status.value = Status.ERROR;
      }
      Fluttertoast.showToast(msg: res);
      return null;
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
      return null;
    }
  }



  Future<ComplainDetailsModel?> complainDetailsBySearch(String? ticket_no) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {"lang": lang};

 //   if (service_type != null) map['service_type'] = service_type;
    if (ticket_no != null) map['ticket_no'] = ticket_no;


    try {
      var res = await _scheduleRepo.complainDetailsBySearch(map);
      isLoading.value = false;
      if (res is ComplainDetailsModel) {
        // ScheduleInfoModel sc = res[0];
        // res.add(sc);
        // res.add(sc);
        // res.add(sc);
        print(
            '........................complainDetailsBySearch............${res}...............');

        complainDetailsModel.value = res;
        status.value = Status.SUCCESS;
        return res;
      } else {
        status.value = Status.ERROR;
      }
      Fluttertoast.showToast(msg: res);
      return null;
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
      return null;
    }
  }



  Future<String> loadAllSchedull(String? support_engineer, String? from_date, String? to_date,
      String? search, String? service_type) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {"lang": lang};

    if (support_engineer != null) map['support_engineer'] = support_engineer;
    if (from_date != null) map['from_date'] = from_date;
    if (to_date != null) map['to_date'] = to_date;
    if (search != null && search.length>0) map['search'] = search;
    if (service_type != null) map['service_type'] = service_type;

    print('....................service...........map.....${map}................ ');

    try {
      var completedres = await _scheduleRepo.completed(map);


      if (completedres is List<ScheduleInfoModel>)
        completedList.value = completedres;

      var toBeCompleted = await _scheduleRepo.toBeCompleted(map);
      if (toBeCompleted is List<ScheduleInfoModel>)
        toBeCompletedList.value = toBeCompleted;


      var notCompleted = await _scheduleRepo.notCompleted(map);
      if (notCompleted is List<ScheduleInfoModel>)
        notCompletedList.value = notCompleted;

      isLoading.value = false;
      status.value = Status.SUCCESS;
      return "success";
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
      return "error";
    }
  }



  Future<String> fatchNextPageData(String? support_engineer, String? from_date, String? to_date,
      String? search, String? service_type) async {
    // status.value = Status.LOADING;
    // isLoading.value = true;
     isCompletedNextPageLoaded.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? p = (await MySharedPreference.getString(SharedPrefKey.COMPLETED_PAGE_NUMBER));
  int page=int.parse(p??'1');
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {"lang": lang};

    if (support_engineer != null) map['support_engineer'] = support_engineer;
    if (from_date != null) map['from_date'] = from_date;
    if (to_date != null) map['to_date'] = to_date;
    if (search != null && search.length>0) map['search'] = search;
    if (service_type != null) map['service_type'] = service_type;

     map['page'] = (page+1);

    print('....................service.........(page+1)..map.....${(map)}................ ');

    try {
      var completedres = await _scheduleRepo.completed(map);
      isCompletedNextPageLoaded.value = false;
      if (completedres is List<ScheduleInfoModel>) {
        if (completedres.length > 0) {
       //   completedPageNumber.value = completedPageNumber.value + 1;
          completedList.value!.addAll(completedres);
          print('....................service...........completedList.value.....${completedList.value?.length}................ ');
        } else {
          Fluttertoast.showToast(msg: 'no more data found');
        }
        print(
            '........................completedres............${completedres
                .length}...............');
      }
      // isLoading.value = false;
      // status.value = Status.SUCCESS;
      return "success";
    } catch (e) {
     // status.value = Status.ERROR;
   //   isLoading.value = false;
      return "error";
    }
  }


  makeSchedule(String service_type,String? ticket_no,String? assigned_support_engineer
      ,String? assigned_date ,String? assigned_slot) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {
      'user_id': customerId,
      'ticket_no': ticket_no,
      'service_type': service_type,
      'assigned_support_engineer': assigned_support_engineer,
      'assigned_date': assigned_date,
      'assigned_slot': assigned_slot,
      "lang": lang
    };

    print('..........makeSchedule ${map}');
    try {
      var res = await _scheduleRepo.makeSchedule(map);
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






 Future<String> backToFollowUp(String? ticket_no) async {
    // status.value = Status.LOADING;
    // isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {
      'user_id': customerId,
      'ticket_no': ticket_no,
      "lang": lang
    };
    try {
      var res = await _scheduleRepo.backToFollowUp(map);
     // isLoading.value = false;
      if (res == 'success') {
        print('................................backToFollowUp....${res}...............');

        return 'success';
      //  status.value = Status.SUCCESS;
      } else {
      //  status.value = Status.ERROR;
       // Fluttertoast.showToast(msg: 'err');
        return 'error';
      }
      Fluttertoast.showToast(msg: res);
    } catch (e) {
      return 'error';
     // status.value = Status.ERROR;
     // isLoading.value = false;
    }
  }


 Future<String> completedBySupervisor(String? ticket_no,String service_type) async {
    // status.value = Status.LOADING;
    // isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {
      'user_id': customerId,
      'ticket_no': ticket_no,
      'service_type': service_type,
      "lang": lang
    };
    try {
      var res = await _scheduleRepo.completedBySupervisor(map);
     // isLoading.value = false;
      if (res == 'success') {
        print('................................completedBySupervisor....${res}...............');

        return 'success';
      //  status.value = Status.SUCCESS;
      } else {
      //  status.value = Status.ERROR;
       // Fluttertoast.showToast(msg: 'err');
        return 'error';
      }
      Fluttertoast.showToast(msg: res);
    } catch (e) {
      return 'error';
     // status.value = Status.ERROR;
     // isLoading.value = false;
    }
  }


 Future<String> reschedule(String service_type,String? ticket_no) async {
    // status.value = Status.LOADING;
    // isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {
      'user_id': customerId,
      'ticket_no': ticket_no,
      'service_type': service_type,
      "lang": lang
    };
    try {
      var res = await _scheduleRepo.reschedule(map);
     // isLoading.value = false;
      if (res == 'success') {
        print('................................reschedule....${res}...............');

        return 'success';
      //  status.value = Status.SUCCESS;
      } else {
      //  status.value = Status.ERROR;
       // Fluttertoast.showToast(msg: 'err');
        return 'error';
      }
      Fluttertoast.showToast(msg: res);
    } catch (e) {
      return 'error';
     // status.value = Status.ERROR;
     // isLoading.value = false;
    }
  }


 Future<String> goingNow(String service_type,String? ticket_no) async {
    // status.value = Status.LOADING;
    // isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {
      'user_id': customerId,
      'ticket_no': ticket_no,
      'service_type': service_type,
      "lang": lang
    };
    try {
      var res = await _scheduleRepo.goingNow(map);
     // isLoading.value = false;
      if (res == 'success') {
        print('................................reschedule....${res}...............');

        return 'success';
      //  status.value = Status.SUCCESS;
      } else {
      //  status.value = Status.ERROR;
       // Fluttertoast.showToast(msg: 'err');
        return 'error';
      }
      Fluttertoast.showToast(msg: res);
    } catch (e) {
      return 'error';
     // status.value = Status.ERROR;
     // isLoading.value = false;
    }
  }


  setScheduler(int? support_enginner_id,String? date) async {
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {
  //    'customer_id': customerId,
      "lang": lang
    };

    if (support_enginner_id != null) {
      map['support_enginner_id'] = support_enginner_id;
    }
    if (date != null) map['date'] = date;
print('................setScheduler data ${map}...................................');
    try {
      var res = await _scheduleRepo.setScheduler(map);
      isLoading.value = false;
      if (res is String&&res.toLowerCase() == 'success') {
        print('....................................${res}...............');
        Fluttertoast.showToast(msg: res);
        status.value = Status.SUCCESS;
      } else {
        Fluttertoast.showToast(msg: "Failed");
        status.value = Status.ERROR;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed");
      status.value = Status.ERROR;
      isLoading.value = false;
    }
  }


  remove_scheduler(String? id) async {
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());
    Map<String, dynamic> map = {
  //    'customer_id': customerId,
      "lang": lang,
      "id": id,
    };

print('................remove_scheduler  ${map}...................................');
    try {
      var res = await _scheduleRepo.remove_scheduler(map);
      if (res is String&&res.toLowerCase() == 'success') {
        print('....................................${res}...............');
        Fluttertoast.showToast(msg: res);
      } else {
        Fluttertoast.showToast(msg: "Failed");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed");
    }
  }


  Future<String?> submitCompleteOrNotComplete(
      String ticket_no,
      String service_type,
      int is_completed,
      String spare_parts,
      String note,
      String support_action,
      String? imageFile,
      String? videoFile,
      ) async {
    String? picUrl = null;
    status.value = Status.LOADING;
    isLoading.value = true;
    int? customerId = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    try {
      var res = await _scheduleRepo.submitCompleteOrNotComplete(
          ticket_no,service_type,is_completed,spare_parts,note,support_action,imageFile,videoFile
      );
      isLoading.value = false;
      if (res is String) {
        picUrl = res;
        status.value = Status.SUCCESS;
        Fluttertoast.showToast(msg: 'Success');
      } else {
        status.value = Status.ERROR;
        Fluttertoast.showToast(msg: 'Failed');
      }
    } catch (e) {
      status.value = Status.ERROR;
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Failed');
    }
    return picUrl;
  }


  Future<List<dynamic>> schedulerList() async {
    int? ic = (await MySharedPreference.getInt(SharedPrefKey.USER_ID));
    String? lang = (await MySharedPreference.getLanguage());

    Map<String, dynamic> map = {};
    map = {"lang": lang};
    try {
      var res = await _scheduleRepo.scheduler_list();

      if (res is List<dynamic>) {
        return res;
      } else {
        throw throw Exception("Error");
      }
    } catch (e) {
      throw throw Exception("Error");
    }
  }
}
