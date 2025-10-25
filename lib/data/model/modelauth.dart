class LoginModel {
  final bool error;
  final String message;
  final LoginResult? loginResult;

  const LoginModel({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginModel.fromjson(Map<String, dynamic> json) {
    return LoginModel(
      error: json["error"],
      message: json["message"],
      loginResult: (json["loginResult"] != null)
          ? LoginResult.fromjson(json["loginResult"])
          : null,
    );
  }
}

class LoginResult {
  final String userId;
  final String name;
  final String token;
  LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromjson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json["userId"],
      name: json["name"],
      token: json["token"],
    );
  }
}

class RequestLoginModel {
  final String email;
  final String password;
  RequestLoginModel({required this.email, required this.password});
  Map<String, dynamic> toMaps() {
    return {"email": email, "password": password};
  }
}

class Modelsignup {
  final bool error;
  final String message;
  Modelsignup({required this.error, required this.message});

  factory Modelsignup.fromjson(Map<String, dynamic> json) {
    return Modelsignup(error: json['error'], message: json['message']);
  }
}

class RequesSignup {
  final String name;
  final String email;
  final String password;
  RequesSignup({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> tomap() {
    return {"name": name, "email": email, "password": password};
  }
}
