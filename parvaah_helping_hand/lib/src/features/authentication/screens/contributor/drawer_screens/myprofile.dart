import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/drawer_screens/editprofile.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late String _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _profilePictureUrl = '';
    _loadUserData();
  }

  Widget _buildProfilePicture() {
    if (_profilePictureUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 75,
        backgroundImage: NetworkImage(_profilePictureUrl),
      );
    } else {
      return const CircleAvatar(
        radius: 75,
        backgroundColor: Color.fromARGB(
            255, 223, 221, 221), // Set a background color for the avatar
        child: Icon(Icons.person, size: 50, color: tPrimaryColor),
      );
    }
  }

  Future<void> _loadUserData() async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      var userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userData['fullName'] ?? '';
        _phoneNumberController.text = userData['phoneNo'] ?? '';
        _emailController.text = _auth.currentUser!.email ?? '';
        _profilePictureUrl = userData['profilePicture'] ?? '';
      });
    }
  }

  Future<void> _updateUserData() async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(userId).set(
      {
        'fullName': _nameController.text,
        'phoneNo': _phoneNumberController.text,
      },
      SetOptions(merge: true),
    );

    // Display Snackbar when profile is updated
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated'),
        duration: Duration(seconds: 2), // You can customize the duration
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
          title: const Text('My Profile'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                // Navigate to the edit profile screen
                _navigateToEditProfile();
              },
            ),
          ],
        ),
        body: Container(
          color: isDarkMode
              ? tAccentColor
              : tDashboardBg, // Set the background color
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display profile picture (fetch from Firebase Storage)
                _buildProfilePicture(),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? tPrimaryColor : tBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Name',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            _nameController.text,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mobile',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            _phoneNumberController.text,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            _emailController.text,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Add more user details as needed

                // Update button
                ElevatedButton(
                  onPressed: () {
                    // Update user data when the button is pressed
                    _updateUserData();
                  },
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );

    if (result != null && result) {
      // Reload user data if changes were saved in EditProfileScreen
      _loadUserData();
    }
  }
}
