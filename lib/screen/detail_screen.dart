import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            constraints: BoxConstraints(minHeight: 800, maxHeight: 1200),
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
                          context.read<DetailProvider>().getdetaail(
                            widget.id ?? "",
                          );
                        },
                        child: const Text("ok"),
                      ),
                    ],
                  ),
                  Issuksesmessage() => Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          (value.datas!.liststory.lat != null &&
                                  value.datas!.liststory.long != null)
                              ? Flexible(
                                  child: SizedBox(
                                    height: 600,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            height: 400,
                                            child: IgnorePointer(
                                              ignoring: true,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadiusGeometry.circular(
                                                      12,
                                                    ),
                                                child: GoogleMap(
                                                  markers: {
                                                    Marker(
                                                      markerId: MarkerId(
                                                        "location",
                                                      ),
                                                      position: LatLng(
                                                        value
                                                            .datas!
                                                            .liststory
                                                            .lat!,
                                                        value
                                                            .datas!
                                                            .liststory
                                                            .long!,
                                                      ),
                                                    ),
                                                  },
                                                  zoomControlsEnabled: false,
                                                  zoomGesturesEnabled: false,
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                        zoom: 18,
                                                        target: LatLng(
                                                          value
                                                              .datas!
                                                              .liststory
                                                              .lat!,
                                                          value
                                                              .datas!
                                                              .liststory
                                                              .long!,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Icon(
                                                Icons.location_city,
                                                size: 25,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(value.addresss),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(12),
                            child: Container(
                              color: Colors.blueGrey,
                              child: SizedBox(
                                height: 200,
                                width: double.maxFinite,
                                child: FadeInImage.memoryNetwork(
                                  fit: BoxFit.contain,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) =>
                                          Icon(Icons.error),
                                  placeholder: kTransparentImage,
                                  image: value.datas!.liststory.photoUrl,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            value.datas!.liststory.name,
                            style: Theme.of(context).textTheme.displayMedium,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.fade,
                          ),
                          Divider(height: 1),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value.datas!.liststory.description,
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _ => Center(child: CircularProgressIndicator()),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}
