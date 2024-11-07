import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/widgets/my_text.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginControllers loginControllers = Get.put(LoginControllers());

    return Scaffold(
      body: Stack(
        children: [
          /// Base for the stack
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),

          /// Carousel
          const Carousel(),

          /// Inputs
          Positioned(
            bottom: 1,
            child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(240, 249, 255, 1),
                    borderRadius: BorderRadius.circular(20)),
                height: MediaQuery.of(context).size.height / 1.9,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20),
                      child: Text(
                        "Welcome Back:",
                        style: TextStyle(
                            fontSize: 44, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            controller: loginControllers.emailController,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color.fromRGBO(142, 135, 135, 1),
                                  size: 30,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                border: InputBorder.none,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                labelText: "Username or email",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          child: Obx(() => TextFormField(
                                obscureText: loginControllers.obscure.value,
                                controller:
                                    loginControllers.pwController,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                      color: Color.fromRGBO(142, 135, 135, 1),
                                      size: 30,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed:
                                            loginControllers.viewPassword,
                                        icon: Icon(
                                            loginControllers.obscure.value
                                                ? Icons.visibility_outlined
                                                : Icons
                                                    .visibility_off_outlined,
                                            size: 30,
                                            color: const Color.fromRGBO(
                                                142, 135, 135, 1))),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black12)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    border: InputBorder.none,
                                    labelText: "Password",
                                    labelStyle: const TextStyle(
                                        color: Colors.black, fontSize: 20)),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() {
                              return Checkbox(
                                  side: const BorderSide(color: Colors.black),
                                  shape: const CircleBorder(),
                                  tristate: true,
                                  value: loginControllers.isRememberMe.value,
                                  onChanged: (value) {
                                    loginControllers.rememberMe();
                                  });
                            }),
                            const Text(
                              "Remember me",
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(40, 92, 196, 1),
                            minimumSize: const Size(360, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        onPressed: () {
                          // Handle sign-in logic
                          loginControllers.checkValues();
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextButton(onPressed: (){
                      Navigator.pushNamed(context, '/sign-in');
                    }, child: MyText('Create a new account?'))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = [
      'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'https://th.bing.com/th/id/OIG2.9O4YqGf98tiYzjKDvg7L',
      'https://i0.wp.com/picjumbo.com/wp-content/uploads/amazing-stone-path-in-forest-free-image.jpg?w=600&quality=80',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height / 1.9,
        viewportFraction: 1,
        // Full-width image
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: imagePaths.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
