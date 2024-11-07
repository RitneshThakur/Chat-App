import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/view/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginControllers extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth=FirebaseAuth.instance;
  UserCredential? userCredential;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  RxBool obscure = true.obs;
  RxBool isRememberMe = false.obs;

  ///Password Toggle
  viewPassword() {
    obscure.value = !obscure.value;
  }
  void checkValues() {
    String email = emailController.text.trim();
    String pw = pwController.text.trim();
    if (email == "" || pw == "") {
      print("Please fill all of them bitch");
    } else {
      print("success");
      login(email, pw);
    }
  }
  login(String email, String password) async {
    try {
      userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential != null) {
        String uId = userCredential!.user!.uid;
        DocumentSnapshot documentSnapshot = await firestore.collection('users').doc(uId).get();
        UserModel userModel = UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);

        print("success");

        // Navigate using GetX
        Get.offAll(() => HomeView(userModel: userModel, user: userCredential!.user!));
      }
    } catch (e) {
      print(e.toString());
    }
  }
  ///checkBoc Toggle
  void rememberMe() {
    isRememberMe.value = !isRememberMe.value;
  }

  /// Implement login method here
}
