import 'dart:developer';
import 'dart:io';

import 'package:chatapp/constants/widgets/my_text.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  FirebaseStorage storage = FirebaseStorage.instance;
  String? imgURL;
  var imageFile=File("").obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserCredential? userCredential;
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String pw = pwController.text.trim();
    if (email.isEmpty || pw.isEmpty) {
      print("Please fill all of them ");
    } else {
      print("success");
      signUp(email, pw);
    }
  }

  selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      log('Selected image: ${imageFile.value.toString()}');
    }
  }

  void showOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Upload Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  selectImage(ImageSource.gallery);
                  Navigator.pop(context); // Close dialog after selection
                },
                leading: const Icon(Iconsax.gallery_add_bold),
                title: const MyText('Gallery'),
              ),
              ListTile(
                onTap: () {
                  selectImage(ImageSource.camera);
                  Navigator.pop(context); // Close dialog after selection
                },
                leading: const Icon(Bootstrap.camera),
                title: const MyText('Camera'),
              )
            ],
          ),
        );
      },
    );
  }

  void signUp(String email, String password) async {
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential != null) {
        String uId = userCredential!.user!.uid;
      /*  UploadTask uploadTask = storage
            .ref('profilePictures')
            .child(uId)
            .putFile(imageFile.value!);
        TaskSnapshot snapshot = await uploadTask;
        imgURL = await snapshot.ref.getDownloadURL();
        print(imgURL.toString());
        log('Uploading image...');
        log('Image uploaded, URL: $imgURL');*/
        UserModel userModel = UserModel(
          emailId: emailController.text,
          fullName: nameController.text,
          profilePicture: imgURL,
          uId: uId,
        );
        await firestore.collection('users').doc(uId).set(userModel.toMap());
        log('User data uploaded to Firestore');
      }
    } catch (e) {
      log('Sign up failed: $e');
    }
  }
}
