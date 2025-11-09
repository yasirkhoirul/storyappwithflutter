import 'package:json_annotation/json_annotation.dart';
part 'modelupload.g.dart';

@JsonSerializable()
class Modelupload {
  final bool error;
  final String message;
  const Modelupload(this.error, this.message);
  factory Modelupload.fromJson(Map<String, dynamic> json) =>
      _$ModeluploadFromJson(json);
}
