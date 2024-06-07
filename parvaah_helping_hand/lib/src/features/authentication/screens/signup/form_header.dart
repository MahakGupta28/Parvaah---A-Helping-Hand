import 'package:flutter/material.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget(
      {Key? key,
      this.imageColor,
      this.heightBetween,
      required this.image,
      required this.title,
      required this.subTitle,
      this.imageHeight = 0.2,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.textAlign})
      : super(key: key);

  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final String image, title, subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

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
          alignment: Alignment.center,
          fit: BoxFit.fitWidth,
          image: AssetImage(image),
          width: size.width * 3,
          height: size.height * 0.28,
          colorBlendMode: BlendMode.darken,
        ),
        Text(title,
            style: TextStyle(
                fontSize: 27.0,
                color: isDarkMode ? tThirdColor : tPrimaryColor,
                fontWeight: FontWeight.bold)),
        Text(subTitle,
            style: TextStyle(
                fontSize: 16.0,
                color: isDarkMode ? Colors.yellow : Colors.black,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
