import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:actual/common/view/splash_screen.dart';
import 'package:actual/custum_painter.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'NotoSans'),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),

        //CustomPaintScreen(),
      ),
    );
  }
}
