import 'dart:convert';

import 'package:flutter_app/http/request/base_request.dart';

abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

class HiNetResponse<T> {
  HiNetResponse({
    this.data,
    required this.request,
    required this.statusCode,
    required this.statusMessage,
    this.extra,
  });

  T? data;
  BaseRequest request;
  int statusCode;
  String statusMessage;
  dynamic extra;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
