import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parvaah_helping_hand/src/constants/image_string.dart';
import 'package:parvaah_helping_hand/src/constants/sizes.dart';
import 'package:parvaah_helping_hand/src/constants/text_string.dart';
import 'package:parvaah_helping_hand/src/features/authentication/controllers/splash_controller.dart';

import '../../../../constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashScreenController = Get.put(SplashScreenController());

  @override
  void initState() {
    super.initState();
    splashScreenController.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            // AnimatedPositioned(
            //   duration: const Duration(milliseconds: 2000),
            //   top: splashScreenController.animate.value ? 210 : 70,
            //   left: splashScreenController.animate.value ? 20 : -30,
            //   child: AnimatedOpacity(
            //     duration: const Duration(milliseconds: 2400),
            //     opacity: splashScreenController.animate.value ? 0.80 : 0,
            //     child: const Image(image: AssetImage(tSplashTopIcon)),
            //   ),
            // ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashScreenController.animate.value ? -50 : 0,
              left: splashScreenController.animate.value ? 0 : 0,
              bottom: splashScreenController.animate.value ? 0 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1600),
                opacity: splashScreenController.animate.value ? 0.45 : 0,
                child: const Image(image: AssetImage(tSplashImage)),
              ),
            ),
            // ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 3000),
              top: 290,
              left: splashScreenController.animate.value ? tDefaultSize : 0,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tAppName,
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Color.fromARGB(255, 50, 7, 76),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    tAppTagLine,
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        // fontFamily: '',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 3000),
              bottom: splashScreenController.animate.value ? 50 : 0,
              right: tDefaultSize,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2400),
                opacity: splashScreenController.animate.value ? 1 : 0,
                child: Container(
                  width: tSplashContainerSize,
                  height: tSplashContainerSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: tPrimaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
