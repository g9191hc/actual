import 'package:actual/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {

  CustomInterceptor();

  //요청을 보낼때(보내기직전)
  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}, ${options.uri}');

    if (options.headers[AUTHORIZATION_KEY] == 'true') {
      options.headers.remove(AUTHORIZATION_KEY); //true들어 있는 기존키 삭제
      final token = await storage.read(key: ACCESS_TOKEN_KEY); //저장되어 있는 액세스토큰 가져옴
      options.headers.addAll({AUTHORIZATION_KEY: 'Bearer $token'}); //새 키값을 넣어 재생성
    }

    super.onRequest(options, handler);
  }

  //요청에 실패 했을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }

  //요청에 대한 응답을 받았을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}