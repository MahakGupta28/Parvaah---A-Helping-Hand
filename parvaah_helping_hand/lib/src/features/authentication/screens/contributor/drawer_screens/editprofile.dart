import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late File _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _imageFile = File('');
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      var userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userData['fullName'] ?? '';
        _phoneNumberController.text = userData['phoneNo'] ?? '';

        // Load and display the previous profile picture
        _loadProfilePicture(userData['profilePicture']);
      });
    }
  }

  // Load and display the previous profile picture
  void _loadProfilePicture(String? profilePictureUrl) {
    if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
      setState(() {
        _imageFile = File(''); // Reset _imageFile to clear previous selection
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
      ),
      body: Container(
        height: mediaQuery.size.height,
        color: isDarkMode ? tAccentColor : tDashboardBg,
        child: SingleChildScrollView(
          child: Container(
            color: isDarkMode
                ? tAccentColor
                : tDashboardBg, // Set the background color
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
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
                                    }),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundImage: _imageFile.existsSync()
                              ? FileImage(_imageFile)
                              : null,
                          backgroundColor:
                              const Color.fromARGB(255, 223, 221, 221),
                          child: _imageFile.existsSync()
                              ? null
                              : const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: tPrimaryColor,
                                ),
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                  const SizedBox(height: 16),
                  // Add more form fields for other user details as needed

                  // Save button
                  ElevatedButton(
                    onPressed: () {
                      // Save updated user data to the database
                      _saveUserData();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // If a new profile picture is selected, upload it to Firebase Storage
    if (_imageFile.existsSync()) {
      Reference storageReference =
          _storage.ref().child('profile_pictures/$userId.jpg');
      try {
        await storageReference.putFile(_imageFile);
        String downloadUrl = await storageReference.getDownloadURL();

        // Update the profile picture URL in Firestore
        await _firestore
            .collection('users')
            .doc(userId)
            .set({'profilePicture': downloadUrl}, SetOptions(merge: true));
      } catch (e) {
        print('Error uploading profile picture: $e');
      }
    }

    // Update other user data in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).set(
      {
        'fullName': _nameController.text,
        'phoneNo': _phoneNumberController.text,
      },
      SetOptions(merge: true),
    );

    // Send the updated data back to the previous screen
    Navigator.pop(context, true);
  }
}
