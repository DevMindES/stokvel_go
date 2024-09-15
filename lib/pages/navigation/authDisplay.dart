import 'package:flutter/material.dart';
import 'package:stokvel_go/pages/navigation/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stokvel_go/pages/onboarding/login.dart';
import 'package:stokvel_go/pages/onboarding/signup.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if user is lgged in
          if (snapshot.hasData) {
            return HomePage();
          }

          // user is not logged in

          else {
            return Login();
          }
        },
      ),
    );
  }
}
