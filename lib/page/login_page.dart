import 'package:flutter/material.dart';
import 'package:flutter_app/util/toast.dart';
import 'package:flutter_app/widget/appbar.dart';
import 'package:flutter_app/widget/login_effect.dart';
import 'package:flutter_app/widget/login_input.dart';

import '../http/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../widget/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String userName = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("密码登录", "注册", () {}),
      body: Container(
        child: ListView(
          children: [
            // 动效
            LoginEffect(protect: protect),
            //  用户
            LoginInput(
                title: "用户名",
                hint: "请输入用户",
                onChanged: (text) {
                  userName = text;
                  checkInput();
                },
                focusChanged: (focus) {}),
            // 密码
            LoginInput(
                title: "密码",
                hint: "请输入密码",
                obscureText: true,
                onChanged: (text) {
                  password = text;
                  checkInput();
                },
                focusChanged: (focus) {
                  setState(() {
                    protect = focus;
                  });
                }),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: LoginButton(
                "登录",
                enable: loginEnable,
                onPress: () {
                  // print("object");
                  // send();
                  showToast("登陆成功");
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (userName != "" && password != "") {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  send() async {
    try {
      var result = await LoginDao.login("ddd", "ffdf");
      print("最终结果:$result");
      if (result['code'] == 0) {
        print("登陆成功");
      }
    } on NeedAuth catch (e) {
      print("需要登录:$e");
    } on HiNetError catch (e) {
      print("网络异常:$e");
    }
  }
}
