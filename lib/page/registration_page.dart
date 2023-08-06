import 'package:flutter/material.dart';
import 'package:flutter_app/widget/appbar.dart';

import '../widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", () {
        print("right button click");
      }),
      body: Container(
        child: ListView(
          children: [
            // 自适应键盘，防止遮挡
            // 用户名
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (text) {
                print(text);
              },
            ),
            // 密码
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              obscureText: true,
              lineStretch: true,
              onChanged: (text) {
                print(text);
              },
            )
          ],
        ),
      ),
    );
  }
}
