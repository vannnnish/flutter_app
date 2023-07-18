import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/core/hi_error.dart';
import 'package:flutter_app/http/core/hi_net.dart';
import 'package:flutter_app/http/request/test_request.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
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
        home: MyHomePage(),
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
  TestRequest request = TestRequest();
  request.add("aa", "ddd").add("bb", "333").add("reqestPram", "12");
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
