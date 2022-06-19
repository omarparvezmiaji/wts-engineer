import 'package:chopper/chopper.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:wts_support_engineer/api/auth_api_service.dart';
import 'package:wts_support_engineer/api/schedule_api_service.dart';
import 'package:wts_support_engineer/api/utils/network_info.dart';
import 'package:wts_support_engineer/model/complain_details_model.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/model/schedule_info_model.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';

abstract class SchedulerRepository {
  Future<dynamic> toBeCompleted(Map<String, dynamic> map);

  Future<dynamic> notCompleted(Map<String, dynamic> map);

  Future<dynamic> completed(Map<String, dynamic> map);

  Future<dynamic> complainDetails(Map<String, dynamic> map);

  Future<dynamic> complainDetailsBySearch(Map<String, dynamic> map);

  Future<dynamic> goingNow(Map<String, dynamic> map);

  Future<dynamic> reschedule(Map<String, dynamic> map);

  Future<dynamic> makeSchedule(Map<String, dynamic> map);

  Future<dynamic> statistics(Map<String, dynamic> map);

  Future<dynamic> completedBySupervisor(Map<String, dynamic> map);

  Future<dynamic> backToFollowUp(Map<String, dynamic> map);

  Future<dynamic> setScheduler(Map<String, dynamic> map);

  Future<dynamic> scheduler_list();

  Future<dynamic> remove_scheduler(Map<String, dynamic> map);

  Future<dynamic> submitCompleteOrNotComplete(
    String ticket_no,
    String service_type,
    int is_completed,
    String spare_parts,
    String note,
    String support_action,
    String? imageFile,
    String? videoFile,
  );
}

class SchedulerRepositoryImpl implements SchedulerRepository {
  ScheduleApiService apiservice = ScheduleApiService.create();

  NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());

  @override
  Future<dynamic> completed(Map<String, dynamic> map) async {
    try {
      print(
          "....................completed request ${map}.........................");
      var res = await apiservice.completed(map);
      print(
          "....................completed response ${res.error}.........................");
      print( "....................completed response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        dynamic total_page = res.body['total_page'];
        MySharedPreference.setString(
            SharedPrefKey.COMPLETED_PAGE_NUMBER, total_page.toString());
        List list = res.body['scheduled'];
        return list.map((e) => ScheduleInfoModel.fromJson(e)).toList();
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> notCompleted(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.not_completed(map);
      print(
          "....................notCompleted response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        List list = res.body['scheduled'];
        return list.map((e) => ScheduleInfoModel.fromJson(e)).toList();
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> toBeCompleted(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.to_be_completed(map);
      print(
          "....................toBeCompleted response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        List list = res.body['scheduled'];
        return list.map((e) => ScheduleInfoModel.fromJson(e)).toList();
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> complainDetails(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.details(map);
      print(
          "....................complainDetails response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var complain_details = res.body['complain_details'];
        return ComplainDetailsModel.fromJson(complain_details);
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> complainDetailsBySearch(Map<String, dynamic> map) async {
    try {
      print(
          "....................search_details map ${map}.........................");
      var res = await apiservice.search_details(map);
      print(
          "....................search_details response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var complain_details = res.body['complain_details'];
        return ComplainDetailsModel.fromJson(complain_details);
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> backToFollowUp(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.backToFollowUp(map);
      print(
          "....................backToFollowUp response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var message = res.body['message'];
        return message;
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> completedBySupervisor(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.completedBySupervisor(map);
      print(
          "....................completedBySupervisor response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var message = res.body['message'];
        return message;
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> goingNow(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.goingNow(map);
      print(
          "....................goingNow response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var message = res.body['message'];
        return message;
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> makeSchedule(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.makeSchedule(map);
      print(
          "....................makeSchedule response ${res.error}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var message = res.body['message'];
        return message;
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> reschedule(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.reschedule(map);
      print(
          "....................reschedule response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var message = res.body['message'];
        return message;
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> setScheduler(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.setScheduler(map);
      print(
          "....................setScheduler response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var message = res.body['message'];
        return message;
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> statistics(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> submitCompleteOrNotComplete(
      String ticket_no,
      String service_type,
      int is_completed,
      String spare_parts,
      String note,
      String support_action,
      String? imageFile,
      String? videoFile) async {
    try {
      Response res;

      if (imageFile != null) {
        res = await apiservice.submitCompleteOrNotCompletedWithImage(
            ticket_no,
            service_type,
            is_completed,
            spare_parts,
            note,
            support_action,
            imageFile);
        print(
            '.......submitCompleteOrNotCompletedWithImage...............${ticket_no}   ${service_type}  ${is_completed} ${spare_parts}  ${note} ${support_action} '
            '${imageFile}...................');
      } else if (videoFile != null) {
        res = await apiservice.submitCompleteOrNotCompletedWithVideo(
            ticket_no,
            service_type,
            is_completed,
            spare_parts,
            note,
            support_action,
            videoFile);
      } else {
        res = await apiservice.submitCompleteOrNotCompletedWithoutMedia(
            ticket_no,
            service_type,
            is_completed,
            spare_parts,
            note,
            support_action);
      }

      print(
          "....................submitCompleteOrNotComplete response ${res.error}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var message = res.body['message'];
        return message;
      } else {
        return res.error;
      }
    } catch (e) {
      print('...........exception........ ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> remove_scheduler(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.remove_scheduler(map);

      print(
          "....................remove_scheduler response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        String result = res.body['message'];
        return result;
        return res.body['contents'];
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      print('...................res res res res       ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> scheduler_list() async {
    try {
      var res = await apiservice.scheduler_list();

      print(
          "....................scheduler_list response ${res.error}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body;
        return list;
        return res.body['contents'];
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      print('...................res res res res       ${e}');
      throw throw Exception("Error");
    }
  }
}
