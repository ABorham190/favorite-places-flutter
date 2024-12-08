import 'dart:io';

import 'package:favorite_places/widgets/input_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/providers/your_places_Provider.dart';

class AddNewPlaceScreen extends ConsumerWidget {
  const AddNewPlaceScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    File? selectedImage;
    String? placeTitle;
    final formKey = GlobalKey<FormState>();
    void save() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        ref
            .read(yourPlacesProvider.notifier)
            .addPlace(placeTitle!, selectedImage!);
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text(
                    'title',
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                  placeTitle = value!;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              InputImage(
                onPickImage: (image) {
                  selectedImage = image;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton.icon(
                onPressed: save,
                label: const Text('Add Place'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
