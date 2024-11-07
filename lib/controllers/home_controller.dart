import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/chat_room_model.dart';
import '../models/user_model.dart';

class HomeController extends GetxController {
  final UserModel userModel;
  final User user;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  HomeController({required this.userModel, required this.user});

  // Observable list of chat rooms
  RxList<ChatRoomModel> chatRooms = RxList<ChatRoomModel>();

  @override
  void onInit() {
    super.onInit();
    fetchChatRooms();
  }

  // Method to fetch chat rooms for the user
  void fetchChatRooms() {
    firestore
        .collection('chatroom')
        .where("participants.${user.uid}", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      chatRooms.clear();
      for (var doc in snapshot.docs) {
        chatRooms.add(ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>));
      }
    });
  }

  // Method to get other participant's UserModel
  Future<UserModel?> getOtherParticipant(String otherUserId) async {
    DocumentSnapshot userDoc = await firestore.collection('users').doc(otherUserId).get();
    if (userDoc.exists) {
      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
