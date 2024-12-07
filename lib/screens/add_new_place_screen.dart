import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/providers/your_places_Provider.dart';

class AddNewPlaceScreen extends ConsumerWidget {
  AddNewPlaceScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    void save() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Navigator.of(context).pop();
      }
    }

    var placeTitle = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('title'),
                ),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                validator: (value) {
                  if (value!.trim().isEmpty ||
                      value.trim().length < 2 ||
                      value.trim().length > 50) {
                    return 'Place title must be between 2-50 character';
                  }
                  return null;
                },
                onSaved: (value) {
                  ref.read(yourPlacesProvider.notifier).addPlace(value!);
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: save,
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
      ),
    );
  }
}
