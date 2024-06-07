import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:parvaah_helping_hand/src/constants/image_string.dart';
import 'package:parvaah_helping_hand/src/constants/text_string.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget(
      {Key? key,
      required String image,
      required String title,
      required String subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          alignment: Alignment.centerRight,
          image: const AssetImage(tWelcomeScreen),
          height: size.height * 0.375,
        ),
        Text(tLoginTitle,
            style: TextStyle(
                fontSize: 27.0,
                color: isDarkMode ? tThirdColor : tPrimaryColor,
                fontWeight: FontWeight.bold)),
        Text(tLoginSubTitle,
            style: TextStyle(
                fontSize: 15.0,
                color: isDarkMode ? Colors.amber : Colors.black,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
