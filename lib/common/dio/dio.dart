import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/user/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(storage: storage, ref: ref),
  );
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({required this.storage, required this.ref});

  // 요청을 보낼때(보내기직전) : onRequest+Tab(자동완성)
  // RequestOptions에는 요청시의 모든 정보(주소, 경로('/'등), 헤더 등)가 담겨있음
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    //헤더에 인증키 값을 'true'로 보내온 경우 인증키가 필요한 요청으로 보고 실제 토큰으로 대체(하기로 정해놓음)
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken'); //true들어 있는 기존키 삭제
      final token =
          await storage.read(key: ACCESS_TOKEN_KEY); //저장되어 있는 액세스토큰 가져옴
      options.headers.addAll({'authorization': 'Bearer $token'}); //새 키값을 넣어 재생성
    }

    super.onRequest(options, handler);
  }

// 요청에 실패 했을 때(액세스 토큰 만료시 등) : onError+Tab(자동완성)
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
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
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );

        //새 액세스토큰
        final accessToken = resp.data[ACCESS_TOKEN_KEY];

        //기존 요청을 가져와서 새 액세스토큰을 요청에 덮어쓰기(키가 동일하므로 덮어써짐)
        final options = err.requestOptions;
        options.headers.addAll({'authorization': 'Bearer $accessToken'});
        await storage.write(
          key: ACCESS_TOKEN_KEY,
          value: accessToken,
        );

        //새 액세스토큰을 담은 요청정보(RequestOptions)를 담아서 fetch요청
        final response = await dio.fetch(options);

        //resolve를 통해 정상적인 응답으로 처리
        handler.resolve(response);

        //새 액세스토큰을 받는 과정에서 문제가 발생하면, 더 이상 할수 있는 것이 없으므로 요청실패 처리(=로그아웃)
      } on DioException catch (e) {
        //로그아웃(함수사용을 위해 1회만 호출할 거라서 read 사용)
        ref.read(authProvider.notifier).logout();
        //요청실패처리
        handler.reject(e);
      }
    }
    super.onError(err, handler);
  }

// 요청에 대한 응답을 받았을 때 : onResponse+Tab(자동완성)
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    super.onResponse(response, handler);
  }
}
