import 'package:flutter/foundation.dart';
import 'package:flutter_app/http/core/dio_adapter.dart';
import 'package:flutter_app/http/core/hi_error.dart';
import 'package:flutter_app/http/core/hi_net_adapter.dart';
import 'package:flutter_app/http/core/mock_adapter.dart';
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
      response = await sendByDio(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog("结果:${e.message}");
      return null;
    } catch (e) {
      error = e;
      printLog("错误:$e");
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
        break;
      case 403:
        throw NeedAuth(result.toString(), data: result);
        break;
      default:
        throw HiNetError(status, result.toString(), data: result);
        break;
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

  // 发送请求
  Future<dynamic> sendByMock<T>(BaseRequest request) async {
    if (kDebugMode) {
      print("url:${request.url()}");
    }
    if (kDebugMode) {
      print('method:${request.httpMethod()}');
    }
    request.addHeader("token", "123");
    HiNetAdapter adapter = MockAdapter();
    return adapter.send(request);
    // return Future.value({
    //   "statusCode": 200,
    //   "data": {"code": 200, "message": 'success'}
    // });
  }

  // 发送请求
  Future<dynamic> sendByDio<T>(BaseRequest request) async {
    if (kDebugMode) {
      print("url:${request.url()}");
    }
    if (kDebugMode) {
      print('method:${request.httpMethod()}');
    }
    request.addHeader("token", "123");
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
    // return Future.value({
    //   "statusCode": 200,
    //   "data": {"code": 200, "message": 'success'}
    // });
  }

  void printLog(log) {
    if (kDebugMode) {
      print('hi_net:${log.toString()}');
    }
  }
}
