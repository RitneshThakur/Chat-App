import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/view/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login_page.dart';

class LoadingScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData && snapshot.data != null) {
          User user = snapshot.data as User;
          return FutureBuilder(
            future: firestore.collection('users').doc(user.uid).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return  Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(child: CircularProgressIndicator()));
              } else if (userSnapshot.hasData) {
                UserModel userModel = UserModel.fromMap(
                    userSnapshot.data!.data() as Map<String, dynamic>);
                return HomeView(userModel: userModel, user: user);
              } else {
                return LoginPage();
              }
            },
          );
        } else {
          return LoginPage();
        }
      },
    );
  }

  Future<User?> checkLoginStatus() async {
    return auth.currentUser;
  }
}
