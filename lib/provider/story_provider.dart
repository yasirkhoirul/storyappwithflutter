import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:story_app/data/api/api_story.dart';
import 'package:story_app/data/model/modelstory.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';

class StoryProvider extends ChangeNotifier {
  final ApiStory apistory;
  final AuthProvider auth;
  StoryProvider({required this.apistory, required this.auth});
  Modelstory? _data;
  Modelstory? get datastory => _data;
  Status status = IsIdle();
  Future fetchdata() async {
    Logger().d("fetchdatadijalankan");
    status = Isloading();
    notifyListeners();
    try {
      final token = auth.datalogin?.token;
      if (token != null) {
        _data = await apistory.getallStory(token);
        status = Issuksesmessage(message: "done");
      } else {
        status = IsError("anda belum login");
      }
    } catch (e) {
      Logger().d(e.toString());
      status = IsError(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
