import 'package:flutter/material.dart';
import 'package:flutter_app/widget/appbar.dart';
import 'package:flutter_app/widget/login_button.dart';
import 'package:flutter_app/widget/login_effect.dart';

import '../http/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback onJumpToLogin;

  const RegistrationPage({super.key, required this.onJumpToLogin});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protected = false;
  bool loginEnable = false;
  String userName = "";
  String phoneNumber = "";
  String password = "";
  String rePassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", () {
        widget.onJumpToLogin();
      }),
      body: Container(
        child: ListView(
          children: [
            // 自适应键盘，防止遮挡
            LoginEffect(
              protect: protected,
            ),
            // 手机号
            LoginInput(
              title: "手机号",
              hint: "请输入密码",
              obscureText: true,
              lineStretch: true,
              onChanged: (text) {
                phoneNumber = text;
                checkInput();
              },
              focusChanged: (bool value) {},
            ),
            // 用户名
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (text) {
                userName = text;
                checkInput();
                print(text);
              },
              focusChanged: (bool value) {},
            ),
            // 密码
            LoginInput(
              title: "密码",
              hint: "请输入密码",
              obscureText: true,
              lineStretch: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                setState(() {
                  protected = focus;
                });
              },
            ),
            // 重复密码
            LoginInput(
              title: "确认密码",
              hint: "请再次输入密码",
              obscureText: true,
              lineStretch: true,
              onChanged: (text) {
                rePassword = text;
                checkInput();
              },
              focusChanged: (focus) {
                setState(() {
                  protected = focus;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                "注册",
                enable: true,
                onPress: send,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (userName.isNotEmpty &&
        password.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        rePassword.isNotEmpty) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  _LoginButton() {
    return InkWell(
      onTap: () {
        if (loginEnable) {
          checkParams();
          send();
        } else {
          print("按钮禁止了");
        }
      },
      child: Text("注册"),
    );
  }

  Future<void> send() async {
    try {
      var result = await LoginDao.registration("ddd", "ffdf", "234", "1234");
      print("最终结果:$result");
      if (result['code'] == 0) {
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin();
        }
      }
    } on NeedAuth catch (e) {
      print("需要登录:$e");
    } on HiNetError catch (e) {
      print("网络异常:$e");
    }
  }

  void checkParams() {
    String tips = "";
    if (password != rePassword) {
      tips = "两次密码不一致";
    }
    if (tips != "") {
      print(tips);
      return;
    }
  }
}
