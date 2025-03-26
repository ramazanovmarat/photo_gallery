import 'package:photo_gallery/features/domain/photo_entity.dart';
import 'package:photo_gallery/features/domain/photo_repository.dart';

class GetSavedPhotosUseCase {
  final PhotoRepository repository;

  GetSavedPhotosUseCase(this.repository);

  Future<List<PhotoEntity>> call() async {
    return await repository.getSavedPhotos();
  }
}
