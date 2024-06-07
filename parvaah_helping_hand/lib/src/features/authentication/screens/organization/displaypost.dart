import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';

class PostDetailsScreen extends StatelessWidget {
  final DocumentSnapshot post;

  const PostDetailsScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? tAccentColor : tDashboardBg,
      appBar: AppBar(
        backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
        title: Text(
          post['title'],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              post['imageURL'],
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
            Text(
              'Subtitle: ${post['subtitle']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Cause Details: ${post['causeDetails']}',
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 10),
            Text(
              'To Collect: ${post['totalAmount']}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${post['date']}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
