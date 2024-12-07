import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_details_screen.dart';
import 'package:flutter/material.dart';

class PlaceListItem extends StatelessWidget {
  const PlaceListItem({
    super.key,
    required this.place,
  });
  final Place place;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return PlaceDetailsScreen(place: place);
            },
          ),
        );
      },
      child: ListTile(
        title: Text(
          place.name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}
