import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
          leading: const Icon(Icons.info),
          title: Text(
            'About',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : tPrimaryColor,
            ),
          ),
        ),
        backgroundColor: tDashboardBg,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              textAlign: TextAlign.start,
              '''
**Introduction:**

• Sponsorship, Donation, Charity Discovery, and Emergency Assistance
• Empowering users to make a positive impact on society by facilitating sponsorships, donations, and participation in charitable events.


**Instructions:**

• Explore the app to discover and connect with various charitable organizations and NGOs.
• Browse through the list of causes and simply click on the DONATE button next to the cause you want to support.
• Navigate to the sponsored individuals section to monitor the progress and well-being of the individuals you have sponsored.
• Stay updated on upcoming charitable events and manage your participation efficiently through the app.
• In times of crisis or disasters, utilize the emergency assistance feature to provide immediate help to those affected.
              ''',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white : tPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
