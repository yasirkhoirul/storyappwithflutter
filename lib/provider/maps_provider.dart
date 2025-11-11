import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/web.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MapsProvider extends ChangeNotifier {
  final Location location;
  MapsProvider(this.location);
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  bool _service = false;
  bool get service => _service;
  PermissionStatus _permession = PermissionStatus.denied;
  PermissionStatus get permession => _permession;
  LocationData? _locations;
  LocationData? get locations => _locations;
  Status statuspick = IsIdle();
  String saddress = "";
  LatLng? latlangs;
  Status status = IsIdle();

  addmarker(LatLng latlang, void Function() ontap) {
    _markers.clear();
    _markers.add(
      Marker(
        infoWindow: InfoWindow(title: saddress),
        markerId: MarkerId("marker $latlang"),
        position: latlang,
        onTap: ontap,
      ),
    );
    notifyListeners();
  }

  addplacemark(LatLng latlang, GoogleMapController gmaps) async {
    statuspick = Isloading();
    notifyListeners();
    try {
      Logger().d("mauk add placemark");
      final info = await geo.placemarkFromCoordinates(
        latlang.latitude,
        latlang.longitude,
      );
      Logger().d("info ${info[0]}");
      final place = info[0];
      final address =
          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      saddress = address;
      latlangs = latlang;
      addmarker(latlang, () {
        gmaps.animateCamera(CameraUpdate.newLatLng(latlang));
      });
      statuspick = Issuksesmessage(message: "anda memilih $address");
    } on TimeoutException {
      statuspick = IsError("koneksi kurang stabil silahkan coba lagi");
    } on PlatformException {
      statuspick = IsError("koneksi kurang stabil silahkan coba lagi");
    } catch (e) {
      Logger().e("terjadi error di placemark $e");
      statuspick = IsError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void setaddresempty() {
    saddress = "";
    notifyListeners();
  }

  void clearmarker() {
    _markers.clear();
    notifyListeners();
  }

  void init() async {
    status = Isloading();
    notifyListeners();
    try {
      await getservice();
      await getPermission();
      status = Issuksesmessage(message: "berhasil");
    } catch (e) {
      status = IsError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  getservice() async {
    Logger().d("masuk ke get servicce");
    _service = await location.serviceEnabled();
    Logger().d("service pertama $service");
    if (_service == false) {
      _service = await location.requestService();
      Logger().d("service kedua $service");
      notifyListeners();
      if (_service == false) {
        throw Exception("service tidak dinyalakan");
      }
    }
    notifyListeners();
  }

  getPermission() async {
    Logger().d("masuk ke get permession");
    _permession = await location.hasPermission();
    Logger().d("permession pertama $permession");
    if (_permession == PermissionStatus.denied) {
      _permession = await location.requestPermission();
      Logger().d("permession kedua $permession");
      if (_permession == PermissionStatus.denied) {
        throw Exception("permession tidak diizinkan");
      }
    }
    if (permession == PermissionStatus.deniedForever) {
      throw Exception(
        "permession ditolak selamanya silahkan aktifkan lewat setting",
      );
    }
    notifyListeners();
  }

  getMyLocation() async {
    _locations = await location.getLocation();
    notifyListeners();
  }
}
