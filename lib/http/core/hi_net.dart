import 'package:flutter/foundation.dart';
import 'package:flutter_app/http/core/hi_error.dart';
import 'package:flutter_app/http/core/hi_net_adapter.dart';
import 'package:flutter_app/http/request/base_request.dart';

class HiNet {
  HiNet._();

  static final HiNet _instance = HiNet._();

  static HiNet getInstance() {
    return _instance;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse response;
    var error;

    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
      return null;
    } catch (e) {
      error = e;
      printLog(e);
      return null;
    }

    var result = response.data;
    printLog(result);
    var status = response.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status, result.toString(), data: result);
    }

    return result;
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

  void printLog(log) {
    if (kDebugMode) {
      print('hi_net:${log.toString()}');
    }
  }
}
