import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //Scaffold기본색상이 흰 색이 아님(흰 색에 가까운 색). 이 프로젝트에서는 흰 색으로 지정
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              hintText: '이메일을 입력 해 주세요', onChanged: (value) {  },
            ),
          ],
        ),
      ),
    );
  }
}
