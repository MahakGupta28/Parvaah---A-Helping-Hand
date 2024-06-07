import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/drawer_screens/about.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/drawer_screens/myactivity.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/drawer_screens/myprofile.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/drawer_screens/mysponsorship.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/welcome/welcome_sc.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key});

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  late File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload image to Firebase Storage
      String userId = _auth.currentUser!.uid;
      Reference storageReference =
          _storage.ref().child('profile_pictures/$userId.jpg');
      UploadTask uploadTask = storageReference.putFile(_imageFile);

      // Use try-catch to handle errors
      try {
        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();

          // Save image URL to Firestore using set method
          await _firestore.collection('users').doc(userId).set(
              {
                'profilePicture': imageUrl,
              },
              SetOptions(
                  merge:
                      true)); // Use SetOptions(merge: true) to merge with existing data
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _removePhoto() async {
    String userId = _auth.currentUser!.uid;

    // Remove profile picture URL from Firestore
    await _firestore
        .collection('users')
        .doc(userId)
        .set({'profilePicture': FieldValue.delete()}, SetOptions(merge: true));

    // Remove the profile picture file from Firebase Storage
    Reference storageReference =
        _storage.ref().child('profile_pictures/$userId.jpg');
    try {
      await storageReference.delete();
    } catch (e) {
      print('Error deleting profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // Display an empty container while waiting for data
        }
        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(
                color: Colors.red), // Optionally style the error message
          );
        }
        var userData = snapshot.data!.data() as Map<String, dynamic>;

        return Drawer(
          child: Container(
            color: isDarkMode
                ? tAccentColor
                : const Color.fromARGB(255, 237, 235, 235),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: isDarkMode ? tPrimaryColor : tBgColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Show options to choose an image
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.camera,
                                          color: tPrimaryColor),
                                      title: const Text('Take a Photo'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.image,
                                        color: tPrimaryColor,
                                      ),
                                      title: const Text('Choose from Gallery'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.gallery);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.delete,
                                        color: tPrimaryColor,
                                      ), // Icon for remove option
                                      title: const Text('Remove Photo'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _removePhoto();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              // Display user profile picture
                              backgroundImage: NetworkImage(
                                userData['profilePicture'] ?? '',
                              ),
                              radius: 30,
                            ),
                            if (userData['profilePicture'] == null ||
                                userData['profilePicture']!.isEmpty)
                              const Positioned(
                                bottom: 10,
                                right: 11,
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                    size: 37,
                                    color: tPrimaryColor,
                                  ),
                                ),
                              ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: tPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Hi, ${userData['fullName'] ?? 'Full Name'}', // Fetch user's full name from database
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : tPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _auth.currentUser!.email ??
                            'Email', // Display user's email
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : tPrimaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('My Profile'),
                  onTap: () {
                    Get.to(() => const MyProfileScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('My Activity'),
                  onTap: () {
                    Get.to(() => MyActivityScreen(userId: _auth.currentUser!.uid));
                  },
                ),
                if (userData['userType'] ==
                    'Contributor') // Check if user's role is 'contributor'
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('My Sponsorships'),
                    onTap: () {
                      Get.to(() => SponsorshipDetailsPage());
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () {
                    Get.to(() => AboutScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('LogOut'),
                  onTap: () {
                    _onLogout();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onLogout() async {
    // Show confirmation dialog when log out button is pressed
    await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Get.offUntil(
                    GetPageRoute(page: () => const WelcomeScreen()),
                    ModalRoute.withName('/welcome'),
                  );
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
