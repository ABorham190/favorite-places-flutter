import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/providers/your_places_Provider.dart';

class AddNewPlaceScreen extends ConsumerWidget {
  AddNewPlaceScreen({
    super.key,
  });

  final _enteredPlaceNameController = TextEditingController();
  void _submit(BuildContext context, WidgetRef ref, String title) {
    if (_enteredPlaceNameController.text.trim().isEmpty ||
        _enteredPlaceNameController.text.trim().length < 2) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Place name must be from 2-50 characters!!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });

      return;
    }
    ref.read(yourPlacesProvider.notifier).addPlace(title);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var placeTitle = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: _enteredPlaceNameController,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('title'),
              ),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              onChanged: (value) => placeTitle = value,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () {
              _submit(context, ref, placeTitle);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 10,
                ),
                Text('Add Place'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
