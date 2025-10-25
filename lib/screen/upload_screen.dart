import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});
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
                Icon(Icons.image, size: 350),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text("Kamera"),
                      ),
                    ),
                    const SizedBox(width: 10), // jarak antar tombol
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text("Galeri"),
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
}
