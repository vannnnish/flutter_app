import 'package:dio/dio.dart';
import 'package:flutter_app/http/core/hi_error.dart';
import 'package:flutter_app/http/core/hi_net_adapter.dart';
import 'package:flutter_app/http/request/base_request.dart';

class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    // TODO: implement send
    Response? response;
    var option = Options(headers: request.header);
    DioException? error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: option);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio().post(request.url(), options: option);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio().delete(request.url(), options: option);
      }
    } on DioException catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response!, request));
    }
    return buildRes(response!, request);
  }

  buildRes(Response response, BaseRequest request) {
    return HiNetResponse(
        data: response.data,
        request: request,
        statusCode: response.statusCode!,
        statusMessage: response.statusMessage,
        extra: response);
  }
}
