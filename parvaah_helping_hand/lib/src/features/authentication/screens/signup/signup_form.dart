import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/constants/sizes.dart';
import 'package:parvaah_helping_hand/src/constants/text_string.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/dashboard.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/dashboard2.dart';
import 'package:parvaah_helping_hand/src/features/authentication/services/firebase_auth_methods.dart';

class SignUpFormWidget extends StatefulWidget {
  static String routeName = '/signup-email-password';

  const SignUpFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  String? passwordError;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneNoController.dispose();
  }

  void signUpUser() async {
    FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      userType: selectedUserType,
      context: context,
      fullNameController: fullNameController,
      phoneNoController: phoneNoController,
      onSignUpSuccess: () {
        if (selectedUserType == 'Contributor') {
          // Navigate to Contributor Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        } else if (selectedUserType == 'Organization') {
          // Navigate to Organization Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrganizationDashboardScreen(),
            ),
          );
        }
      },
    );
  }

  List<String> userTypes = [
    '-Select-',
    'Contributor',
    'Organization',
  ];

  String selectedUserType = '-Select-';

  @override
  Widget build(BuildContext context) {
    phoneNoController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneNoController.text.length,
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 30),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: tFullName,
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: tFormHeight - 40),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: tEmail,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email cannot be empty';
                }
                if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]")
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: tFormHeight - 40),
            TextFormField(
              controller: phoneNoController,
              onChanged: (value) {
                setState(() {
                  phoneNoController.text = value;
                });
              },
              decoration: InputDecoration(
                labelText: tPhoneNo,
                prefixIcon: Container(
                  padding: const EdgeInsets.all(14.0),
                  child: InkWell(
                    onTap: () {
                      showCountryPicker(
                          context: context,
                          countryListTheme: const CountryListThemeData(
                              bottomSheetHeight: 500),
                          onSelect: (value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          });
                    },
                    child: Text(
                      "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                suffixIcon: phoneNoController.text.length > 9
                    ? Container(
                        height: 5,
                        width: 5,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                        child: const Icon(Icons.done,
                            color: Colors.white, size: 20),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: tFormHeight - 40),
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
              validator: (value) {
                RegExp regex = RegExp(r'^.{6,}$');
                if (value!.isEmpty) {
                  return 'Password cannot be empty';
                }
                if (!regex.hasMatch(value)) {
                  return 'Please enter a valid password (min. 6 characters)';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 40),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: Transform.rotate(
                  angle: -135 * 3.14159265 / 180,
                  child: const Icon(
                    Icons.key,
                  ),
                ),
                labelText: 'Confirm Password',
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
            const SizedBox(height: tFormHeight - 40),
            DropdownButtonFormField(
              value: selectedUserType,
              items: userTypes.map((String userType) {
                return DropdownMenuItem(
                  value: userType,
                  child: Text(userType),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedUserType = value;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'User Type',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: tFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signUpUser,
                child: const Text(tSignup),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
