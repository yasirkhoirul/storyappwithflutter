import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_auth.dart';
import 'package:story_app/data/model/modelauth.dart';
import 'package:story_app/provider/status_provider.dart';

class AuthProvider extends ChangeNotifier {
  final Apiauth apiauth;
  String _email = "";
  String _password = "";
  Status status = IsIdle();
 
  
  AuthProvider({required this.apiauth});
  String get email => _email;
  String get password => _password;
  LoginResult? datalogin;
  
  setidlelogin(){
    status = IsIdle();
    notifyListeners();
  }
  setemail(String data) {
    _email = data;
    notifyListeners();
  }

  setPassword(String data) {
    _password = data;
    notifyListeners();
  }

  Future signup(String em, String pw, String ur) async {
    Logger().d(em);
    status = Isloading();
    notifyListeners();
    try {
      final respon = await apiauth.getSignup(ur, em, pw);
      if (respon.error) {
        status = IsError(respon.message);
      } else {
        status = Isuksessignup(respon);
      }
    } catch (e) {
      status = IsError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future login() async {
    status = Isloading();
    notifyListeners();
    try {
      final respon = await apiauth.getLogin(email, password);
      if (respon.error == true) {
        status = IsError(respon.message);
      } else {
        await savedatalogin(respon);
        status = Isuccesslogin(respon);
      }
    } catch (e) {
      status = IsError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future savedatalogin(LoginModel data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", data.loginResult?.token ?? "");
    prefs.setString("name", data.loginResult?.name ?? "");
    prefs.setString("userId", data.loginResult?.userId ?? "");
  }

  Future loadDatalogin() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString("userId");
    final name = prefs.getString("name");
    final token = prefs.getString("token");

    if (userId == null || name == null || token == null) {
      datalogin = null;
    } else {
      datalogin = LoginResult(userId: userId, name: name, token: token);
    }
  }

  Future deleteDatalogin() async {
    final prefs = await SharedPreferences.getInstance();
    datalogin = null;
    prefs.clear();
  }
}
