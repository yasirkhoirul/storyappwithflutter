class Modelstory {
  final bool error;
  final String message;
  final List<DetailStory> liststory;
  const Modelstory(this.error, this.message, this.liststory);
  factory Modelstory.fromjson(Map<String, dynamic> json) {
    return Modelstory(
      json['error'],
      json['message'],
      (json['listStory'] as List).map((e) => DetailStory.fromjson(e)).toList(),
    );
  }
}

class DetailStory {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double lat;
  final double long;
  const DetailStory(
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.long,
  );
  factory DetailStory.fromjson(Map<String, dynamic> json) {
    return DetailStory(
      json['id'],
      json['name'],
      json['description'],
      json['photoUrl'],
      json['createdAt'],
      (json['lat'] as num).toDouble(),
      (json['lon'] as num).toDouble(),
    );
  }
}

class Modelstorydetail {
  final bool error;
  final String message;
  final DetailStory liststory;
  const Modelstorydetail(this.error, this.message, this.liststory);
  factory Modelstorydetail.fromjson(Map<String, dynamic> json) {
    return Modelstorydetail(
      json['error'],
      json['message'],
      DetailStory.fromjson(json['story']),
    );
  }
}
