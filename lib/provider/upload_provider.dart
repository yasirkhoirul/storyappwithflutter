import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:story_app/data/api/api_story.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:image/image.dart' as img;

class UploadProvider extends ChangeNotifier {
  XFile? fileimage;
  String? _filepath;
  String description = "";
  final ApiStory apiStory;
  final AuthProvider auth;
  UploadProvider({required this.apiStory, required this.auth});

  Status status = IsIdle();

  XFile? get fileimages => fileimage;
  String? get filepath => _filepath;
  setidle() {
    status = IsIdle();
    notifyListeners();
  }

  setfileimgae(XFile file) {
    fileimage = file;
    notifyListeners();
  }

  setfilepath(String data) {
    _filepath = data;
    notifyListeners();
  }

  setDescription(String data) {
    description = data;
    notifyListeners();
  }

  uploadfile(LatLng? latlang) async {
    status = Isloading();
    notifyListeners();
    try {
      if (filepath == null || fileimages == null || description == "") {
        status = IsError("file / deskripsi tidak boleh kosong");
      } else {
        final Uint8List image = await fileimages!.readAsBytes();
        final newimage = await compressimage(image);
        final respons = await apiStory.uploadimage(
          newimage,
          fileimages!.name,
          description,
          auth.datalogin!.token,
          latlang,
        );
        status = Isuksesupload(respons);
      }
    } catch (e) {
      status = IsError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<List<int>> compressimage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      ///
      compressQuality -= 10;
      newByte = img.encodeJpg(image, quality: compressQuality);
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }
}
