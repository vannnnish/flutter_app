import 'package:flutter/material.dart';
import 'package:flutter_app/db/hi_cache.dart';
import 'package:flutter_app/page/home_page.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/page/registration_page.dart';
import 'package:flutter_app/page/video_detail_page.dart';
import 'package:flutter_app/util/color.dart';

import 'http/dao/login_dao.dart';
import 'model/video_model.dart';
import 'navigator/hi_navigator.dart';

void main() {
  HiCache.preInit();
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({super.key});

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

/*
  BiliRouteInformationParser _routeInformationParser =
      BiliRouteInformationParser();
*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache?>(
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache?> snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(
                  // routeInformationParser: _routeInformationParser,
                  routerDelegate: _routeDelegate,
                  // routeInformationParser 为null 时可缺省
                  /*routeInformationProvider: PlatformRouteInformationProvider(
                      initialRouteInformation: RouteInformation(location: "/")),*/
                )
              : Scaffold(
                  body: Center(
                  child: CircularProgressIndicator(),
                ));
          return MaterialApp(
            home: widget,
            theme: ThemeData(primaryColor: white),
          );
        });
  }
}

// 路由代理
class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigationKey;
  VideoModel? videoModel;

// 为Navigator 设置一个key，必要的时候，可以通过navigatorKey.currentState来获取到NavigatorState对象
  BiliRouteDelegate() : navigationKey = GlobalKey<NavigatorState>();

  // 路由状态
  RouteStatus _routeStatus = RouteStatus.home;

  // 所有的页面
  List<MaterialPage> pages = [];

  // late BiliRoutePath path;
  RouteStatus get routeStatus {
    // 当前打开不是注册页面，且没登陆
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      //
      pages.clear();
      page = pageWrap(HomePage(
        onJumpToDetail: (videoModel) {
          this.videoModel = videoModel;
          notifyListeners();
        },
      ));
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(
        videoModel: videoModel,
      ));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage(onJumpToLogin: () {
        _routeStatus = RouteStatus.login;
        notifyListeners();
      }));
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }
    tempPages = [...tempPages, page];
    // 构建路由栈
    // pages = [
    //   pageWrap(HomePage(
    //     onJumpToDetail: (videoModel) {
    //       this.videoModel = videoModel;
    //       notifyListeners();
    //     },
    //   )),
    //   if (videoModel != null)
    //     pageWrap(VideoDetailPage(
    //       videoModel: videoModel,
    //     ))
    // ];
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        // 这里可以控制是否可以返回
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => navigationKey;

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async {
    // path = configuration;
  }
}
/*

class BiliRouteInformationParser extends RouteInformationParser<BiliRoutePath> {
  @override
  Future<BiliRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    print("uril:$uri");
    if (uri.pathSegments.isEmpty) {
      return BiliRoutePath.home();
    }
    return BiliRoutePath.detail();
    // return super.parseRouteInformation(routeInformation);
  }
}
*/

class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}

/*
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
          // primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // home: RegistrationPage(onJumpToLogin: () {
        //   print("object");
        // }),
        home: const LoginPage(),
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
*/
