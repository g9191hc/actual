import 'package:actual/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider(
  (ref) {
    // AuthProvider의 공통 인스턴스를 지속적으로 사용하기 위해서,
    // watch가 아닌 read로 한번 가져온 인스턴스를 지속사용
    final provider = ref.watch(authProvider);
    return GoRouter(
      routes: provider.routes,
      initialLocation: '/splash',
      // refreshListenable: provider,
      redirect: provider.redirectLogic,
    );
  },
);
