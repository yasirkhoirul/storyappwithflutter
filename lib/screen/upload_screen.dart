import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/upload_provider.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late final UploadProvider uploadprovider;
  @override
  void initState() {
    uploadprovider = context.read<UploadProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text("New Story"),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 100,
                    maxHeight: 350,
                    minWidth: 100,
                    maxWidth: 350,
                  ),
                  child: context.watch<UploadProvider>().fileimage == null
                      ? Icon(Icons.image, size: 200)
                      : showimage(),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          pickkamera();
                        },
                        child: const Text("Kamera"),
                      ),
                    ),
                    const SizedBox(width: 10), // jarak antar tombol
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          pickgaleri();
                          Logger().d("pickgaleridiklik");
                        },
                        child: const Text("Galeria"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      maxLines: 12,
                      decoration: InputDecoration(
                        label: const Text("Deskripsi"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text("Upload"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickgaleri() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;
    final ImagePicker imagepicker = ImagePicker();
    final file = await imagepicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      uploadprovider.setfileimgae(file);
      uploadprovider.setfilepath(file.path);
    }
  }

  pickkamera() async {
    final android = defaultTargetPlatform == TargetPlatform.android;
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    final cekplatform = !(android || ios);
    if (!cekplatform) {
      final picker = ImagePicker();
      final data = await picker.pickImage(source: ImageSource.camera);
      if (data != null) {
        uploadprovider.setfileimgae(data);
        uploadprovider.setfilepath(data.path);
      }
    }else{
      return;
    }
  }

  showimage() {
    return kIsWeb
        ? Image.network(
            uploadprovider.filepath.toString(),
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            fit: BoxFit.contain,
          )
        : Image.file(File(uploadprovider.filepath.toString()));
  }
}
