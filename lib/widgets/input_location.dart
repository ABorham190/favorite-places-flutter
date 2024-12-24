import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class InputLocation extends StatefulWidget {
  const InputLocation({
    super.key,
    required this.onGetLocation,
  });

  final void Function(PlaceLocation placelocation) onGetLocation;
  @override
  State<InputLocation> createState() {
    return _InputLocation();
  }
}

class _InputLocation extends State<InputLocation> {
  PlaceLocation? _pickedLocation;
  var _isLoadingLocation = false;
  String get _locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    //this data contain secret key (google)
    return 'secret data';
  }

  void savePlace(double latitude, double longitude) async {
    //this data contain secret key (google)

    final url = Uri.parse('secret data');

    final response = await http.get(url);

    final responseData = json.decode(response.body);
    final address = responseData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: address);
      _isLoadingLocation = false;
    });

    widget.onGetLocation(_pickedLocation!);
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isLoadingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final long = locationData.longitude;
    if (lat == null || long == null) {
      return;
    }
    savePlace(lat, long);
  }

  void selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    savePlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewedContent = const Text(
      'No location detected',
      style: TextStyle(color: Colors.white),
    );
    if (_isLoadingLocation) {
      previewedContent = const CircularProgressIndicator();
    }
    if (_pickedLocation != null) {
      previewedContent = Image.network(
        _locationImage,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(.75),
            ),
          ),
          child: previewedContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text(
                'Get current location',
              ),
            ),
            TextButton.icon(
              onPressed: selectOnMap,
              label: const Text('Select on map'),
              icon: const Icon(Icons.map),
            ),
          ],
        )
      ],
    );
  }
}
