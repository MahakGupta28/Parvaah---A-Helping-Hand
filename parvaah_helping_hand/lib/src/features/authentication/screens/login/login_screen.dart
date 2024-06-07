import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/constants/image_string.dart';
import 'package:parvaah_helping_hand/src/constants/sizes.dart';
import 'package:parvaah_helping_hand/src/constants/text_string.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/login/login_footer.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/login/login_form.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/signup/form_header.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

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
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                getBackgroundImage(context),
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormHeaderWidget(
                      image: tWelcomeScreen,
                      title: tLoginTitle,
                      subTitle: tLoginSubTitle,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      heightBetween: 30.0,
                      textAlign: TextAlign.center,
                    ),
                    LoginForm(),
                    LoginFooterWidget(),
                    SizedBox(
                        height: tDefaultSize), // add space for bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
