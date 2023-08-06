import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/hi_cache.dart';
import 'package:flutter_app/http/core/hi_error.dart';
import 'package:flutter_app/http/core/hi_net.dart';
import 'package:flutter_app/http/dao/login_dao.dart';
import 'package:flutter_app/http/request/test_request.dart';
import 'package:flutter_app/model/owner.dart';
import 'package:flutter_app/page/registration_page.dart';
import 'package:provider/provider.dart';

void main() {
  HiCache.preInit();
  test();
  testLogin();
  runApp(MyApp());
}

void test() {
  const jsonStr = "{\"name\":\"tt\"}";
  Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
  print("name:${jsonMap['name']}");
  var str = jsonEncode(jsonMap);
  print('json:$str');

  var own = Owner.fromJson(jsonMap);
}

void test2() {
  var cache = HiCache.getInstance();
  print("cache:$cache");
  cache?.setString("key", "1234");
  var value = HiCache.getInstance()?.get("key");
  print("object$value");
}

void testLogin() async {
  try {
    var result = await LoginDao.registration("ddd", "ffdf", "234", "1234");
    print("最终结果:$result");
  } on NeedAuth catch (e) {
    print("需要登录:$e");
  } on HiNetError catch (e) {
    print("网络异常:$e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: RegistrationPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          const Text('A random idea:'),
          Text(appState.current.asLowerCase),
          const ElevatedButton(onPressed: onPress, child: Text("test")),
        ],
      ),
    );
  }
}

void onPress() async {
  test2();
  TestRequest request = TestRequest();
  request.add("aa", "ddd").add("bb", "333").add("requestPrams", "12");
  try {
    var result = await HiNet.getInstance().fire(request);
    print(result);
  } on NeedAuth catch (e) {
    print(e);
  } on NeedLogin catch (e) {
    print(e);
  } on HiNetError catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
  // if (kDebugMode) {
  //   print(result);
  // }
}
