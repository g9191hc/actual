import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;

  const DefaultLayout({
    super.key,
    required this.child, this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold기본색상이 흰 색이 아님(흰 색에 가까운 색). 이 프로젝트에서는 기본값으로 흰 색 지정
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
    );
  }
}
