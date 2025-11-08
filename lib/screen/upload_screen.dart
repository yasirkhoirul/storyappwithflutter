import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/maps_provider.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/provider/upload_provider.dart';

class UploadScreen extends StatefulWidget {
  final Function() onbacktomain;
  final Function() onMap;
  const UploadScreen({super.key, required this.onMap, required this.onbacktomain});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final deskripsi = TextEditingController();
  late final UploadProvider uploadprovider;
  @override
  void initState() {
    uploadprovider = context.read<UploadProvider>();
    super.initState();
  }

  @override
  void dispose() {
    deskripsi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maps = context.read<MapsProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text("New Story"),
        ),
      ),
      body: Consumer<UploadProvider>(
        builder: (context, values, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: switch (values.status) {
                  Isloading() => Center(child: CircularProgressIndicator()),
                  Isuksesupload(data: var data) => Center(
                    child: AlertDialog(
                      title: const Text("berhasil"),
                      content: Text(data.message),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            context.read<StoryProvider>().fetchdata();
                            values.setidle();
                            widget.onbacktomain();
                          },
                          child: const Text("ok"),
                        ),
                      ],
                    ),
                  ),
                  IsError(message: var message) => Center(
                    child: AlertDialog(
                      title: Text(
                        "Gagal",
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            values.setidle();
                          },
                          child: const Text("ok"),
                        ),
                      ],
                    ),
                  ),
                  _ => Column(
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
                            onChanged: (value) {
                              values.setDescription(value);
                            },
                            decoration: InputDecoration(
                              label: const Text("Deskripsi"),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: widget.onMap,
                            child: const Text("Pilih Lokasi"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: maps.saddress.isEmpty
                                    ? Text(
                                        "Tidak ada lokasi dipilih",
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        "Lokasi dipilih : ${maps.saddress}",
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              context.read<UploadProvider>().uploadfile(maps.latlangs);
                            },
                            child: const Text("Upload"),
                          ),
                        ],
                      ),
                    ],
                  ),
                },
              ),
            ),
          );
        },
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
    } else {
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
