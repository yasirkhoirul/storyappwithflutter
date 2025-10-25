import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadProvider extends ChangeNotifier{
  XFile? fileimage;
  String? _filepath;

  XFile? get fileimages => fileimage;
  String? get filepath => _filepath;
  setfileimgae(XFile file){
    fileimage = file;
    notifyListeners();
  }
  setfilepath(String data){
    _filepath = data;
    notifyListeners();
  }

}
