import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:parvaah_helping_hand/src/constants/sizes.dart';
import 'package:parvaah_helping_hand/src/features/authentication/controllers/model_onbo.dart';

class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Image(
          fit: BoxFit.cover,
          image: AssetImage(model.image),
          height: size.height,
          width: size.width,
        ),
        Container(
          padding: const EdgeInsets.all(tDefaultSize),
          color: Colors.transparent,
          child: BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust blur intensity
            child: Container(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white
                      .withOpacity(0.3), // Adjust opacity and color as needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(model.image),
                    height: size.height * 0.60,
                  ),
                  Column(
                    children: [
                      Container(
                        color: isDarkMode
                            ? const Color.fromARGB(255, 91, 89, 89)
                            : const Color.fromARGB(255, 191, 187, 187)
                                .withOpacity(
                                    0.6), // Adjust opacity and color as needed
                        padding: const EdgeInsets.all(
                            4.0), // Adjust padding as needed
                        child: Text(
                          model.subTitle,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : tPrimaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    model.counterText,
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : tPrimaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 90.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
