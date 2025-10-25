class Modelupload {
  final bool error;
  final String message;
  const Modelupload(this.error, this.message);
  factory Modelupload.fromjson(Map<String, dynamic> json) {
    return Modelupload(json['error'], json['message']);
  }
}
