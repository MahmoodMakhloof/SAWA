class CommentModel {
  String? senderId;
  String? dateTime;
  String? text;
  String? profileImage;
  String? commenterName;

  CommentModel({
    required this.senderId,

    required this.dateTime,
    required this.text,
    required this.profileImage,
    required this.commenterName,


  });

  CommentModel.fromJson(Map<String, dynamic>? json) {
    senderId = json!['senderId'];
    dateTime = json['dataTime'];
    text = json['text'];
    profileImage = json['profileImage'];
    commenterName = json['commenterName'];

  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'dateTime': dateTime,
      'text': text,
      'profileImage':profileImage,
      'commenterName':commenterName,
    };
  }
}
