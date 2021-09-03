class PostModel {
  String? uid;
  String? name;
  String? profileImage;
  String? body;
  String? datetime;
  String? postImage;

  PostModel({
    required this.name,
    required this.uid,
    required this.profileImage,
    required this.body,
    required this.datetime,
    required this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    uid = json['uid'];
    profileImage = json['profileImage'];
    body = json['body'];
    datetime = json['datetime'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profileImage': profileImage,
      'body': body,
      'datetime': datetime,
      'postImage': postImage,
    };
  }
}
