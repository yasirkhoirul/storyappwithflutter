import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:story_app/data/model/modelstory.dart';
import 'package:story_app/data/model/modelupload.dart';
import 'package:story_app/static/api.dart';
import 'package:http/http.dart' as http;

class ApiStory {
  Future<Modelstory> getallStory(String token) async {
    Logger().d("getallstory");
    final String url = BaseApi.baseurl;
    final Map<String, String> queryparams = {"location": "1"};

    final baseuri = Uri.parse(url);
    final Uri uri = baseuri.replace(
      path: '${baseuri.path}/stories',
      queryParameters: queryparams,
    );

    final respon = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    Logger().d("getallstory respon $respon");
    if (respon.statusCode == 200) {
      return Modelstory.fromjson(jsonDecode(respon.body));
    } else {
      throw Exception(Modelstory.fromjson(jsonDecode(respon.body)).message);
    }
  }

  Future<Modelupload> uploadimage(
    List<int> byte,
    String filename,
    String description,
    String token,
  ) async {
    final baseuri = Uri.parse("${BaseApi.baseurl}/stories");
    var request = http.MultipartRequest("POST", baseuri);

    final multipart = http.MultipartFile.fromBytes(
      'photo',
      byte,
      filename: filename,
    );
    final Map<String, String> field = {'description': description};
    final Map<String, String> headers = {"Authorization": "Bearer $token"};

    request.files.add(multipart);
    request.fields.addAll(field);
    request.headers.addAll(headers);

    final stremresponse = await request.send();
    final response = await http.Response.fromStream(stremresponse);
    if (response.statusCode == 201) {
      return Modelupload.fromjson(jsonDecode(response.body));
    } else {
      throw Exception(Modelupload.fromjson(jsonDecode(response.body)).message);
    }
  }

  Future<Modelstorydetail> getstory(String id, String token) async {
    final url = "${BaseApi.baseurl}/stories/$id";
    final uri = Uri.parse(url);
    final respon = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    Logger().d("getdetail respon $respon");
    if (respon.statusCode == 200) {
      return Modelstorydetail.fromjson(jsonDecode(respon.body));
    } else {
      throw Exception(
        Modelstorydetail.fromjson(jsonDecode(respon.body)).message,
      );
    }
  }
}
