import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepo {

    Future<List<ChatModel>?> getChats() async {
    try {
    var res =  ( await FirebaseFirestore.instance
          .collection(CHATS_COLLECTION)
          .get()).docs.map((e) => ChatModel.fromJson(e.data())).toList();
      return res;
    } catch (e) {
      return null;
    }
  }
  Future<String?> createChat(ChatModel chatModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(CHATS_COLLECTION)
          .doc(chatModel.id)
          .set(
            chatModel.toJson(),
          );
      return null;
    } catch (e) {
      return "Unable to chat at the moment, please try again later";
    }
  }

  Future<String?> sendMessage(MessageModel messageModel) async {
    try {
      await FirebaseFirestore.instance.collection(MESSAGES_COLLECTION).add(
            messageModel.toJson(),
          );
      return null;
    } catch (e) {
      return "Unable to send message at the moment, please try again later";
    }
  }
}
