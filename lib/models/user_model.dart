class UserModel {
  String? email;
  String? uid;
  String? name;
  bool? isEmailVerified;
  String? profileImage;
  String? coverImage;
  String? bio;
  bool? isMale;

  UserModel(
      {required this.name,
      required this.email,
      required this.uid,
      required this.isEmailVerified,
      required this.profileImage,
      required this.coverImage,
      required this.bio,
      required this.isMale});

  UserModel.fromJson(Map<String, dynamic>? json) {
    email = json!['email'];
    name = json['name'];
    uid = json['uid'];
    isEmailVerified = json['isEmailVerified'];
    profileImage = json['profileImage'];
    coverImage = json['coverImage'];
    bio = json['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'bio': bio,
      'isMale': isMale
    };
  }
}
