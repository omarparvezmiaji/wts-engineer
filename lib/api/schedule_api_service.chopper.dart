// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ScheduleApiService extends ScheduleApiService {
  _$ScheduleApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ScheduleApiService;

  @override
  Future<Response<dynamic>> to_be_completed(Map<String, dynamic> body) {
    final $url = '/api/to_be_completed';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> not_completed(Map<String, dynamic> body) {
    final $url = '/api/not_completed';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> completed(Map<String, dynamic> body) {
    final $url = '/api/completed';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> details(Map<String, dynamic> body) {
    final $url = '/api/details';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> search_details(Map<String, dynamic> body) {
    final $url = '/api/search_details';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> goingNow(Map<String, dynamic> body) {
    final $url = '/api/going_now';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> reschedule(Map<String, dynamic> body) {
    final $url = '/api/reschedule';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> makeSchedule(Map<String, dynamic> body) {
    final $url = '/api/make_schedule';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> statistics(Map<String, dynamic> body) {
    final $url = '/api/statistics';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> submitCompleteOrNotCompletedWithImage(
      String ticket_no,
      String service_type,
      int is_completed,
      String spare_parts,
      String note,
      String support_action,
      String imageFile) {
    final $url = '/api/complete';
    final $parts = <PartValue>[
      PartValue<String>('ticket_no', ticket_no),
      PartValue<String>('service_type', service_type),
      PartValue<int>('is_completed', is_completed),
      PartValue<String>('spare_parts', spare_parts),
      PartValue<String>('note', note),
      PartValue<String>('support_action', support_action),
      PartValueFile<String>('image', imageFile)
    ];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> submitCompleteOrNotCompletedWithVideo(
      String ticket_no,
      String service_type,
      int is_completed,
      String spare_parts,
      String note,
      String support_action,
      String videoFile) {
    final $url = '/api/complete';
    final $parts = <PartValue>[
      PartValue<String>('ticket_no', ticket_no),
      PartValue<String>('service_type', service_type),
      PartValue<int>('is_completed', is_completed),
      PartValue<String>('spare_parts', spare_parts),
      PartValue<String>('note', note),
      PartValue<String>('support_action', support_action),
      PartValueFile<String>('video', videoFile)
    ];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> submitCompleteOrNotCompletedWithoutMedia(
      String ticket_no,
      String service_type,
      int is_completed,
      String spare_parts,
      String note,
      String support_action) {
    final $url = '/api/complete';
    final $parts = <PartValue>[
      PartValue<String>('ticket_no', ticket_no),
      PartValue<String>('service_type', service_type),
      PartValue<int>('is_completed', is_completed),
      PartValue<String>('spare_parts', spare_parts),
      PartValue<String>('note', note),
      PartValue<String>('support_action', support_action)
    ];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> completedBySupervisor(Map<String, dynamic> body) {
    final $url = '/api/completed_by_supervisor';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> backToFollowUp(Map<String, dynamic> body) {
    final $url = '/api/back_to_follow_up';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> setScheduler(Map<String, dynamic> body) {
    final $url = '/api/set_scheduler';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> remove_scheduler(Map<String, dynamic> body) {
    final $url = '/api/remove_scheduler';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> scheduler_list() {
    final $url = '/api/scheduler_list';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
