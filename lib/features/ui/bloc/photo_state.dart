import 'package:photo_gallery/core/failures.dart';
import 'package:photo_gallery/features/domain/photo_entity.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final List<PhotoEntity> photos;

  PhotoLoaded(this.photos);
}

// Ошибка
class PhotoError extends PhotoState {
  final Failure failure;

  PhotoError(this.failure);
}
