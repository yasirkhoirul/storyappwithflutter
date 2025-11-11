import 'dart:io';

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
  int? _pageitemlist = 1;
  int? get pageitemlist => _pageitemlist;
  final int _sizelist = 3;
  int get sizelist => _sizelist;

  Modelstory? _data;
  Modelstory? get datastory => _data;

  Status status = IsIdle();

  setPageItemone() {
    _pageitemlist = 1;
    notifyListeners();
  }

  Future fetchdata() async {
    Logger().d("fetchdatadijalankan  dengan $_pageitemlist");
    if (pageitemlist == 1) {
      status = Isloading();
      notifyListeners();
    }
    try {
      final token = auth.datalogin?.token;
      if (token != null) {
        if (pageitemlist == 1) {
          _data = await apistory.getallStory(token, pageitemlist!, sizelist);
        } else {
          final listbaru = await apistory.getallStory(
            token,
            pageitemlist!,
            sizelist,
          );
          _data!.liststory.addAll(listbaru.liststory);
        }
        _pageitemlist = _pageitemlist! + 1;
        status = Issuksesmessage(message: "done");
      } else {
        status = IsError("anda belum login");
      }
    } on SocketException {
      status = IsError("Maaf tidak internet");
    } catch (e) {
      Logger().d(e.toString());
      status = IsError(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
