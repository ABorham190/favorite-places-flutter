import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class YourPlacesNotifier extends StateNotifier<List<Place>> {
  YourPlacesNotifier() : super([]);
  void addPlace(String title, File image) {
    final place = Place(
      name: title,
      image: image,
    );
    state = [place, ...state];
  }
}

final yourPlacesProvider =
    StateNotifierProvider<YourPlacesNotifier, List<Place>>((ref) {
  return YourPlacesNotifier();
});
