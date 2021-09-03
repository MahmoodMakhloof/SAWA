
// enum NotificationState {LIKE,COMMENT}

class NotificationModel {
  String? senderUid;
  String? receiverUid;
  String? senderName;
  String? senderProfileImage;
  String? action;
  String? targetPostUid;
  String? dateTime;
  bool? seen;


  NotificationModel(
      {
        required this.action,
        required this.receiverUid,
        required this.senderName,
        required this.senderProfileImage,
        required this.senderUid,
        required this.targetPostUid,
        required this.dateTime,
        required this.seen
      });

  NotificationModel.fromJson(Map<String, dynamic>? json) {
    action = json!['action'];
    receiverUid = json['receiverUid'];
    senderUid = json['senderUid'];
    senderName = json['senderName'];
    senderProfileImage = json['senderProfileImage'];
    targetPostUid = json['targetPostUid'];
    dateTime = json['dateTime'];
    seen = json['seen'];
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'receiverUid': receiverUid,
      'senderUid': senderUid,
      'senderName': senderName,
      'senderProfileImage': senderProfileImage,
      'targetPostUid': targetPostUid,
      'dateTime': dateTime,
      'seen': seen
    };
  }
}
