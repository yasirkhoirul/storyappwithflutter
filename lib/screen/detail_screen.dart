import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/detail_provider.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailScreen extends StatefulWidget {
  final String? id;
  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!context.mounted) return;
      context.read<DetailProvider>().getdetaail(widget.id ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 800),
            child: Consumer<DetailProvider>(
              builder: (context, value, child) {
                return switch (value.status) {
                  IsError(message: var message) => AlertDialog(
                    title: const Text("Error"),
                    content: Text(message),
                    actions: [
                      TextButton(
                        onPressed: () {
                          value.setidle();
                        },
                        child: const Text("ok"),
                      ),
                    ],
                  ),
                  Issuksesmessage() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 200,
                        child: FadeInImage.memoryNetwork(
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                          placeholder: kTransparentImage,
                          image: value.datas!.liststory.photoUrl,
                        ),
                      ),
                      Text(
                        value.datas!.liststory.name,
                        style: Theme.of(context).textTheme.displayMedium,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        value.datas!.liststory.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                  _ => CircularProgressIndicator(),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}
