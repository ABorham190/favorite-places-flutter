import 'dart:io';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place(
      {required this.name,
      required this.image,
      required this.placeLocation,
      String? id})
      : id = id ?? uuid.v4();
  final String id;
  final String name;
  File image;
  PlaceLocation placeLocation;
}
