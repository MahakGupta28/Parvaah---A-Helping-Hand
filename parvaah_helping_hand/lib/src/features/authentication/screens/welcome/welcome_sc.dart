import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:parvaah_helping_hand/src/constants/image_string.dart';
import 'package:parvaah_helping_hand/src/constants/sizes.dart';
import 'package:parvaah_helping_hand/src/constants/text_string.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/login/login_screen.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/signup/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String routeName = '/welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoginSelected = true;

  String getBackgroundImage() {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark
        ? tDarkModeBackground
        : tLightModeBackground;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  getBackgroundImage(),
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.2),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(tSize),
                  child: Column(
                    children: [
                      Image(
                        fit: BoxFit.none,
                        alignment: Alignment.center,
                        image: const AssetImage(tWelcomeScreen),
                        height: height * 0.6,
                      ),
                      const SizedBox(height: 5.0),
                      Column(
                        children: [
                          Text(
                            tWelcomeTitle,
                            style: TextStyle(
                              fontSize: 28.0,
                              color: isDarkMode
                                  ? tSecondaryColor
                                  : const Color.fromARGB(255, 37, 4, 57),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 0.0),
                          Text(
                            tWelcomeSubtitle,
                            style: TextStyle(
                              fontSize: 17.0,
                              color: isDarkMode
                                  ? tSecondaryColor
                                  : const Color.fromARGB(255, 17, 4, 24),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: isLoginSelected
                                ? ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isLoginSelected = true;
                                      });
                                      Get.to(() => const LoginScreen());
                                    },
                                    child: Text(tLogin.toUpperCase()),
                                  )
                                : OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isLoginSelected = true;
                                      });
                                      Get.to(() => const LoginScreen());
                                    },
                                    child: Text(tLogin.toUpperCase()),
                                  ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: isLoginSelected
                                ? OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isLoginSelected = false;
                                      });
                                      Get.to(() => const SignUpScreen());
                                    },
                                    child: Text(tSignup.toUpperCase()),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isLoginSelected = false;
                                      });
                                      Get.to(() => const SignUpScreen());
                                    },
                                    child: Text(tSignup.toUpperCase()),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
