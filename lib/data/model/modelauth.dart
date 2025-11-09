import 'package:json_annotation/json_annotation.dart';

part 'modelauth.g.dart';

@JsonSerializable()
class LoginModel {
  final bool error;
  final String message;
  final LoginResult? loginResult;

  const LoginModel({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginModel.fromjson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
}

@JsonSerializable()
class LoginResult {
  final String userId;
  final String name;
  final String token;
  LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);
}

@JsonSerializable()
class RequestLoginModel {
  final String email;
  final String password;
  RequestLoginModel({required this.email, required this.password});
  Map<String, dynamic> toJson() => _$RequestLoginModelToJson(this);
}

@JsonSerializable()
class Modelsignup {
  final bool error;
  final String message;
  Modelsignup({required this.error, required this.message});

  factory Modelsignup.fromjson(Map<String, dynamic> json) =>
      _$ModelsignupFromJson(json);
}

@JsonSerializable()
class RequesSignup {
  final String name;
  final String email;
  final String password;
  RequesSignup({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$RequesSignupToJson(this);
}
