import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/helpers/route_generator.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/ui/screens/all_users.dart';
import 'package:chat_app/ui/screens/login_screen.dart';
import 'package:chat_app/ui/shared/colors.dart';
import 'package:chat_app/ui/shared/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/screen_factors.dart';
import '../shared/space.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AllUsers(),
            ),
          );
        },
        backgroundColor: secColor,
        child: const Icon(
          Icons.chat,
          color: white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: const Text(
          "Chats",
          style: TextStyle(
            color: mainDarkColor,
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        contentPadding: const EdgeInsets.all(10),
                        titlePadding: const EdgeInsets.all(10),
                        title: const Text("Logout"),
                        children: [
                          Styles.regular("Are you sure you want to logout"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: mainColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => const Login()));
                                },
                                child: Styles.regular("Logout", color: grey),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  title: const Text("Logout"),
                  leading: const Icon(Icons.logout),
                ),
              )
            ],
            child: const Icon(
              Icons.more_vert,
              color: mainDarkColor,
            ),
          )
        ],
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: FirebaseFirestore.instance
            .collection(CHATS_COLLECTION)
            .snapshots()
            .map(
          (event) {
            return event.docs
                .map((e) => ChatModel.fromJson(e.data()))
                .where(
                  (element) => (element.senderId ==
                          FirebaseAuth.instance.currentUser!.uid ||
                      element.receiverId ==
                          FirebaseAuth.instance.currentUser!.uid),
                )
                .toList();
          },
        ),
        builder: (context, AsyncSnapshot<List<ChatModel>> chats) {
          if (chats.hasError || !chats.hasData || chats.data!.isEmpty) {
            return SizedBox(
              width: deviceWidth(context),
              child: Column(
                children: [
                  VSpace(deviceHeight(context) * .3),
                  Image.asset(
                    "assets/chat_logo.jpeg",
                    height: 80.sp,
                    width: 80.sp,
                    fit: BoxFit.contain,
                  ),
                  VSpace(10.h),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AllUsers(),
                        ),
                      );
                    },
                    child: Styles.regular(
                      "You do not have any active chat\nClick here to start one",
                      align: TextAlign.center,
                      color: mainDarkColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: chats.data!.length,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: grey,
                child: Text(
                  (chats.data![index].senderId ==
                          FirebaseAuth.instance.currentUser!.uid)
                      ? chats.data![index].receiverName[0].toUpperCase()
                      : chats.data![index].senderName[0].toUpperCase(),
                  style: TextStyle(color: white, fontSize: 15.sp),
                ),
              ),
              title: Text(
                (chats.data![index].senderId ==
                        FirebaseAuth.instance.currentUser!.uid)
                    ? chats.data![index].receiverName
                    : chats.data![index].senderName,
              ),
              subtitle: const Text(
                "Tap to view chats",
              ),
              onTap: () {
                // goto chat page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Chat(
                      receiverName: (chats.data![index].senderId ==
                              FirebaseAuth.instance.currentUser!.uid)
                          ? chats.data![index].receiverName
                          : chats.data![index].senderName,
                      chatId: chats.data![index].id,
                      receiverId: chats.data![index].receiverId,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
