import 'package:flutter/material.dart';

class Dialogeror extends StatelessWidget {
  final String message;
  const Dialogeror({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        },child: Text("ok"))
      ],
      title: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      icon: Icon(Icons.error),
    );
  }
}

class Dialogsukses extends StatelessWidget{
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

class Dialogloading extends StatelessWidget{
  const Dialogloading({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const CircularProgressIndicator(),
    );
  }
}
