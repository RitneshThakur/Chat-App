import 'dart:developer';

import 'package:chatapp/constants/widgets/my_text.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/models/chat_room_model.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chatroom_controller.dart';

class ChatroomView extends StatelessWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoomModel;
  final User user;
  final UserModel userModel;

  const ChatroomView({
    super.key,
    required this.targetUser,
    required this.chatRoomModel,
    required this.user,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    final ChatroomController chatroomController = Get.put(
      ChatroomController(
        targetUser: targetUser,
        chatRoomModel: chatRoomModel,
        user: user,
        userModel: userModel,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(child: Icon(Icons.person)),
            SizedBox(width: 10),
            MyText("${targetUser.fullName}",color: Colors.white,),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              // Message display area
              Expanded(
                child: Obx(
                      () => ListView.builder(
                    reverse: true,
                    itemCount: chatroomController.messages.length,
                    itemBuilder: (context, index) {
                      MessageModel currentMessage = chatroomController.messages[index];
                      return Row(
                        mainAxisAlignment: currentMessage.sender == userModel.uId
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: currentMessage.sender == userModel.uId
                                  ? Colors.grey
                                  : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MyText(
                              '${currentMessage.text}',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Message input and send button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                color: Colors.white,
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: chatroomController.messageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter a message",
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: chatroomController.sendMessage,
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
