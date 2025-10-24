import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import 'package:story_app/data/model/modelauth.dart';
import 'package:story_app/static/api.dart';

class Apiauth {
  Future<LoginModel> getLogin(String email, String password) async {
    Logger().d("${RequestLoginModel(email: email, password: password).toMaps()}");
    final url = "${BaseApi.baseurl}/login";
    final data = await http.post(Uri.parse(url),
        body: RequestLoginModel(email: email, password: password).toMaps());

    if (data.statusCode == 200){
      return LoginModel.fromjson(jsonDecode(data.body));
    }else{
      throw Exception(LoginModel.fromjson(jsonDecode(data.body)).message);
    }
  }
}