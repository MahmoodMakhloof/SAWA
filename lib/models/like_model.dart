class LikeModel {
  bool? like;

  LikeModel({
    required this.like,
  });

  LikeModel.fromJson(Map<String, dynamic>? json) {
    like = json!['like'];
  }

  Map<String, dynamic> toMap() {
    return {
      'like': like,
    };
  }
}
