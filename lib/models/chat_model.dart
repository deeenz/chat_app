class ChatModel {
  String senderName;
  String receiverName;
  String senderId;
  String receiverId;
  String id;

  ChatModel({
    required this.id,
    required this.senderName,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
  });

  ChatModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        senderName = json['senderName'] as String,
        receiverName = json['receiverName'] as String,
        senderId = json['senderId'] as String,
        receiverId = json['receiverId'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderName': senderName,
        'receiverName': receiverName,
        'senderId': senderId,
        'receiverId': receiverId
      };
}
