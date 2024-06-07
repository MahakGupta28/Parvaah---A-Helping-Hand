import 'package:get/get.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/welcome/onbo_sc.dart';

class SplashScreenController
// extends GetxController
{
  // static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 3000));
    Get.to(() => const OnBoardingScreen());
  }
}
