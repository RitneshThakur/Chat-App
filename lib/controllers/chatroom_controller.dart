import 'dart:developer';
import 'package:chatapp/models/chat_room_model.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class ChatroomController extends GetxController {
  final UserModel targetUser;
  final ChatRoomModel chatRoomModel;
  final User user;
  final UserModel userModel;
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ChatroomController({
    required this.targetUser,
    required this.chatRoomModel,
    required this.user,
    required this.userModel,
  });

  RxList<MessageModel> messages = RxList<MessageModel>();

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  // Method to send a message
  void sendMessage() async {
    String message = messageController.text.trim();
    messageController.clear();
    if (message.isNotEmpty) {
      MessageModel newMessageModel = MessageModel(
        messageId: uuid.v1(),
        sender: userModel.uId,
        createdOn: DateTime.now(),
        seen: false,
        text: message,
      );

      firestore
          .collection('chatroom')
          .doc(chatRoomModel.chatRoomId)
          .collection('messages')
          .doc(newMessageModel.messageId)
          .set(newMessageModel.toMap());

      chatRoomModel.lastMessage = message;
      firestore
          .collection('chatroom')
          .doc(chatRoomModel.chatRoomId)
          .set(chatRoomModel.toMap());

      log('Message sent');
    }
  }

  // Fetches messages for the chat room and updates the list reactively
  void fetchMessages() {
    firestore
        .collection('chatroom')
        .doc(chatRoomModel.chatRoomId)
        .collection('messages')
        .orderBy("createdOn", descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.clear();
      for (var doc in snapshot.docs) {
        messages.add(MessageModel.fromMap(doc.data() as Map<String, dynamic>));
      }
    });
  }
}
