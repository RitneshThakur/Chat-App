import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/widgets/my_text.dart';
import '../controllers/home_controller.dart';
import '../feautres/search_feature.dart';
import '../models/chat_room_model.dart';
import '../models/user_model.dart';
import 'chatroom_view.dart';

class HomeView extends StatelessWidget {
  final UserModel userModel;
  final User user;

  HomeView({required this.userModel, required this.user});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController(userModel: userModel, user: user));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: MyText('Available Peoples',color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Get.to(() => SearchFeature(userModel: userModel, user: user));
        },
        icon: Icon(Icons.search),
      ),
      body: SafeArea(
        child: Obx(() {
          if (homeController.chatRooms.isEmpty) {
            return Center(child: Text("No Chats"));
          }

          return ListView.builder(
            itemCount: homeController.chatRooms.length,
            itemBuilder: (context, index) {
              ChatRoomModel chatRoom = homeController.chatRooms[index];
              Map<String, dynamic> participants = chatRoom.participants!;
              List<String> participantIds = participants.keys.toList();
              participantIds.remove(userModel.uId);

              return FutureBuilder<UserModel?>(
                future: homeController.getOtherParticipant(participantIds[0]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    UserModel otherUser = snapshot.data!;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),

                      ),
                      child: ListTile(
                        onTap: () {
                          Get.to(() => ChatroomView(
                            targetUser: otherUser,
                            chatRoomModel: chatRoom,
                            user: user,
                            userModel: userModel,
                          ));
                        },
                        title: MyText(
                          otherUser.fullName ?? "No Name",
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                        subtitle: MyText(
                          chatRoom.lastMessage ?? "Say Hi to your new friend",
                          color: Colors.blueGrey,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            otherUser.fullName?[0] ?? "",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blue[800],
                        ),
                      ),
                    );
                  } else {
                    return Text("User not found");
                  }
                },
              );
            },
          );
        }),
      ),
    );
  }
}
