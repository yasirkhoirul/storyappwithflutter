import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_story.dart';
import 'package:story_app/data/model/modelstory.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';

class DetailProvider extends ChangeNotifier {
  final ApiStory apidetail;
  final AuthProvider auth;
  DetailProvider({required this.apidetail, required this.auth});
  Status status = IsIdle();
  Modelstorydetail? datas;
  setidle() {
    status = IsIdle();
  }

  getdetaail(String id) async {
    status = Isloading();
    notifyListeners();
    try {
      final data = await apidetail.getstory(id, auth.datalogin!.token);
      if (data.error) {
        status = IsError(data.message);
      } else {
        datas = data;
        status = Issuksesmessage(message: "berhasil");
      }
    } catch (e) {
      status = IsError(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
