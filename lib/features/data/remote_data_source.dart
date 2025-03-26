import 'dart:convert';
import 'package:photo_gallery/core/api_url.dart';
import 'package:photo_gallery/core/failures.dart';
import 'package:photo_gallery/features/data/photo_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<List<PhotoModel>> fetchPhotos();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl(this.client);

  @override
  Future<List<PhotoModel>> fetchPhotos() async {
    try {
      final response = await client.get(Uri.parse(apiUrl));

      if(response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((e) => PhotoModel.fromJson(e)).toList();
      } else {
        throw ServerFailure('Ошибка загрузки данных: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerFailure('Не удалось подключиться к серверу');
    }
  }

}