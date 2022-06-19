import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:wts_support_engineer/api/auth_api_service.dart';
import 'package:wts_support_engineer/api/schedule_api_service.dart';
import 'package:wts_support_engineer/api/service_api_service.dart';
import 'package:wts_support_engineer/api/utils/network_info.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/model/schedule_info_model.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';


abstract class ServiceRepository {

  Future<dynamic> scheduleToday(Map<String, dynamic> map);
  Future<dynamic> scheduleUpcoming(Map<String, dynamic> map);
  Future<dynamic> schedulePast(Map<String, dynamic> map);
  Future<dynamic> setSchedule(Map<String, dynamic> map);
  Future<dynamic> support_action(Map<String, dynamic> map);
  Future<dynamic> spareParts(Map<String, dynamic> map);
  Future<dynamic> supportEngineer();
  Future<dynamic> customerList(Map<String, dynamic> map);
  Future<dynamic> customerWisePorducts(Map<String, dynamic> map);
  Future<dynamic> timeSlot(Map<String, dynamic> map);
  Future<dynamic> item_wise_services(Map<String, dynamic> map);
  Future<dynamic> statistics(Map<String, dynamic> map);
  Future<dynamic> createComplain(Map<String, dynamic> map);

}

class ScrviceRepositoryImpl implements ServiceRepository {
  ServiceApiService apiservice = ServiceApiService.create();

  NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());


  @override
  Future<dynamic>  schedulePast(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.schedulePast(map);

      print(
          "....................schedulePast response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['scheduled'];
        return list.map((e) => ScheduleInfoModel.fromJson(e)).toList();
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
  Future<dynamic>  scheduleToday(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.scheduleToday(map);

      print(
          "....................scheduleToday response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {

        dynamic is_scheduler=res.body['is_scheduler'];
        if(is_scheduler==1||is_scheduler=='1'){
          MySharedPreference.setBoolean(SharedPrefKey.ISSCHEDULER,true);
        }else{
          MySharedPreference.setBoolean(SharedPrefKey.ISSCHEDULER,false);
        }

        List list = res.body['scheduled'];
        return list.map((e) => ScheduleInfoModel.fromJson(e)).toList();
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
  Future<dynamic>  scheduleUpcoming(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.scheduleUpcoming(map);

      print(
          "....................scheduleUpcoming response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['scheduled'];
        return list.map((e) => ScheduleInfoModel.fromJson(e)).toList();
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
  Future<dynamic>  setSchedule(Map<String, dynamic> map) async{
    try {
      var res = await apiservice.setSchedule(map);

      print(
          "....................setSchedule response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['scheduled'];
        return list.map((e) => ScheduleInfoModel.fromJson(e)).toList();
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
  Future<List<dynamic>> support_action(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.support_action(map);

      print(
          "....................support_action response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['support_action'];
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


  @override
  Future<List<dynamic>> spareParts(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.spareParts(map);

      print(
          "....................spareParts response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['spare_parts'];
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

  @override
  Future<List<dynamic>> supportEngineer() async {
    try {
      var res = await apiservice.supportEngineers();

      print(
          "....................supportEngineers response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['users'];
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


  @override
  Future<List<dynamic>> timeSlot(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.slot(map);

      print(
          "....................timeSlot response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['slots'];
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

  @override
  Future<List<dynamic>> item_wise_services(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.item_wise_services(map);

      print(
          "....................item_wise_services response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['item_wise_services'];
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


  @override
  Future<dynamic> statistics(Map<String, dynamic> map) async {
    try {
      var res = await apiservice.statistics(map);

      print(
          "....................statistics response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        Map map = res.body['statistics'];
        return map;
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
  Future<List<dynamic>>  customerList(Map<String, dynamic> map)  async {
    try {
      var res = await apiservice.customer_list(map);

      print(
          "....................customers response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['customers'];
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
  @override
  Future<List<dynamic>>  customerWisePorducts(Map<String, dynamic> map)   async {
    try {
      var res = await apiservice.customer_wise_products(map);

      print(
          "....................customer_wise_products response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        List list = res.body['products'];
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


  @override
  Future<dynamic>  createComplain(Map<String, dynamic> map)   async {
    try {
      var res = await apiservice.complain_create(map);

      print(
          "....................createComplain response ${res.error}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        var mess = res.body['message'];
        return mess;
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