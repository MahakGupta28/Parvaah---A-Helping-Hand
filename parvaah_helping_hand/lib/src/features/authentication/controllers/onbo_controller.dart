import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:parvaah_helping_hand/src/constants/image_string.dart';
import 'package:parvaah_helping_hand/src/constants/text_string.dart';
import 'package:parvaah_helping_hand/src/features/authentication/controllers/model_onbo.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/welcome/onbo_pg_widget.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/welcome/welcome_sc.dart';

class OnBoardingController extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage1,
        title: tOnboardingTitle1,
        subTitle: tOnboardingSubTitle1,
        counterText: tOnboardingCounter1,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage3,
        title: tOnboardingTitle2,
        subTitle: tOnboardingSubTitle2,
        counterText: tOnboardingCounter2,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage2,
        title: tOnboardingTitle3,
        subTitle: tOnboardingSubTitle3,
        counterText: tOnboardingCounter3,
      ),
    ),
  ];

  void skip() => Get.to(() => const WelcomeScreen());

  void animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    if (nextPage == 3) {
      Get.to(() => const WelcomeScreen());
    } else {
      controller.animateToPage(page: nextPage);
    }
  }

  onPageChangedCallback(int activePageIndex) =>
      currentPage.value = activePageIndex;
}
