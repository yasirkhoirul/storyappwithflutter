

import 'package:story_app/data/model/modelauth.dart';

sealed class Status{
}
class IsError extends Status{
  final String message;
  IsError(this.message);
}

class Isloading extends Status{
}

class Isuccesslogin extends Status{
  final LoginModel data;
  Isuccesslogin(this.data);
}

class IsIdle extends Status{

}