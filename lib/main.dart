import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/controllers/app_controller.dart';
import 'package:stokvel_go/controllers/auth_controller.dart';
import 'package:stokvel_go/firebase_options.dart';
import 'package:stokvel_go/pages/landing.dart';
import 'package:stokvel_go/pages/navigation/investment_centre.dart';
import 'package:stokvel_go/pages/navigation/lend_centre.dart';
import 'package:stokvel_go/pages/navigation/notifications.dart';
import 'package:stokvel_go/pages/navigation/portfolio.dart';
import 'package:stokvel_go/pages/onboarding/login.dart';
import 'package:stokvel_go/pages/onboarding/profile.dart';
import 'package:stokvel_go/pages/onboarding/reset_password.dart';
import 'package:stokvel_go/pages/onboarding/signup.dart';
import 'package:stokvel_go/splash_screen.dart';
import 'package:stokvel_go/utils/theme_data.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  .then((firebaseApp) {
    Get.put(AuthController());
    Get.put(AppController());
  });

  await FirebaseAppCheck.instance.activate(
    // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.appAttest,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  MyApp({super.key});

  final _appController = AppController.instance;

  @override
  Widget build(BuildContext context)
  {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    _appController.setWidgetWidth(screenHeight: screenHeight, screenWidth: screenWidth);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary_blue),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/login', page: () => const Login()),
        GetPage(name: '/signup', page: () => const SignUp()),
        GetPage(name: '/reset_password', page: () => const ResetPassword()),
        GetPage(name: '/profile', page: () => const Profile()),
        GetPage(name: '/landing', page: () => const Landing()),
        GetPage(name: '/portfolio', page: () => const Portfolio()),
        GetPage(name: '/investments', page: () => const InvestmentCentre()),
        GetPage(name: '/lending', page: () => const LendCentre()),
        GetPage(name: '/notifications', page: () => const Notifications()),
      ],
    );

    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (context) => AuthProvider()),
    //     ChangeNotifierProvider(create: (context) => AppData(
    //       screenHeight: screenHeight,
    //       screenWidth: screenWidth))
    //   ],
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     title: 'StokvelGO',
    //     theme: ThemeData(
    //       colorScheme: ColorScheme.fromSeed(seedColor: primary_blue),
    //       useMaterial3: true,
    //     ),
    //     home: const Login(),
    //   ),
    // );
  }
}
