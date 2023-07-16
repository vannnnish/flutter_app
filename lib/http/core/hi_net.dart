import 'package:flutter/foundation.dart';
import 'package:flutter_app/http/request/base_request.dart';

class HiNet {
  HiNet._();

  static final HiNet _instance = HiNet._();

  static HiNet getInstance() {
    return _instance;
  }

  // 发送请求
  Future<dynamic> send<T>(BaseRequest request) async {
    if (kDebugMode) {
      print("url:${request.url()}");
    }
    if (kDebugMode) {
      print('method:${request.httpMethod()}');
    }
    request.addHeader("token", "123");
    return Future.value({
      "statusCode": 200,
      "data": {"code": 200, "message": 'success'}
    });
  }

  Future fire(BaseRequest request) async {
    var response = await send(request);
    var result = response['data'];
    if (kDebugMode) {
      print(result);
    }
    return result;
  }

  void printLog(log) {
    if (kDebugMode) {
      print('hi_net:${log.toString()}');
    }
  }
}
