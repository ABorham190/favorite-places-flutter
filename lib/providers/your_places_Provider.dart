import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:favorite_places/models/place.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbDir = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbDir, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places (id TEXT PRIMARY KEY , title TEXT , lat REAL , lng REAL ,address TEXT , image TEXT)');
    },
    version: 1,
  );
  return db;
}

class YourPlacesNotifier extends StateNotifier<List<Place>> {
  YourPlacesNotifier() : super([]);
  void loadPlaces() async {
    final db = await _getDatabase();

    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            name: row['title'] as String,
            image: File(row['image'] as String),
            placeLocation: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
          ),
        )
        .toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation placeLocation) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final place = Place(
      name: title,
      image: copiedImage,
      placeLocation: placeLocation,
    );
    final db = await _getDatabase();
    await db.insert('user_places', {
      'id': place.id,
      'title': place.name,
      'lat': place.placeLocation.latitude,
      'lng': place.placeLocation.longitude,
      'address': place.placeLocation.address,
      'image': place.image.path,
    });

    state = [place, ...state];
  }
}

final yourPlacesProvider =
    StateNotifierProvider<YourPlacesNotifier, List<Place>>((ref) {
  return YourPlacesNotifier();
});
