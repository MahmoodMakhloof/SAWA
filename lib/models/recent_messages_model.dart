class RecentMessageModel {
  String? senderId;
  String? receiverId;
  String? receiverName;
  String? receiverProfilePic;
  String? senderName;
  String? senderProfilePic;
  String? dateTimeOfLastMessage;
  String? lastMessage;

  RecentMessageModel({
    required this.senderId,
    required this.senderName,
    required this.dateTimeOfLastMessage,
    required this.lastMessage,
    required this.senderProfilePic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverProfilePic,
  });

  RecentMessageModel.fromJson(Map<String, dynamic>? json) {
    senderId = json!['senderId'];
    senderName = json['senderName'];
    dateTimeOfLastMessage = json['dateTimeOfLastMessage'];
    lastMessage = json['lastMessage'];
    senderProfilePic = json['senderProfilePic'];
    receiverId= json['receiverId'];
    receiverName= json['receiverName'];
    receiverProfilePic = json['receiverProfilePic'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'dateTimeOfLastMessage': dateTimeOfLastMessage,
      'lastMessage': lastMessage,
      'senderProfilePic':senderProfilePic,
      'receiverId': receiverId,
      'receiverName':receiverName,
      'receiverProfilePic':receiverProfilePic
    };
  }
}
