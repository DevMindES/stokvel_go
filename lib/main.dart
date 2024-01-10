import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stokvel_go/firebase_options.dart';
import 'package:stokvel_go/pages/landing.dart';
import 'package:stokvel_go/pages/onboarding/login.dart';
import 'package:stokvel_go/providers/app_data.dart';
import 'package:stokvel_go/providers/auth_provider.dart';
import 'package:stokvel_go/utils/theme_data.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.appAttest,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AppData(
          screenHeight: screenHeight,
          screenWidth: screenWidth))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StokvelGO',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary_blue),
          useMaterial3: true,
        ),
        home: const Login(),
      ),
    );
  }
}
