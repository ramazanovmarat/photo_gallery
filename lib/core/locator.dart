import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:photo_gallery/features/data/local_data_source.dart';
import 'package:photo_gallery/features/data/photo_repository_impl.dart';
import 'package:photo_gallery/features/data/remote_data_source.dart';
import 'package:photo_gallery/features/domain/fetch_photos_usecase.dart';
import 'package:photo_gallery/features/domain/get_saved_photos_usecase.dart';
import 'package:photo_gallery/features/domain/photo_repository.dart';
import 'package:photo_gallery/features/domain/save_photos_usecase.dart';
import 'package:photo_gallery/features/ui/bloc/photo_bloc.dart';

final GetIt locator = GetIt.instance;

void serviceLocator() {
  _repositories();
  _dataSources();
  _useCases();
  _bloc();
}

void _repositories() {
  locator.registerLazySingleton<PhotoRepository>(() => PhotoRepositoryImpl(
    remoteDataSource: locator(),
    localDataSource: locator(),
  ));
}

void _dataSources() {
  locator.registerLazySingleton<http.Client>(() => http.Client());
  locator.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(locator<http.Client>()));
  locator.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
}

void _useCases() {
  locator.registerLazySingleton<FetchPhotosUseCase>(() => FetchPhotosUseCase(locator()));
  locator.registerLazySingleton<GetSavedPhotosUseCase>(() => GetSavedPhotosUseCase(locator()));
  locator.registerLazySingleton<SavePhotosUseCase>(() => SavePhotosUseCase(locator()));
}

void _bloc() {
  locator.registerFactory(() => PhotoBloc(
    fetchPhotosUseCase: locator(),
    getSavedPhotosUseCase: locator(),
    savePhotosUseCase: locator(),
  ));
}