import 'package:path/path.dart';
import 'package:photo_gallery/core/failures.dart';
import 'package:photo_gallery/features/data/photo_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource {
  Future<void> savePhotos(List<PhotoModel> photos);
  Future<List<PhotoModel>> getSavedPhotos();
}

class LocalDataSourceImpl implements LocalDataSource {
  static const String _tableName = 'photos';

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'photos.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, title TEXT, url TEXT, thumbnailUrl TEXT)',
        );
      },
      version: 1,
    );
  }

  @override
  Future<List<PhotoModel>> getSavedPhotos() async {
    try {
      final db = await _getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(_tableName);

      return maps.map((e) => PhotoModel.fromDb(e)).toList();
    } catch (e) {
      throw CacheFailure('Ошибка загрузки из кеша');
    }
  }

  @override
  Future<void> savePhotos(List<PhotoModel> photos) async {
    try {
      final db = await _getDatabase();
      final batch = db.batch();

      for (var photo in photos) {
        batch.insert(
          _tableName,
          photo.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit();
    } catch (e) {
      throw CacheFailure('Ошибка сохранения в кеш');
    }
  }

}