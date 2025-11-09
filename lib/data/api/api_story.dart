import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:story_app/data/model/modelstory.dart';
import 'package:story_app/data/model/modelupload.dart';
import 'package:story_app/static/api.dart';
import 'package:http/http.dart' as http;

class ApiStory {
  Future<Modelstory> getallStory(String token, int page, int size) async {
    Logger().d("getallstory");
    final String url = BaseApi.baseurl;
    final Map<String, String> queryparams = {
      "location": "0",
      "page": "$page",
      "size": "$size",
    };

    final baseuri = Uri.parse(url);
    final Uri uri = baseuri.replace(
      path: '${baseuri.path}/stories',
      queryParameters: queryparams,
    );

    final respon = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    Logger().d("getallstory respon ${respon.body}");
    if (respon.statusCode == 200) {
      return Modelstory.fromJson(jsonDecode(respon.body));
    } else {
      throw Exception(Modelstory.fromJson(jsonDecode(respon.body)).message);
    }
  }

  Future<Modelupload> uploadimage(
    List<int> byte,
    String filename,
    String description,
    String token,
    LatLng? latlang,
  ) async {
    final baseuri = Uri.parse("${BaseApi.baseurl}/stories");
    var request = http.MultipartRequest("POST", baseuri);

    final multipart = http.MultipartFile.fromBytes(
      'photo',
      byte,
      filename: filename,
    );
    request.fields['description'] = description;
    if (latlang != null) request.fields['lat'] = latlang.latitude.toString();
    if (latlang != null) request.fields['lon'] = latlang.longitude.toString();
    final Map<String, String> headers = {"Authorization": "Bearer $token"};

    request.files.add(multipart);
    request.headers.addAll(headers);

    final stremresponse = await request.send();
    final response = await http.Response.fromStream(stremresponse);
    if (response.statusCode == 201) {
      return Modelupload.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(Modelupload.fromJson(jsonDecode(response.body)).message);
    }
  }

  Future<Modelstorydetail> getstory(String id, String token) async {
    final url = "${BaseApi.baseurl}/stories/$id";
    final uri = Uri.parse(url);
    final respon = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    Logger().d("getdetail respon ${respon.body}");
    if (respon.statusCode == 200) {
      return Modelstorydetail.fromJson(jsonDecode(respon.body));
    } else {
      throw Exception(
        Modelstorydetail.fromJson(jsonDecode(respon.body)).message,
      );
    }
  }
}
