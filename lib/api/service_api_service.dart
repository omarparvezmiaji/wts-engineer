import 'package:chopper/chopper.dart';
import 'package:wts_support_engineer/util/static_key.dart';

import 'utils/httpinterceptor.dart';

part 'service_api_service.chopper.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

@ChopperApi()
abstract class ServiceApiService extends ChopperService{


  @Post(path: "/api/schedule_today")
  Future<Response> scheduleToday(@Body() Map<String,dynamic> body);

  @Post(path: "/api/schedule_upcoming")
  Future<Response> scheduleUpcoming(@Body() Map<String,dynamic> body);



  @Post(path: "/api/schedule_past")
  Future<Response> schedulePast(@Body() Map<String,dynamic> body);



  @Post(path: "/api/set_schedule")
  Future<Response> setSchedule(@Body() Map<String,dynamic> body);



  @Post(path: "/api/to_be_completed")
  Future<Response> to_be_completed(@Body() Map<String,dynamic> body);

  @Post(path: "/api/not_completed")
  Future<Response> not_completed(@Body() Map<String,dynamic> body);

  @Post(path: "/api/completed")
  Future<Response> completed(@Body() Map<String,dynamic> body);


  @Post(path: "/api/spare_parts")
  Future<Response> spareParts(@Body() Map<String,dynamic> body);



  @Post(path: "/api/customer_list")
  Future<Response> customerList();



  @Post(path: "/api/slot")
  Future<Response> slot(@Body() Map<String,dynamic> body);




  @Post(path: "/api/item_wise_services")
  Future<Response> item_wise_services(@Body() Map<String,dynamic> body);




  @Post(path: "/api/statistics")
  Future<Response> statistics(@Body() Map<String,dynamic> body);



  @Get(path: "/api/support_engineers")
  Future<Response> supportEngineers();



  @Post(path: "/api/support_action")
  Future<Response> support_action(@Body() Map<String,dynamic> body);



  @Post(path: "/api/customer_list")
  Future<Response> customer_list(@Body() Map<String,dynamic> body);



  @Post(path: "/api/customer_wise_products")
  Future<Response> customer_wise_products(@Body() Map<String,dynamic> body);




  @Post(path: "/api/complain_create")
  Future<Response> complain_create(@Body() Map<String,dynamic> body);








  static ServiceApiService create() {
    final ChopperClient? client = ChopperClient(
      baseUrl: StaticKey.BASE_URL,
      services: [
        _$ServiceApiService(),
      ],
      converter: JsonConverter(),
      interceptors: [HttpLoggingInterceptor(),HeaderInterceptor()],
    );
    return _$ServiceApiService(client);
  }

}