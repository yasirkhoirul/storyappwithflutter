import 'package:json_annotation/json_annotation.dart';

part 'modelstory.g.dart';

@JsonSerializable()
class Modelstory {
  final bool error;
  final String message;
  final List<DetailStory> liststory;
  const Modelstory(this.error, this.message, this.liststory);
  factory Modelstory.fromJson(Map<String, dynamic> json) =>
      _$ModelstoryFromJson(json);
}

@JsonSerializable()
class DetailStory {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double? lat;
  final double? long;
  const DetailStory(
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.long,
  );
  factory DetailStory.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryFromJson(json);
}

@JsonSerializable()
class Modelstorydetail {
  final bool error;
  final String message;
  final DetailStory liststory;
  const Modelstorydetail(this.error, this.message, this.liststory);
  factory Modelstorydetail.fromJson(Map<String, dynamic> json) =>
      _$ModelstorydetailFromJson(json);
}
