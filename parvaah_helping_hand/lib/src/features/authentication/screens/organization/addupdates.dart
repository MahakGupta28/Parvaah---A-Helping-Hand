import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/dashboard2.dart';

class Updates extends StatefulWidget {
  Updates({Key? key}) : super(key: key);

  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController causeDetailsController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('posts');
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  Uint8List? _imageBytes;

  Future<String> getCurrentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await usersRef.doc(user.uid).get();
      return userSnapshot.get('email');
    } else {
      throw 'User not logged in!';
    }
  }

  Future<void> _showImageSourceOptions(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      _pickImage(source);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageBytes = File(pickedFile.path).readAsBytesSync();
      });
    }
  }

  Future<void> _uploadData() async {
    try {
      if (_imageBytes != null) {
        // Explicitly set the document name to be the title entered by the user
        final title = titleController.text;
        final userEmail = await getCurrentUserEmail();
        final snapshot = await ref.doc(title).set({
          'title': title,
          'subtitle': subtitleController.text,
          'causeDetails': causeDetailsController.text,
          'totalAmount': double.parse(amountController.text),
          'date': dateController.text,
          'postedBy': userEmail,
        });
        final downloadURL = await _uploadImage(title);
        await ref.doc(title).update({'imageURL': downloadURL});
      } else {
        // Handle case when no image is selected
      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  Future<String> _uploadImage(String postId) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('images').child('$postId.png');
    await storageRef.putData(_imageBytes!);
    return storageRef.getDownloadURL();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // Set the first selectable date to the current date
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? tAccentColor : tDashboardBg,
      appBar: AppBar(
        title: const Text("Upload Cause"),
        backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
        actions: [
          MaterialButton(
            onPressed: () async {
              await _uploadData();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrganizationDashboardScreen(),
                ),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: causeDetailsController,
                decoration: const InputDecoration(
                  labelText: 'Cause Details',
                ),
                maxLines: null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'To Collect',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _showImageSourceOptions(context),
                child: const Text('Upload Image / GIF'),
              ),
              const SizedBox(height: 10),
              if (_imageBytes != null) ...[
                Image.memory(_imageBytes!),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
