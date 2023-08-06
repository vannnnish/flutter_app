// 数据访问对象 主要用于数据交互

import 'package:flutter_app/db/hi_cache.dart';
import 'package:flutter_app/http/request/base_request.dart';
import 'package:flutter_app/http/request/login_request.dart';
import 'package:flutter_app/http/request/registration_request.dart';

import '../core/hi_net.dart';

class LoginDao {
  static const boardingPass = "boarding-pass";

  static login(String userName, String password) {
    return _send(userName, password);
  }

  static registration(
      String userName, String password, String iMoocId, String orderId) {
    return _send(userName, password, iMoocId: iMoocId, orderId: orderId);
  }

  static _send(
    String userName,
    String password, {
    iMoocId,
    orderId,
  }) async {
    BaseRequest request;
    if (iMoocId != null && orderId != null) {
      request = RegistrationRequest();
    } else {
      request = LoginRequest();
    }

    request
        .add("userName", userName)
        .add("password", password)
        .add("imoocId", iMoocId)
        .add("orderId", orderId);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    if (result['code'] == 0 && result['data'] != null) {
      // 保存登录令牌
      HiCache.getInstance()?.setString(boardingPass, result['data']);
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance()?.get(boardingPass);
  }
}
