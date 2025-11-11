import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:story_app/router/myrouter_delegate.dart';

class StatusDialogManager extends StatelessWidget {
  const StatusDialogManager({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthProvider>().status;
    if (state is IsIdle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigator.of(context).pop();
      });

      return const SizedBox.shrink();
    }

    if (state is Isloading) {
      return const AlertDialog(
        title: Text('Loading...'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      );
    }

    if (state is Isuksessignup) {
      return AlertDialog(
        title: Text(
          state.data.message,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        icon: Icon(Icons.check),
        content: const Text('Proses berhasil diselesaikan.'),
      );
    }

    if (state is IsError) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(state.message),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().setidlelogin();
            },
            child: const Text('Tutup'),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class ShowDialogs extends Page {
  final Function() onclose;
  const ShowDialogs( {super.key, required this.onclose});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      opaque: false,
      barrierColor: Colors.black45,
      pageBuilder: (context, animation, secondaryAnimation) => Center(
        child: switch(context.read<MyrouterDelegate>().statuss){
          Isloading() => AlertDialog(
            title: const Text("Loading.."),
            content: const CircularProgressIndicator(),
            
          ),
          Isuksessignup() => AlertDialog(
            title: const Text("Signup Berhasil"),
            content: const Text("berhasil"),
            actions: [
              TextButton(onPressed: onclose, child: const Text("ok"))
            ]
          ),
          IsError(message:var message) => AlertDialog(
            title: const Text("terjadi kesalahan"),
            content: Text(message),
            actions: [
              TextButton(onPressed: onclose, child: const Text("ok"))
            ]
          ),
          _ => Container()
        }
      ),
    );
  }
}

