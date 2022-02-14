import 'dart:math';

import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/ui/screens/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/screen_factors.dart';
import '../shared/colors.dart';
import '../shared/space.dart';
import '../shared/styles.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({
    Key? key,
  }) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: mainDarkColor,
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Users",
          style: TextStyle(
            color: mainDarkColor,
          ),
        ),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .snapshots()
            .map(
          (event) {
            return event.docs
                .map(
                  (e) => UserModel.fromJson(
                    e.data(),
                  ),
                )
                .where((element) =>
                    element.id != FirebaseAuth.instance.currentUser!.uid)
                .toList();
          },
        ),
        builder: (context, users) {
          if (users.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: deviceWidth(context),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (users.hasError || !users.hasData) {
            return SizedBox(
              width: deviceWidth(context),
              child: Column(
                children: [
                  VSpace(deviceHeight(context) * .3),
                  Styles.regular(
                    "Unable to get users list at the moment,\nplease try again later",
                    align: TextAlign.center,
                    color: mainDarkColor,
                    fontSize: 12.sp,
                  ),
                ],
              ),
            );
          }

          if (users.data!.isEmpty) {
            return SizedBox(
              width: deviceWidth(context),
              child: Column(
                children: [
                  VSpace(deviceHeight(context) * .3),
                  Styles.regular(
                    "No other users on this app for now,\n please ask you friends to create accounts",
                    align: TextAlign.center,
                    color: mainDarkColor,
                    fontSize: 12.sp,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: users.data!.length,
            itemBuilder: ((context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: grey,
                  child: Text(
                    users.data![index].fullName[0].toUpperCase(),
                    style: TextStyle(color: white, fontSize: 15.sp),
                  ),
                ),
                title: Text(users.data![index].fullName),
                subtitle: const Text(
                  "Tap to start chatting",
                ),
                onTap: () {
                  // get chat id
                  String chatId = Random().nextInt(7676767).toString();
                  // goto chat page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Chat(
                        receiverName: users.data![index].fullName,
                        chatId: chatId,
                        receiverId: users.data![index].id,
                      ),
                    ),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }
}
