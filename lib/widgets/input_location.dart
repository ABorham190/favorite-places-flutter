import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
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

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lng&key=AIzaSyD_137n_Pb0bUn1BJ0S0hYydicTAjfiXkk';
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

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyD_137n_Pb0bUn1BJ0S0hYydicTAjfiXkk');

    final response = await http.get(url);

    final responseData = json.decode(response.body);
    final address = responseData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat, longitude: long, address: address);
      _isLoadingLocation = false;
    });
    widget.onGetLocation(_pickedLocation!);
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
              onPressed: () {},
              label: const Text('Select on map'),
              icon: const Icon(Icons.map),
            ),
          ],
        )
      ],
    );
  }
}
