import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:parvaah_helping_hand/src/constants/sizes.dart';
import 'package:parvaah_helping_hand/src/constants/text_string.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/dashboard.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/forgot_password/forgot_pass_model.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/dashboard2.dart';
import 'package:parvaah_helping_hand/src/features/authentication/services/firebase_auth_methods.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController emailOrPhoneController =
      TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  String? emailOrPhoneError;
  String? passwordError;

  void loginUser() async {
    String emailOrPhone = emailOrPhoneController.text.trim();

    // Validate whether email or phone is provided
    if (emailOrPhone.isEmpty) {
      setState(() {
        emailOrPhoneError = "This field cannot be empty";
      });
      return;
    } else {
      emailOrPhoneError = null;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "This field cannot be empty";
      });
      return;
    } else {
      passwordError = null;
    }

    // Check if the input is in the form of an email
    if (emailOrPhone.contains('@')) {
      // Email and Password login
      FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
        email: emailOrPhone,
        password: passwordController.text,
        context: context,
        onLoginSuccess: (userType) {
          if (userType == 'Contributor') {
            // Navigate to Contributor Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardScreen(),
              ),
            );
          } else if (userType == 'Organization') {
            // Navigate to Organization Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const OrganizationDashboardScreen(),
              ),
            );
          }
        },
      );
    } else {
      // // Phone login
      // FirebaseAuthMethods(FirebaseAuth.instance)
      //     .phoneSignIn(context, emailOrPhone, onLoginSuccess: (userType) {
      //   if (userType == 'Contributor') {
      //     // Navigate to Contributor Dashboard
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const DashboardScreen(),
      //       ),
      //     );
      //   } else if (userType == 'Organization') {
      //     // Navigate to Organization Dashboard
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => OrganizationDashboardScreen(),
      //       ),
      //     );
      //   }
      // });
    }
  }

  void showResetPasswordBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const ResetPasswordPage());
                  },
                  child: const Text("Reset Password using Email"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailOrPhoneController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline_outlined),
                labelText: tEmail,
                hintText: tEmail,
                border: const OutlineInputBorder(),
                errorText: emailOrPhoneError,
              ),
            ),
            const SizedBox(height: tFormHeight - 30),
            TextFormField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: Transform.rotate(
                  angle: -135 * 3.14159265 / 180,
                  child: const Icon(
                    Icons.key,
                  ),
                ),
                labelText: tPassword,
                hintText: tPassword,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.remove_red_eye_outlined,
                  ),
                ),
                errorText: passwordError,
              ),
            ),
            const SizedBox(height: tFormHeight - 25),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: showResetPasswordBottomSheet,
                child: const Text(tForgotPassword),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            SizedBox(
              height: tFormHeight,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loginUser,
                child: const Text(tLogin),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
