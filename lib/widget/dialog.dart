import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';

class Dialogeror extends StatefulWidget {
  final String message;
  final BuildContext context;
  const Dialogeror({super.key, required this.message, required this.context});

  @override
  State<Dialogeror> createState() => _DialogerorState();
}

class _DialogerorState extends State<Dialogeror> {
  @override
  void initState() {
    super.initState();
    final state = context.read<AuthProvider>().status;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (state is! Isloading) {
        Navigator.of(widget.context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("ok"),
        ),
      ],
      title: Text(
        widget.message,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      icon: Icon(Icons.error),
    );
  }
}

class Dialogsukses extends StatelessWidget {
  final String message;
  const Dialogsukses({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      icon: Icon(Icons.check),
    );
  }
}

class Dialogloading extends StatelessWidget {
  final BuildContext parentcontext;
  const Dialogloading({super.key, required this.parentcontext});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(content: const CircularProgressIndicator());
  }
}

class StatusDialogManager extends StatelessWidget {
  const StatusDialogManager({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthProvider>().status;

    if (state is IsIdle) {
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
