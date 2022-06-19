import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:wts_support_engineer/api/auth_api_service.dart';
import 'package:wts_support_engineer/api/utils/network_info.dart';
import 'package:wts_support_engineer/model/login_info_model.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/util/shared_pref_key.dart';


abstract class AuthRepository {
  Future<dynamic> login(Map<String, dynamic> map);
  Future<dynamic> language();
  Future<dynamic> getLanguageWiseContents(Map<String, dynamic> map);
  Future<dynamic> changePassword(Map<String, dynamic> map);
  Future<dynamic> forgetPassword(Map<String, dynamic> map);
  Future<dynamic> verifyCode(Map<String, dynamic> map);
}

class AuthRepositoryImpl implements AuthRepository {
  AuthApiService authApiService = AuthApiService.create();

  NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());

  @override
  Future<dynamic> login(Map<String, dynamic> map) async {
    try {
      var res = await authApiService.login(map);

      print(
          "....................login response ${res}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {

        String message = res.body['message'];
        if(message=="success"){
          return UserInfoModel.fromJson(res.body['users']);

        }else{
          return message;
        }
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      print('...................res res res res       ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> language() async {
    try {
      var res = await authApiService.getLanguage();

      print(
          "....................language response ${res}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
        return res.body['language'];
       // // String message = res.body['message'];
       //  if(message=="success"){
       //    return UserInfoModel.fromJson(res.body['language']);
       //
       //  }else{
       //    return message;
       //  }
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      print('...................res res res res       ${e}');
      throw throw Exception("Error");
    }
  }

  @override
  Future<dynamic> getLanguageWiseContents(Map<String, dynamic> map) async {
    try {
      var res = await authApiService.getLanguageWiseContents(map);

      print(
          "....................language response ${res.body}.........................");

      if (!res.isSuccessful) {
        throw Exception("Error");
      } else if (res.isSuccessful) {
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
  Future<dynamic> changePassword(Map<String, dynamic> map) async{
    try {
      var res =  await authApiService.changePassword(map);
      print(
          "....................changePassword response ${res.body}.........................");
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
  Future<dynamic> forgetPassword(Map<String, dynamic> map) async{
    try {
      var res =  await authApiService.forgetPassword(map);
      print(
          "....................forgetPassword response ${res.body}.........................");
      if (!res.isSuccessful) {
        throw res.body;
      } else if (res.isSuccessful) {
        var message = res.body['message'];
        if(message=='success')
        MySharedPreference.setInt(
            SharedPrefKey.USER_ID, int.parse(res.body['id'].toString()) );
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
  Future<dynamic>  verifyCode(Map<String, dynamic> map) async{
    try {
      var res =  await authApiService.verifyCode(map);
      print(
          "....................verifyCode response ${res.body}.........................");
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

}
