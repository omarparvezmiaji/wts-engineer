import 'dart:async';
import 'package:chopper/chopper.dart';

// 1
class HeaderInterceptor implements RequestInterceptor {
  // 2
  static const String AUTH_HEADER = "Authorization";
  static const String X_Localization = "X-Localization";

  // 3
  static const String BEARER = "Bearer ";

  // 4
  static const String V4_AUTH_HEADER = "< your key here >";

  @override
  FutureOr<Request> onRequest(Request request) async {
    // 5
    Request newRequest = request.copyWith(headers: {X_Localization: 'en',
    AUTH_HEADER: BEARER + V4_AUTH_HEADER,
    "Content-Type":"application/json",
    'Charset':'utf-8',
    "Accept":"application/json"});
    return newRequest;
  }
}
