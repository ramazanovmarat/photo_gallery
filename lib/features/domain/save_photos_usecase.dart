import 'package:photo_gallery/features/domain/photo_entity.dart';
import 'package:photo_gallery/features/domain/photo_repository.dart';

class SavePhotosUseCase {
  final PhotoRepository repository;

  SavePhotosUseCase(this.repository);

  Future<void> call(List<PhotoEntity> photos) async {
    await repository.savePhotos(photos);
  }
}
