import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActtionButton;

  const DefaultLayout({
    super.key,
    this.title,
    required this.child,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActtionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold기본색상이 흰 색이 아님(흰 색에 가까운 색). 이 프로젝트에서는 기본값으로 흰 색 지정
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActtionButton,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title!,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
