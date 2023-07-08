import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

import '../../common/component/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Title(),
          const SizedBox(height: 16.0),
          _SubTitle(),
          Image.asset(
            'asset/img/misc/logo.png',
            width: MediaQuery
                .of(context)
                .size
                .width / 3 * 2,
          ),
          CustomTextFormField(
            hintText: '이메일을 입력 해 주세요',
            onChanged: (value) {},
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            hintText: '비밀번호를을 입력 해 주세요',
            onChanged: (value) {},
            obscureText: true,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {},
            child: Text('로그인'),
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('회원가입'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    ),)
    ,
    )
    ,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
