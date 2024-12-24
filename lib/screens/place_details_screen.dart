import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({
    super.key,
    required this.place,
  });

  final Place place;
  String get _locationImage {
    final lat = place.placeLocation.latitude;
    final lng = place.placeLocation.longitude;
    //this data involves secret key
    return 'Secret data';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Stack(
        children: [
          Image(
            image: FileImage(place.image),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                            location: place.placeLocation,
                            isSelecting: false,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_locationImage),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    place.placeLocation.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
