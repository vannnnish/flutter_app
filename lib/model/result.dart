import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  int? code;
  String? method;
  String? requestPrams;

  Result(this.code, this.method, this.requestPrams);

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

/*
*  运行 flutter packages pub run build_runner build 生成
* */
