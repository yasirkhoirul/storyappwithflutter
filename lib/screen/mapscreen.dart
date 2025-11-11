import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/maps_provider.dart';
import 'package:story_app/provider/status_provider.dart';

class Mapscreen extends StatefulWidget {
  final Function(Status) ontapmap;
  final Function() onbuttontap;
  final Function() onconfirm;
  const Mapscreen({
    super.key,
    required this.onconfirm,
    required this.ontapmap,
    required this.onbuttontap,
  });

  @override
  State<Mapscreen> createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {
  Set<Marker> markers = {};
  late GoogleMapController _googleMapController;
  @override
  void dispose() {
    markers.clear();
    super.dispose();
  }

  @override
  void initState() {
    final provider = context.read<MapsProvider>();
    provider.init();
    provider.addListener(listener);
    super.initState();
  }

  void listener() {
    if (!context.mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = context.read<MapsProvider>();
      final state = provider.statuspick;
      widget.ontapmap(state);

      if (state is IsError) {
        provider.setaddresempty();
        provider.clearmarker();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapsProvider>(
      builder: (context, value, child) {
        Logger().d("status picknya ${value.statuspick}");
        if (value.statuspick is Isloading) {}

        return switch (value.status) {
          Isloading() => Scaffold(
            body: Center(child: const CircularProgressIndicator()),
          ),
          IsError(message: var message) => Scaffold(
            body: Center(
              child: Column(children: [Icon(Icons.error), Text(message)]),
            ),
          ),
          Issuksesmessage() => Scaffold(
            appBar: AppBar(title: const Text("Maps")),
            body: SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    markers: value.markers,
                    onMapCreated: (controller) {
                      _googleMapController = controller;
                    },

                    onTap: (argument) async {
                      value.addplacemark(argument, _googleMapController);
                      widget.onbuttontap();
                    },
                    initialCameraPosition: CameraPosition(
                      zoom: 18,
                      target: LatLng(-7.826374275632044, 110.361005153619),
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    right: 10,
                    child: FloatingActionButton.small(
                      onPressed: () async {
                        await value.getMyLocation();
                        _googleMapController.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(
                              value.locations!.latitude!,
                              value.locations!.longitude!,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _ => Container(),
        };
      },
    );
  }
}

// class AlerDialog extends StatelessWidget {
//   const AlerDialog({super.key, required this.widget});

//   final Mapscreen widget;

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<MapsProvider>();
//     return switch (state.statuspick) {
//       IsError(message: var message) => AlertDialog(
//         title: const Text("Pilih Lokasi"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               state.setaddresempty();
//               state.clearmarker();
//               Navigator.of(context).pop();
//             },
//             child: const Text("Ok"),
//           ),
//         ],
//       ),
//       Issuksesmessage() => AlertDialog(
//         title: const Text("Pilih Lokasi"),
//         content: Text(
//           "Anda yakin ingin memilih tempat ini? \n ${state.saddress}",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               widget.onconfirm();
//             },
//             child: const Text("YA"),
//           ),
//           TextButton(
//             onPressed: () {
//               state.setaddresempty();

//               Navigator.of(context).pop();
//             },
//             child: const Text("Batal"),
//           ),
//         ],
//       ),
//       _ => AlertDialog(
//         title: const Text("Pilih Lokasi"),
//         content: const CircularProgressIndicator(),
//       ),
//     };
//   }
// }
