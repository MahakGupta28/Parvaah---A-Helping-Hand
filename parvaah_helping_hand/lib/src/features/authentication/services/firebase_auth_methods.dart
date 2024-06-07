import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/dashboard.dart';
import 'package:parvaah_helping_hand/src/features/authentication/services/showSnackBar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String confirmPassword,
    required String userType,
    required BuildContext context,
    required TextEditingController fullNameController,
    required TextEditingController phoneNoController,
    required Null Function() onSignUpSuccess,
  }) async {
    try {
      if (password != confirmPassword) {
        showSnackbar(context, 'Passwords do not match');
        return;
      }

      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = authResult.user!.uid;

      // Create a user document in Cloud Firestore with user details
      await usersCollection.doc(userId).set({
        'email': email,
        'userType': userType,
        'fullName': fullNameController.text, // Add full name to Firestore
        'phoneNo': phoneNoController.text, // Add phone number to Firestore
        // Add other user details as needed
      });

      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

  // Email Login
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
    required Null Function(dynamic userType) onLoginSuccess,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        showSnackbar(context, 'Email and password cannot be empty');
        return;
      }

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
// Get user data from Firestore to determine user type
      // Get user data from Firestore to determine user type
      DocumentSnapshot userSnapshot =
          await usersCollection.doc(_auth.currentUser!.uid).get();
      String userType = userSnapshot['userType'];

      onLoginSuccess(userType); // Call callback with user type
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

  // Email Verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      showSnackbar(context, 'Email Verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

//Google SignIn
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google sign-in process
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth?.accessToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo?.isNewUser == true) {
            // If the user is new, you can perform additional actions
            // For example, navigate to a profile setup screen
          }

          // Navigate to Dashboard after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    } catch (e) {
      showSnackbar(context, "An error occurred: $e");
    }
  }

  // // Phone sign in
  // Future<void> phoneSignIn(BuildContext context, String phoneNumber,
  //     {required Null Function(dynamic userType) onLoginSuccess}) async {
  //   TextEditingController codeController = TextEditingController();

  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await _auth.signInWithCredential(credential);
  //       // Navigate to Dashboard after successful phone sign-in
  //       // Get user data from Firestore to determine user type
  //       DocumentSnapshot userSnapshot =
  //           await usersCollection.doc(_auth.currentUser!.uid).get();
  //       String userType = userSnapshot['userType'];

  //       onLoginSuccess(userType); // Call callback with user type
  //     },
  //     verificationFailed: (e) {
  //       showSnackbar(context, e.message!);
  //     },
  //     codeSent: ((String verificationId, int? resendToken) async {
  //       showOTPDialog(
  //         codeController: codeController,
  //         context: context,
  //         onPressed: () async {
  //           PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //             verificationId: verificationId,
  //             smsCode: codeController.text.trim(),
  //           );

  //           await _auth.signInWithCredential(credential);
  //           // Navigate to Dashboard after successful phone sign-in
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const DashboardScreen(),
  //             ),
  //           );
  //         },
  //       );
  //     }),
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  // }

// Reset Password with Email
  Future<void> resetPasswordWithEmail(
      String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnackbar(context, 'Password reset email sent!');
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    } catch (e) {
      showSnackbar(context, 'An error occurred: $e');
    }
  }
}
