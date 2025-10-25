import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';

class StatusDialogManager extends StatelessWidget {
  const StatusDialogManager({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthProvider>().status;
    Logger().d("dialog state = $state");
    if (state is IsIdle) {
      Logger().d("dialog pop");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
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
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().setidlelogin();
            },
            child: const Text('OK'),
          ),
        ],
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
