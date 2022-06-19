import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:wts_support_engineer/api/home_api_service.dart';
import 'package:wts_support_engineer/api/utils/network_info.dart';
import 'package:wts_support_engineer/model/dashboard_info_model.dart';


abstract class HomeRepository {
  Future<dynamic> dashboard(Map<String, dynamic> map);
  Future<dynamic> changeProfilePic(int custome_id,String filePath);
}

class HomeRepositoryImpl implements HomeRepository {
  HomeApiService homeApiService = HomeApiService.create();

  NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());

  @override
  Future<dynamic> dashboard(Map<String, dynamic> map) async {
    try {
      var res = await homeApiService.dashboard(map);

      print("....................dashboard response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        return DashBoardInfoModel.fromJson(res.body);
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      print('...................res res res res       ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> changeProfilePic(int id, String filePath) async {
    try {
      var res = await homeApiService.uploadProfilePic(id,filePath);
      print("....................uploadProfilePic error response ${res.error.toString()}.........................");
      print("....................uploadProfilePic seccess response ${res.body.toString()}.........................");
      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        return res.body['customer_info']['image'];
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      print('...................res res res res       ${e}');
      throw throw Exception("Error");
    }
  }
}
