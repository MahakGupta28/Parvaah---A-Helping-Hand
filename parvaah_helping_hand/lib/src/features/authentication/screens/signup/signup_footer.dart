import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:parvaah_helping_hand/src/constants/image_string.dart';
import 'package:parvaah_helping_hand/src/constants/sizes.dart';
import 'package:parvaah_helping_hand/src/constants/text_string.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/login/login_screen.dart';
import 'package:parvaah_helping_hand/src/features/authentication/services/firebase_auth_methods.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(height: tFormHeight - 30),
        SizedBox(
          width: double.maxFinite,
          child: OutlinedButton.icon(
            icon: const Image(image: AssetImage(tGoogleLogo), width: 20.0),
            onPressed: () {
              FirebaseAuthMethods(FirebaseAuth.instance)
                  .signInWithGoogle(context);
            },
            label: const Text(tSignInWithGoogle),
          ),
        ),
        const SizedBox(height: tFormHeight - 40),
        TextButton(
          onPressed: () => Get.to(() => const LoginScreen()),
          child: Text.rich(
            TextSpan(
                text: tAlreadyHaveAnAccount,
                style: Theme.of(context).textTheme.bodyMedium,
                children: const [
                  TextSpan(text: tLogin, style: TextStyle(color: Colors.blue))
                ]),
          ),
        ),
      ],
    );
  }
}
