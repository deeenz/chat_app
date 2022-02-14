import 'package:chat_app/repositories/chat_repo.dart';
import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatProvider extends ChangeNotifier {
  ChatRepo chatRepo = ChatRepo();

  Future<List<ChatModel>?> getChats() async {
    return chatRepo.getChats();
  }

  Future<String?> createChat(ChatModel chatModel) async {
    return chatRepo.createChat(chatModel);
  }

  Future<String?> sendMessage(MessageModel messageModel) async {
    return chatRepo.sendMessage(messageModel);
  }
}
