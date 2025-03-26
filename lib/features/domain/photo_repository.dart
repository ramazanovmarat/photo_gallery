import 'package:photo_gallery/features/domain/photo_entity.dart';

abstract class PhotoRepository {
  Future<List<PhotoEntity>> fetchPhotos();
  Future<void> savePhotos(List<PhotoEntity> photos);
  Future<List<PhotoEntity>> getSavedPhotos();
}
