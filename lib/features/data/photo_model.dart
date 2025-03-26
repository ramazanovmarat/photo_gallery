import 'package:photo_gallery/features/domain/photo_entity.dart';

class PhotoModel extends PhotoEntity {
  PhotoModel({
    required super.id,
    required super.title,
    required super.url,
    required super.thumbnailUrl,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory PhotoModel.fromDb(Map<String, dynamic> map) {
    return PhotoModel(
      id: map['id'],
      title: map['title'],
      url: map['url'],
      thumbnailUrl: map['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toDb() {
    return toJson();
  }
}