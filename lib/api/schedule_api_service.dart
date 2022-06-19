import 'package:chopper/chopper.dart';
import 'package:wts_support_engineer/util/static_key.dart';

import 'utils/httpinterceptor.dart';

part 'schedule_api_service.chopper.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

@ChopperApi()
abstract class ScheduleApiService extends ChopperService{

  @Post(path: "/api/to_be_completed")
  Future<Response> to_be_completed(@Body() Map<String,dynamic> body);

  @Post(path: "/api/not_completed")
  Future<Response> not_completed(@Body() Map<String,dynamic> body);

  @Post(path: "/api/completed")
  Future<Response> completed(@Body() Map<String,dynamic> body);


  @Post(path: "/api/details")
  Future<Response> details(@Body() Map<String,dynamic> body);



  @Post(path: "/api/search_details")
  Future<Response> search_details(@Body() Map<String,dynamic> body);



  @Post(path: "/api/going_now")
  Future<Response> goingNow(@Body() Map<String,dynamic> body);


  @Post(path: "/api/reschedule")
  Future<Response> reschedule(@Body() Map<String,dynamic> body);


  @Post(path: "/api/make_schedule")
  Future<Response> makeSchedule(@Body() Map<String,dynamic> body);




  @Post(path: "/api/statistics")
  Future<Response> statistics(@Body() Map<String,dynamic> body);


  @Post(path: '/api/complete')
  @multipart
  Future<Response> submitCompleteOrNotCompletedWithImage(
      @Part("ticket_no") String ticket_no,
      @Part("service_type") String service_type,
      @Part("is_completed") int is_completed,
      @Part("spare_parts") String spare_parts,
      @Part("note") String note,
      @Part("support_action") String support_action,
      @PartFile('image') String imageFile);

  @Post(path: '/api/complete')
  @multipart
  Future<Response> submitCompleteOrNotCompletedWithVideo(
      @Part("ticket_no") String ticket_no,
      @Part("service_type") String service_type,
      @Part("is_completed") int is_completed,
      @Part("spare_parts") String spare_parts,
      @Part("note") String note,
      @Part("support_action") String support_action,
      @PartFile('video') String videoFile
      );
  @Post(path: '/api/complete')
  @multipart
  Future<Response> submitCompleteOrNotCompletedWithoutMedia(
      @Part("ticket_no") String ticket_no,
      @Part("service_type") String service_type,
      @Part("is_completed") int is_completed,
      @Part("spare_parts") String spare_parts,
      @Part("note") String note,
      @Part("support_action") String support_action);

  @Post(path: "/api/completed_by_supervisor")
  Future<Response> completedBySupervisor(@Body() Map<String,dynamic> body);




  @Post(path: "/api/back_to_follow_up")
  Future<Response> backToFollowUp(@Body() Map<String,dynamic> body);

  @Post(path: "/api/set_scheduler")
  Future<Response> setScheduler(@Body() Map<String,dynamic> body);


  @Post(path: "/api/remove_scheduler")
  Future<Response> remove_scheduler(@Body() Map<String,dynamic> body);


  @Get(path: "/api/scheduler_list")
  Future<Response> scheduler_list();



  static ScheduleApiService create() {
    final ChopperClient? client = ChopperClient(
      baseUrl: StaticKey.BASE_URL,
      services: [
        _$ScheduleApiService(),
      ],
      converter: JsonConverter(),
      interceptors: [HttpLoggingInterceptor(),HeaderInterceptor()],
    );
    return _$ScheduleApiService(client);
  }

}