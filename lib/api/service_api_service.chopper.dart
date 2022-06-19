// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ServiceApiService extends ServiceApiService {
  _$ServiceApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ServiceApiService;

  @override
  Future<Response<dynamic>> scheduleToday(Map<String, dynamic> body) {
    final $url = '/api/schedule_today';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> scheduleUpcoming(Map<String, dynamic> body) {
    final $url = '/api/schedule_upcoming';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> schedulePast(Map<String, dynamic> body) {
    final $url = '/api/schedule_past';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> setSchedule(Map<String, dynamic> body) {
    final $url = '/api/set_schedule';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

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
  Future<Response<dynamic>> spareParts(Map<String, dynamic> body) {
    final $url = '/api/spare_parts';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> customerList() {
    final $url = '/api/customer_list';
    final $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> slot(Map<String, dynamic> body) {
    final $url = '/api/slot';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> item_wise_services(Map<String, dynamic> body) {
    final $url = '/api/item_wise_services';
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
  Future<Response<dynamic>> supportEngineers() {
    final $url = '/api/support_engineers';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> support_action(Map<String, dynamic> body) {
    final $url = '/api/support_action';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> customer_list(Map<String, dynamic> body) {
    final $url = '/api/customer_list';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> customer_wise_products(Map<String, dynamic> body) {
    final $url = '/api/customer_wise_products';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> complain_create(Map<String, dynamic> body) {
    final $url = '/api/complain_create';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
