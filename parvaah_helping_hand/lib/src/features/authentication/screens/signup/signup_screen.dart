import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/constants/image_string.dart';
import 'package:parvaah_helping_hand/src/constants/sizes.dart';
import 'package:parvaah_helping_hand/src/constants/text_string.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/signup/form_header.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/signup/signup_footer.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/signup/signup_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String getBackgroundImage(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark
        ? tDarkModeBackground
        : tLightModeBackground;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getBackgroundImage(
                    context)), // Use dynamic background image
                fit: BoxFit.cover,
              ),
            ),
            child: const Column(
              children: [
                FormHeaderWidget(
                  image: tWelcomeScreen,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                  textAlign: TextAlign.center,
                ),
                SignUpFormWidget(),
                SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
