import 'package:chatapp/feautres/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        backgroundColor: Colors.black,
        splash: SizedBox(
          width: MediaQuery.of(context).size.width ,
          height: MediaQuery.of(context).size.height *0.5 ,
          child: Image.asset('asset/splash.gif',fit: BoxFit.cover,),
        ),
        nextScreen: LoadingScreen(),
        centered: true,

        animationDuration: Duration(seconds: 8),
      ),
    );
  }
}
