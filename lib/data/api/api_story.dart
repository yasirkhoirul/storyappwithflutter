
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:story_app/data/model/modelstory.dart';
import 'package:story_app/static/api.dart';
import 'package:http/http.dart'as http;

class ApiStory {
  Future<Modelstory> getallStory(String token) async{
    Logger().d("getallstory");
    final String url =BaseApi.baseurl;
    final Map<String,String> queryparams ={
      "location":"1"
    };

    final baseuri = Uri.parse(url);
    final Uri uri = baseuri.replace(
      path: '${baseuri.path}/stories',
      queryParameters: queryparams
    );

    final respon = await http.get(uri,headers: {
      'Authorization': 'Bearer $token'
    });
    Logger().d("getallstory respon $respon");
    if(respon.statusCode == 200){
      return Modelstory.fromjson(jsonDecode(respon.body));
    }else{
      throw Exception(Modelstory.fromjson(jsonDecode(respon.body)).message);
    }
  }
}