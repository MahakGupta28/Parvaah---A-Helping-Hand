import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:parvaah_helping_hand/firebase_options.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/login/login_screen.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/dashboard2.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/welcome/splash_screen.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/welcome/welcome_sc.dart';
import 'package:parvaah_helping_hand/src/utils/theme/theme.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    runApp(App(prefs: prefs));
  });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
}

class App extends StatelessWidget {
  final SharedPreferences prefs;
  const App({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: SplashScreen.routeName,
      getPages: [
        GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
        GetPage(
            name: WelcomeScreen.routeName, page: () => const WelcomeScreen()),
        GetPage(name: LoginScreen.routeName, page: () => const LoginScreen()),
        GetPage(
            name: DashboardScreen.routeName,
            page: () => const DashboardScreen()),
        GetPage(
            name: OrganizationDashboardScreen.routeName,
            page: () => const OrganizationDashboardScreen()),
      ],
    );
  }
}
