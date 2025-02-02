import 'package:chatapp/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'auth/login_page.dart';
import 'auth/sign_up_page.dart';


var uuid=Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
     home: SplashScreen(),
      routes: {
        '/sign-in':(context)=>SignInPage(),
        '/log-in':(context)=>LoginPage(),
      },
    );
  }
}
