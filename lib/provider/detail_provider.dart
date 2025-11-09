import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/web.dart';
import 'package:story_app/data/api/api_story.dart';
import 'package:story_app/data/model/modelstory.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

class DetailProvider extends ChangeNotifier {
  final ApiStory apidetail;
  final AuthProvider auth;
  DetailProvider({required this.apidetail, required this.auth});
  Status status = IsIdle();
  Modelstorydetail? datas;
  String addresss = "";
  setidle() {
    status = IsIdle();
  }

  getdetaail(String id) async {
    Logger().d("masuk getdetail");
    status = Isloading();
    notifyListeners();
    try {
      final data = await apidetail.getstory(id, auth.datalogin!.token);
      if (data.error) {
        status = IsError(data.message);
      } else {
        datas = data;
        Logger().d("masuk try data ${datas!.liststory.name}");
        await getaddres();
        Logger().d("selesai get addres");
        status = Issuksesmessage(message: "berhasil");
      }
    } catch (e) {
      status = IsError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  getaddres() async {
    if (datas?.liststory.lat == null || datas?.liststory.long == null) {
      return;
    }
    try {
      Logger().d("masuk get addres ");
      final info = await geo
          .placemarkFromCoordinates(
            datas!.liststory.lat!,
            datas!.liststory.long!,
          )
          .timeout(Duration(seconds: 10));
      final place = info[0];
      final address =
          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      addresss = address;
      Logger().d("masuk selesai get addres");
    } on TimeoutException {
      throw TimeoutException("koneksi kurang stabil silahkan coba lagi");
    } on PlatformException {
      throw TimeoutException("koneksi kurang stabil silahkan coba lagi");
    } catch (e) {
      throw Exception("terjadi kesalhan $e");
    }
  }
}
