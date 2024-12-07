import 'package:favorite_places/models/place.dart';
import 'package:riverpod/riverpod.dart';

class YourPlacesNotifier extends StateNotifier<List<Place>> {
  YourPlacesNotifier() : super([]);
  void addPlace(String title) {
    final place = Place(id: (state.length + 1).toString(), name: title);
    state = [...state, place];
  }
}

final yourPlacesProvider =
    StateNotifierProvider<YourPlacesNotifier, List<Place>>((ref) {
  return YourPlacesNotifier();
});
