import 'package:actual/user/provider/user_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/user_model.dart';

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref: ref));

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  // SplashScreen

  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    //현재 화면이 로그인 화면인지 여부 확인
    final logginIn = state.matchedLocation == '/login';

    //유저 정보가 없는 경우는 로그인이 안 되어 있는 경우로, 무조건 로그인페이지로 보내야 하므로
    if (user == null) {
      // 로그인 페이지를 요청하는거면 그대로 두고, 아니면 로그인 페이지로 리다이렉트('/login')
      return logginIn ? null : '/login';
    }

    // 여기서부터는 UserModel인 상태(=사용자 정보가 있는 상태 = 로그인 되어 있는 상태)
    if (user is UserModel) {
      // 로그인페이지나 스플래시화면으로 이동하려 하면, 홈으로 리다이렉트(return '/';)하고 아니라면 원래 요청페이지로 보냄(return null;)
      return logginIn || state.matchedLocation == '/splash' ? '/' : null;
    }

    // 에러시
    if (user is UserModelError) {
      // 무조건 로그인페이지로 보냄
      return !logginIn ? '/login' : null;
    }

    // 아무것도 해당 안 되면 원래 요청페이지로 보냄
    return null;
  }
}