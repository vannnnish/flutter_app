import 'package:flutter/foundation.dart';

import '../dao/login_dao.dart';

enum HttpMethod { GET, POST, DELETE }

abstract class BaseRequest {
  var pathParams;

  late var useHttps = true;

  // 请求地址
  String authority() {
    return "api.devio.org";
  }

  // 请求方法
  HttpMethod httpMethod();

  // 设置path，域名后面后缀
  String path();

// 生成具体url
  String url() {
    Uri uri;
    var pathStr = path();
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathParams = "${path()}$pathParams";
      } else {
        pathParams = "${path()}/$pathParams";
      }
    }
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    if (needLogin()) {
      // 给需要登录的接口携带登录令牌
      addHeader(LoginDao.boardingPass, LoginDao.getBoardingPass());
    }
    if (kDebugMode) {
      print("url:${uri.toString()}");
    }
    return uri.toString();
  }

  // 判断接口是否需要登录
  bool needLogin();

// http 和 https切换
  Map<String, String> params = Map();

  // 添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  // 鉴权
  Map<String, dynamic> header = Map();

  // 添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
