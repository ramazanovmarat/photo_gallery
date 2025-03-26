import 'package:photo_gallery/features/data/local_data_source.dart';
import 'package:photo_gallery/features/data/photo_model.dart';
import 'package:photo_gallery/features/data/remote_data_source.dart';
import 'package:photo_gallery/features/domain/photo_entity.dart';
import 'package:photo_gallery/features/domain/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  PhotoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<PhotoEntity>> fetchPhotos() async {
    try {
      final photos = await remoteDataSource.fetchPhotos();
      await localDataSource.savePhotos(photos);
      return photos;
    } catch (e) {
      return await localDataSource.getSavedPhotos();
    }
  }

  @override
  Future<void> savePhotos(List<PhotoEntity> photos) async {
    await localDataSource.savePhotos(
      photos.map((e) => PhotoModel(
        id: e.id,
        title: e.title,
        url: e.url,
        thumbnailUrl: e.thumbnailUrl,
      )).toList(),
    );
  }

  @override
  Future<List<PhotoEntity>> getSavedPhotos() async {
    return await localDataSource.getSavedPhotos();
  }
}