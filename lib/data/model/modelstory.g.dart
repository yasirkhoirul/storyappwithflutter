// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelstory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Modelstory _$ModelstoryFromJson(Map<String, dynamic> json) => Modelstory(
  json['error'] as bool,
  json['message'] as String,
  json['listStory'] != null
      ? (json['listStory'] as List<dynamic>)
            .map((e) => DetailStory.fromJson(e as Map<String, dynamic>))
            .toList()
      : [],
);

DetailStory _$DetailStoryFromJson(Map<String, dynamic> json) => DetailStory(
  json['id'] as String,
  json['name'] as String,
  json['description'] as String,
  json['photoUrl'] as String,
  json['createdAt'] as String,
  (json['lat'] as num?)?.toDouble(),
  (json['long'] as num?)?.toDouble(),
);

Modelstorydetail _$ModelstorydetailFromJson(Map<String, dynamic> json) =>
    Modelstorydetail(
      json['error'] as bool,
      json['message'] as String,
      DetailStory.fromJson(json['story'] as Map<String, dynamic>),
    );
