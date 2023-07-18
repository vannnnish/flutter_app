/*
*  测试适配器， mock数据
* */

import 'package:flutter_app/http/core/hi_net_adapter.dart';
import 'package:flutter_app/http/request/base_request.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    // TODO: implement send
    return Future<HiNetResponse<T>>.delayed(const Duration(microseconds: 5000),
        () {
      dynamic data = {"code": 401, "message": "success"};
      return HiNetResponse(data: data, request: request, statusCode: 401);
    });
  }
// print("objecthe");
}
