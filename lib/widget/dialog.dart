import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/maps_provider.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:story_app/router/myrouter_delegate.dart';

class ShowDialogs extends Page {
  final Function() onclose;
  const ShowDialogs({super.key, required this.onclose});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      opaque: false,
      barrierColor: Colors.black45,
      pageBuilder: (context, animation, secondaryAnimation) => Center(
        child: switch (context.read<MyrouterDelegate>().statuss) {
          Isloading() => AlertDialog(
            title: const Text("Loading.."),
            content: const CircularProgressIndicator(),
          ),
          Isuksessignup() => AlertDialog(
            title: const Text("Signup Berhasil"),
            content: const Text("berhasil"),
            actions: [TextButton(onPressed: onclose, child: const Text("ok"))],
          ),
          Issuksesmessage(message: var message) => AlertDialog(
            title: const Text("pilih lokasi"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<MyrouterDelegate>().gomap = false;
                  onclose();
                },
                child: const Text("ok"),
              ),
              TextButton(
                onPressed: () {
                  context.read<MapsProvider>().setaddresempty();
                  onclose();
                },
                child: const Text("Batal"),
              ),
            ],
          ),
          IsError(message: var message) => AlertDialog(
            title: const Text("terjadi kesalahan"),
            content: Text(message),
            actions: [TextButton(onPressed: onclose, child: const Text("ok"))],
          ),
          _ => Container(),
        },
      ),
    );
  }
}
