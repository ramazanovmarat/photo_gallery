import 'package:photo_gallery/features/domain/photo_entity.dart';

abstract class PhotoEvent  {}

class FetchPhotos extends PhotoEvent {}

class GetSavedPhotos extends PhotoEvent {}

class SavePhotos extends PhotoEvent {
  final List<PhotoEntity> photos;

  SavePhotos(this.photos);
}