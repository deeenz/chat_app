import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/helpers/screen_factors.dart';
import 'package:chat_app/helpers/snackbar_helper.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/ui/shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final String receiverName;
  final String receiverId;
  final String chatId;

  const Chat(
      {Key? key,
      required this.receiverName,
      required this.chatId,
      required this.receiverId})
      : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(), createChat);
  }

  void createChat() async {
    UserModel? userModel =
        await Provider.of<AuthProvider>(context, listen: false)
            .getUserDetails();
    var chats =
        await Provider.of<ChatProvider>(context, listen: false).getChats();

    if (userModel == null) {
      showSnackbar(context, "Error encountered, please try again later");
      return;
    }

    // check if the chat model has not been previously created
    if (chats != null) {
      if ((chats
          .where((element) =>
              (element.receiverId == userModel.id &&
                  element.senderId == widget.receiverId) ||
              (element.senderId == userModel.id &&
                  element.receiverId == widget.receiverId))
          .isEmpty)) {
        ChatModel chatModel = ChatModel(
            id: widget.chatId,
            senderName: userModel.fullName,
            senderId: userModel.id,
            receiverId: widget.receiverId,
            receiverName: widget.receiverName);

        Provider.of<ChatProvider>(context, listen: false).createChat(chatModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        foregroundColor: mainDarkColor,
        title: Text(
          widget.receiverName,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<List<MessageModel>>(
        stream: FirebaseFirestore.instance
            .collection(MESSAGES_COLLECTION)
            .where("chatId", isEqualTo: widget.chatId)
            .snapshots()
            .map(
          (event) {
            return event.docs
                .map((e) => MessageModel.fromJson(e.data()))
                .toList()
                .reversed
                .toList();
          },
        ),
        builder: (context, AsyncSnapshot<List<MessageModel>> messages) {
          if (messages.hasError || !messages.hasData) {
            return const SizedBox();
          }
          return ListView.builder(
            itemCount: messages.data!.length,
            padding: EdgeInsets.only(top: 20.h),
            itemBuilder: (context, index) => Container(
              child: Text(
                messages.data![index].message,
                style: TextStyle(
                  color: white,
                  fontSize: 12.sp,
                ),
              ),
              padding: EdgeInsets.all(10.sp),
              margin: (messages.data![index].senderId ==
                      FirebaseAuth.instance.currentUser!.uid)
                  ? EdgeInsets.only(
                      right: deviceWidth(context) * .3, bottom: 5, left: 20)
                  : EdgeInsets.only(
                      left: deviceWidth(context) * .3, bottom: 5, right: 20),
              decoration: BoxDecoration(
                color: (messages.data![index].senderId ==
                        FirebaseAuth.instance.currentUser!.uid)
                    ? mainDarkColor
                    : secDarkColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(
                    10,
                  ),
                  topRight: const Radius.circular(
                    10,
                  ),
                  bottomLeft: (messages.data![index].senderId ==
                          FirebaseAuth.instance.currentUser!.uid)
                      ? Radius.zero
                      : const Radius.circular(
                          10,
                        ),
                  bottomRight: (messages.data![index].senderId !=
                          FirebaseAuth.instance.currentUser!.uid)
                      ? Radius.zero
                      : const Radius.circular(
                          10,
                        ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: sendMessageWidget(),
    );
  }

  TextEditingController messageController = TextEditingController();
  void sendMessage() {
    if (messageController.text.isEmpty) {
      showSnackbar(context, "Provice a message to send!");
      return;
    }
    MessageModel messageModel = MessageModel(
        chatId: widget.chatId,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        message: messageController.text);

    Provider.of<ChatProvider>(context, listen: false).sendMessage(messageModel);
  }

  Widget sendMessageWidget() {
    return Padding(
      padding: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Input message',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Icon(
                Icons.send,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: sendMessage,
          )
        ],
      ),
    );
  }
}
