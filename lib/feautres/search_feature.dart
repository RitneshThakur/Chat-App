import 'dart:developer';
import 'package:chatapp/constants/widgets/my_text.dart';
import 'package:chatapp/models/chat_room_model.dart';
import 'package:chatapp/view/chatroom_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../models/user_model.dart';

class SearchFeature extends StatelessWidget {
  final UserModel userModel;
  final User user;

  const SearchFeature({super.key, required this.userModel, required this.user});

  @override
  Widget build(BuildContext context) {
    final SearchController controller = Get.put(SearchController(
      userModel: userModel,
      user: user,
    ));

    return Scaffold(
      appBar: AppBar(
        title: MyText("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(labelText: "Enter email"),
              onChanged: (value) {
                if (value.trim().isNotEmpty) {
                  controller.searchUser();
                } else {
                  controller.clearSearch();
                }
              },
            ),
          ),
          CupertinoButton(
            child: MyText('Search'),
            onPressed: () {
              if (controller.searchController.text.trim().isNotEmpty) {
                controller.searchUser();
              } else {
                Get.snackbar("Error", "Please enter an email to search.");
              }
            },
          ),
          Obx(() {
            // Display search results reactively
            if (controller.searchResult.value == null) {
              return const Text("Nothing Found");
            } else {
              final searchUser = controller.searchResult.value!;
              return ListTile(
                onTap: () async {
                  ChatRoomModel? chatroom = await controller.getChatRoom(searchUser);
                  if (chatroom != null) {
                    Get.to(() => ChatroomView(
                      targetUser: searchUser,
                      chatRoomModel: chatroom,
                      user: user,
                      userModel: userModel,
                    ));
                  } else {
                    Get.snackbar("Error", "Could not create or fetch chat room.");
                  }
                },
                trailing: Icon(Icons.arrow_forward_ios),
                leading: Icon(CupertinoIcons.person),
                title: MyText("${searchUser.fullName}"),
                subtitle: MyText('${searchUser.emailId}'),
              );
            }
          }),
        ],
      ),
    );
  }
}

class SearchController extends GetxController {
  final UserModel userModel;
  final User user;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();
  Rx<UserModel?> searchResult = Rx<UserModel?>(null);

  SearchController({required this.userModel, required this.user});

  // Search for a user by email
  void searchUser() {
    final email = searchController.text.trim();
    if (email.isNotEmpty && email != user.email) {
      firestore
          .collection('users')
          .where("emailId", isEqualTo: email)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          searchResult.value =
              UserModel.fromMap(snapshot.docs[0].data() as Map<String, dynamic>);
        } else {
          searchResult.value = null;
        }
      });
    } else {
      searchResult.value = null;
    }
  }

  void clearSearch() {
    searchResult.value = null;
  }

  // Get or create a chat room
  Future<ChatRoomModel?> getChatRoom(UserModel targetUser) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('chatroom')
          .where('participants.${userModel.uId}', isEqualTo: true)
          .where('participants.${targetUser.uId}', isEqualTo: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs[0].data();
        return ChatRoomModel.fromMap(data as Map<String, dynamic>);
      } else {
        ChatRoomModel newChatRoom = ChatRoomModel(
          chatRoomId: uuid.v1(),
          lastMessage: "",
          participants: {
            userModel.uId.toString(): true,
            targetUser.uId.toString(): true,
          },
        );
        await firestore
            .collection('chatroom')
            .doc(newChatRoom.chatRoomId)
            .set(newChatRoom.toMap());
        return newChatRoom;
      }
    } catch (e) {
      log('Error fetching/creating chat room: $e');
      return null;
    }
  }
}
