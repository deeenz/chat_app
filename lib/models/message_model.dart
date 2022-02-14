class MessageModel {
  String chatId;
  String senderId;
  String message;

  MessageModel({
    required this.chatId,
    required this.senderId,
    required this.message,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'] as String,
        chatId = json['chatId'] as String,
        message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'chatId': chatId,
        'message': message,
      };
}
