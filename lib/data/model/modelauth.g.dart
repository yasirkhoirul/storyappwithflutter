// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelauth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
  error: json['error'] as bool,
  message: json['message'] as String,
  loginResult: json['loginResult'] == null
      ? null
      : LoginResult.fromJson(json['loginResult'] as Map<String, dynamic>),
);

LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => LoginResult(
  userId: json['userId'] as String,
  name: json['name'] as String,
  token: json['token'] as String,
);

Map<String, dynamic> _$RequestLoginModelToJson(RequestLoginModel instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

Modelsignup _$ModelsignupFromJson(Map<String, dynamic> json) => Modelsignup(
  error: json['error'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$RequesSignupToJson(RequesSignup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };
