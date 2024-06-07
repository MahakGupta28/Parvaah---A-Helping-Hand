import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/dashboard2.dart';

// ignore: camel_case_types
class addEvents extends StatefulWidget {
  const addEvents({super.key});

  @override
  State<addEvents> createState() => _addEventsState();
}

class _addEventsState extends State<addEvents> {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('Events');
  Uint8List? _imageBytes;

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
        // Get values from controllers
        final title = titleController.text;
        final date = dateController.text;
        final venue = venueController.text;
        final time = timeController.text;

        // Save all fields to Firestore
        final snapshot = await ref.doc(title).set({
          'title': title,
          'date': date,
          'venue': venue,
          'time': time,
        });

        // Upload image and update imageURL field
        final downloadURL = await _uploadImage(title);
        await ref.doc(title).update({'imageURL': downloadURL});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Select an Image'),
            backgroundColor: Colors.red,
          ),
        );
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
      // Format the picked date
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        dateController.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
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
        title: const Text("Upload an Event"),
        backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
        actions: [
          MaterialButton(
            onPressed: () async {
              await _uploadData();
              Navigator.pushReplacement(
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
              TextFormField(
                controller: venueController,
                decoration: const InputDecoration(
                  labelText: 'Venue',
                ),
              ),
              TextFormField(
                controller: timeController,
                onTap: () =>
                    _selectTime(context), // Call _selectTime when tapped
                decoration: const InputDecoration(
                  labelText: 'Time',
                  suffixIcon:
                      Icon(Icons.access_time), // Add an icon for visual cue
                ),
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
                child: const Text('Upload Image /GIF'),
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
