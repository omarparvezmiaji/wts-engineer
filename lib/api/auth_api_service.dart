

import 'package:chopper/chopper.dart';
import 'package:wts_support_engineer/util/static_key.dart';

import 'utils/httpinterceptor.dart';

part 'auth_api_service.chopper.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

@ChopperApi()
abstract class AuthApiService extends ChopperService{


  @Get(path: "/api/languages")
  Future<Response> getLanguage();

  @Post(path: "/api/language-wiseContents")
  Future<Response> getLanguageWiseContents(@Body() Map<String,dynamic> body);

  @Post(path: '/api/supervisor-login')
  Future<Response> login(
      @Body() Map<String,dynamic> body);

  @Post(path: '/api/change_password')
  Future<Response> changePassword(
      @Body() Map<String,dynamic> body);

  @Post(path: '/api/forget_password')
  Future<Response> forgetPassword(
      @Body() Map<String,dynamic> body);


  @Post(path: '/api/verify_code')
  Future<Response> verifyCode(
      @Body() Map<String,dynamic> body);

  static AuthApiService create() {
    final ChopperClient? client = ChopperClient(
      baseUrl: StaticKey.BASE_URL,
      services: [
        _$AuthApiService(),
      ],
      converter: JsonConverter(),
      interceptors: [HttpLoggingInterceptor(),HeaderInterceptor()],
    );
    return _$AuthApiService(client);
  }

}