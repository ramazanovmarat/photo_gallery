import 'package:photo_gallery/features/domain/photo_entity.dart';
import 'package:photo_gallery/features/domain/photo_repository.dart';

class FetchPhotosUseCase {
  final PhotoRepository repository;

  FetchPhotosUseCase(this.repository);

  Future<List<PhotoEntity>> call() async {
    return await repository.fetchPhotos();
  }
}
