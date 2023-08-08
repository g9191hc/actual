import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/user/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user_model.dart';
import '../repository/user_me_repository.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      final userMeRepository = ref.watch(userMeRepositoryProvider);
      final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    authRepository: authRepository,
    repository: userMeRepository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  // UserMeStateNotifier가 관리하는 대상은 UserModelBase로,
  // 맨 처음 UserModelLoading을 넣어주고,
  // async 요청으로 안전저장소에서 토큰을 가져와서 서버에 데이터를 요청 하며
  // 응답이 오면 그 응답을 UserModel로 변환하여 관리대상을 그 값으로 변경

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(
          UserModelLoading(),
        ) {
    getMe();
  }

  Future<void> getMe() async {
    final tokens = await Future.wait([
      storage.read(key: REFRESH_TOKEN_KEY),
      storage.read(key: ACCESS_TOKEN_KEY),
    ]);
    final refreshToken = tokens[0];
    final accessToken = tokens[1];

    if (refreshToken == null || accessToken == null) {
      //만약 둘 중 하나의 값이 없으면 로그인을 해야 하므로 null로 변환
      state = null;
      return;
    }

    final resp = await repository.getMe();

    state = resp;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await Future.wait([
        storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken),
        storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken),
      ]);

      final userResp = await repository.getMe();

      state = userResp;
    } catch (e) {
      state = UserModelError(errorMessage: '로그인에 실패했습니다.');
    }
    return Future.value(state);
  }

  Future<void> logout() async {
    state = null;

    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
