import 'package:chopper/chopper.dart';
import 'package:wts_support_engineer/util/static_key.dart';

import 'utils/httpinterceptor.dart';

part 'home_api_service.chopper.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

@ChopperApi()
abstract class HomeApiService extends ChopperService{


  @Post(path: "/api/supervisor/dashboard")
  Future<Response> dashboard(@Body() Map<String,dynamic> body);


  @Post(path: '/api/supervisor/changeprofilepic')
  @multipart
  Future<Response> uploadProfilePic(
      @Part("user_id") int id, @PartFile('image') String file);

  static HomeApiService create() {
    final ChopperClient? client = ChopperClient(
      baseUrl: StaticKey.BASE_URL,
      services: [
        _$HomeApiService(),
      ],
      converter: JsonConverter(),
      interceptors: [HttpLoggingInterceptor(),HeaderInterceptor()],
    );
    return _$HomeApiService(client);
  }

}