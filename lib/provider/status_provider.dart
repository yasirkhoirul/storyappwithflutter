import 'package:story_app/data/model/modelauth.dart';
import 'package:story_app/data/model/modelupload.dart';

sealed class Status {}

class IsError extends Status {
  final String message;
  IsError(this.message);
}

class Isloading extends Status {}

class Isuccesslogin extends Status {
  final LoginModel data;
  Isuccesslogin(this.data);
}

class IsIdle extends Status {}

class Isuksessignup extends Status {
  final Modelsignup data;
  Isuksessignup(this.data);
}

class Isuksesupload extends Status {
  final Modelupload data;
  Isuksesupload(this.data);
}

class Issuksesmessage extends Status {
  final String message;
  Issuksesmessage({required this.message});
}
