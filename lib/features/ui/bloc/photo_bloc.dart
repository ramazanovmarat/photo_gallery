import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/core/failures.dart';
import 'package:photo_gallery/features/domain/fetch_photos_usecase.dart';
import 'package:photo_gallery/features/domain/get_saved_photos_usecase.dart';
import 'package:photo_gallery/features/domain/save_photos_usecase.dart';
import 'package:photo_gallery/features/ui/bloc/photo_event.dart';
import 'package:photo_gallery/features/ui/bloc/photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final FetchPhotosUseCase fetchPhotosUseCase;
  final GetSavedPhotosUseCase getSavedPhotosUseCase;
  final SavePhotosUseCase savePhotosUseCase;

  PhotoBloc({
    required this.fetchPhotosUseCase,
    required this.getSavedPhotosUseCase,
    required this.savePhotosUseCase,
  }) : super(PhotoInitial()) {
    on<FetchPhotos>(_onFetchPhotos);
    on<GetSavedPhotos>(_onGetSavedPhotos);
    on<SavePhotos>(_onSavePhotos);
  }

  Future<void> _onFetchPhotos(FetchPhotos event, Emitter<PhotoState> emit) async {
    emit(PhotoLoading());

    try {
      final photos = await fetchPhotosUseCase();
      emit(PhotoLoaded(photos));
    } catch (failure) {
      emit(PhotoError(ServerFailure("Неизвестная ошибка")));
    }
  }

  Future<void> _onGetSavedPhotos(GetSavedPhotos event, Emitter<PhotoState> emit) async {
    emit(PhotoLoading());

    try {
      final photos = await getSavedPhotosUseCase();
      emit(PhotoLoaded(photos));
    } catch (failure) {
      emit(PhotoError(CacheFailure("Ошибка при загрузке из кеша")));
    }
  }

  Future<void> _onSavePhotos(SavePhotos event, Emitter<PhotoState> emit) async {
    try {
      await savePhotosUseCase(event.photos);
    } catch (failure) {
      emit(PhotoError(CacheFailure("Ошибка при сохранении")));
    }
  }
}