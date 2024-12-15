import 'package:favorite_places/screens/add_new_place_screen.dart';
import 'package:favorite_places/widgets/place_list_item.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/providers/your_places_Provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourPlacesScreen extends ConsumerStatefulWidget {
  const YourPlacesScreen({
    super.key,
  });

  @override
  ConsumerState<YourPlacesScreen> createState() {
    return _YourPlacesScreenState();
  }
}

class _YourPlacesScreenState extends ConsumerState<YourPlacesScreen> {
  void _addNewPlace(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return const AddNewPlaceScreen();
      }),
    );
  }

  late Future<void> _futurePlaces;
  @override
  void initState() {
    super.initState();

    _futurePlaces = ref.read(yourPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final placesList = ref.watch(yourPlacesProvider);
    Widget content = Center(
      child: Text(
        'No places added right now',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
    if (placesList.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: PlaceListItem(
              place: placesList[index],
            ),
          );
        },
        itemCount: placesList.length,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Your Places', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {
              _addNewPlace(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _futurePlaces,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: content,
                  ),
      ),
    );
  }
}
