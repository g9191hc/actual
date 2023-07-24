import 'package:actual/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  // 요청을 보낼때(보내기직전) : onRequest+Tab(자동완성)
  // RequestOptions에는 요청시의 모든 정보(주소, 경로('/'등), 헤더 등)가 담겨있음
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}, ${options.uri}');
    //헤더에 인증키 값을 'true'로 보내온 경우 인증키가 필요한 요청으로 보고 실제 토큰으로 대체(하기로 정해놓음)
    if (options.headers[AUTHORIZATION_KEY] == 'true') {
      options.headers.remove(AUTHORIZATION_KEY); //true들어 있는 기존키 삭제
      final token =
          await storage.read(key: ACCESS_TOKEN_KEY); //저장되어 있는 액세스토큰 가져옴
      options.headers
          .addAll({AUTHORIZATION_KEY: 'Bearer $token'}); //새 키값을 넣어 재생성
    }

    super.onRequest(options, handler);
  }

// 요청에 실패 했을 때(액세스 토큰 만료시 등) : onError+Tab(자동완성)
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    //handler.reject() 실행시 요청실패 처리됨
    if (refreshToken == null) return handler.reject(err);

    final isStatus401 = err.response?.statusCode == 401;
    final isRefreshPath = err.requestOptions.path == '/auth/token';

    //401에러(액세스토큰 사용불가)이면서 액세스토큰 요청이 아니면, 먼저 새 액세스토큰을 요청하한 후, 그 액세스토큰으로 기존요청 처리
    if (isStatus401 && !isRefreshPath) {
      final dio = Dio();

      //dio예외 잡기
      try {
        //새 액세스토큰 요청
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {AUTHORIZATION_KEY: 'Bearer $refreshToken'},
          ),
        );

        //새 액세스토큰
        final accessToken = resp.data[ACCESS_TOKEN_KEY];

        //기존 요청을 가져와서 새 액세스토큰을 요청에 덮어쓰기(키가 동일하므로 덮어써짐)
        final options = err.requestOptions;
        options.headers.addAll({AUTHORIZATION_KEY: 'Bearer $accessToken'});

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

      } on DioException catch (e) {
        //handler.reject
        handler.reject(e);
      }
    }

    //handler.resolve() 실행시 요청성공 처리
    handler.resolve(response);
    super.onError(err, handler);
  }

// 요청에 대한 응답을 받았을 때 : onResponse+Tab(자동완성)
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}
