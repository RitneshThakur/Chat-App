import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../constants/widgets/custom_form.dart';
import '../constants/widgets/my_text.dart';
import '../controllers/sign_up_controller.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignUpController signInController = Get.put(SignUpController());

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        /*image: DecorationImage(
            image: NetworkImage('https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg'),
            fit: BoxFit.cover,
            colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
          ),*/
      ),
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Form(
          key: signInController.formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  "Please Enter Few Details To Get Started",
                  color: Colors.grey[100],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 20),
                Obx(() {
                  return CircleAvatar(
                    // backgroundColor: Colors.blue,
                    backgroundImage: signInController.imageFile.value != null
                        ? FileImage(signInController.imageFile.value!)
                        : NetworkImage(
                        'https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg'),
                    radius: 100,
                    child:signInController.imageFile.value==null ? IconButton(
                      onPressed: () {
                        signInController.showOptions(context);
                      },
                      icon: Icon(
                        Bootstrap.person,
                        size: 100,
                      ),
                    ):null,
                  );
                }),
                SizedBox(height: 20),
                CustomForm(
                  text: 'Please enter your full name',
                  color: Colors.white,
                  controller: signInController.nameController,
                  icon: Icon(Bootstrap.person),
                  validator: (fullName) {
                    if (fullName == null || fullName
                        .trim()
                        .isEmpty) {
                      return "Please enter your full name";
                    }
                    return null;
                  },
                ),
                CustomForm(
                  icon: Icon(FontAwesome.location_arrow_solid),
                  text: "Enter email address",
                  controller: signInController.emailController,
                  color: Colors.white,
                  validator: (email) {
                    if (email == null || email
                        .trim()
                        .isEmpty) {
                      return "Please enter your email address";
                    }
                    return null;
                  },
                ),
                CustomForm(
                  icon: Icon(Icons.password_sharp),
                  text: "Enter your password",
                  txt: true,
                  controller: signInController.pwController,
                  color: Colors.white,
                  validator: (password) {
                    if (password == null || password
                        .trim()
                        .isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        signInController.checkValues();
                      },
                      child: Text("Sign Up"),
                    ),
                    SizedBox(width: 20),
                    MyText(
                      "Already a member?",
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/log-in');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
