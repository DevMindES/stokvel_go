// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/init_packages.dart';
import 'package:stokvel_go/pages/landing.dart';
import 'package:stokvel_go/pages/onboarding/login.dart';
import 'package:stokvel_go/utils/error_handling.dart';
import 'package:stokvel_go/utils/utils.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final _auth = FirebaseAuth.instance;

  Rx<User?> _user = Rx<User?>(null);
  final RxString _name = "".obs;
  final RxString _surname = "".obs;
  final RxString _phoneNumber = "".obs;
  final RxString _email = "".obs;
  final RxString _profilePhoto = "".obs;

  String get uid => _user.value!.uid;
  String get name => _name.value;
  String get surname => _surname.value;
  String get phoneNumber => _phoneNumber.value;
  String get email => _email.value;
  String get profilePhoto => _profilePhoto.value;

  Future<void> logout() async {
    getCircularProgressIndicator();

    try {
      await _auth.signOut().then((_) {
        _name.value = "";
        _surname.value = "";
        _phoneNumber.value = "";
        _email.value = "";
      });
      Get.back();
    } on Exception catch (e) {
      Get.back();
      await showGetMessageDialog(tittle: "Error", message: e.toString());
    }

    Get.to(() => const Login());
  }

  Future<void> forgotPassword({required String email}) async {
    getCircularProgressIndicator();

    String? errorCode;
    String? errorMessage;

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.back();
      await showGetMessageDialog(
          tittle: 'Password reset info',
          message:
              'Password reset email sent. Please check your email address for further instructions.');
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
    } on SocketException catch (e) {
      // Handle network errors
      errorCode = 'Network error';
      errorMessage = 'Please check your internet connection and try again.';
    } on Exception catch (e) {
      // Handle other potential errors
      // logError(e); // Log the error for debugging
      errorCode = 'Unkown error';
      errorMessage = 'An unexpected error occurred. Please try again later.';
    }

    if (errorCode != null) {
      // an error occured
      Get.back();

      if (errorMessage == null) {
        // it's a firebase auth exception
        Map<String, String> errorInfo = getErrorMessageFromCode(errorCode);
        await showGetMessageDialog(
            tittle: errorInfo['errorCode']!,
            message: errorInfo['errorMessage']!);
      } else {
        // some other error
        await showGetMessageDialog(tittle: errorCode, message: errorMessage);
      }

      return;
    }
  }

  Future<void> login({required String email, required String password}) async {
    getCircularProgressIndicator();

    String? errorCode;
    String? errorMessage;

    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        _user = Rx<User?>(userCredential.user);
        if (_user.value == null) throw "No active user";
        _user.bindStream(_auth.userChanges());
      });

      print("current user: ${_auth.currentUser}");
      String? idToken = await _auth.currentUser!.getIdToken();
      print("id token: $idToken");

      // final getUserData = functions.httpsCallable("getUserData");
      // final result = await getUserData.call({"uid": _user.value!.uid});

      // final status = result.data["status"];

      // if (status == "Error") {
      //   Get.back();
      //   await showGetMessageDialog(
      //       tittle: status, message: result.data["message"]);

      //   return;
      // }

      // Map<dynamic, dynamic> userData = result.data["message"];
      // _name.value = userData["name"];
      // _surname.value = userData["surname"];
      // _phoneNumber.value = userData["phoneNumber"];
      // _email.value = userData["email"];
      // _profilePhoto.value = userData["profilePhoto"] ?? "";

      Get.back();
      Get.offAll(() => const Landing());
    } on FirebaseFunctionsException catch (e) {
      errorCode = e.code;
      errorMessage = e.message;
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
      errorMessage = e.message;
    } on PlatformException catch (e) {
      errorCode = e.code;
      errorMessage = e.message;
    } on SocketException catch (e) {
      // Handle network errors
      errorCode = 'Network error';
      errorMessage = 'Please check your internet connection and try again.';
    } on Exception catch (e) {
      errorCode = 'unkown';
      errorMessage = 'unkown!';
    }

    Get.back();
    if (errorCode != null) {
      Map<String, String> errorInfo = getErrorMessageFromCode(errorCode!);
      await showGetMessageDialog(
          tittle: errorInfo['errorCode']!, message: errorInfo['errorMessage']!);
    }
  }

  Future<void> signUp(
      {required String name,
      required String surname,
      required String idNumber,
      required String? phoneNumber,
      required String? email,
      required String? password}) async {
    getCircularProgressIndicator();

    try {
      final addToTempUsers = functions.httpsCallable("createUser");
      final result = await addToTempUsers.call(<String, dynamic>{
        "name": name,
        "surname": surname,
        "idNumber": idNumber,
        "phoneNumber": phoneNumber,
        "email": email,
        "password": password
      });

      Get.back();
      await showGetMessageDialog(tittle: "Success", message: result.data);
    } on FirebaseFunctionsException catch (e) {
      Get.back();
      await showGetMessageDialog(tittle: "Error", message: e.message!);
    }

    Get.offAll(() => const Login());
  }

  // String? _firestoreErrorMessage;

  // @override void onReady() {
  //   _initialScreen();
  //   super.onReady();
  // }

  // void _initialScreen()
  // {
  //   if (_auth.currentUser == null) {
  //     Get.offAll(() => const Login());
  //   } else {
  //     _initUser();
  //     setUserDetails();
  //     Get.offAll(() => const Landing());
  //   }
  // }

  // Future<void> validatePasswordReset({
  //   required String validationCode,
  //   required String password}) async
  // {
  //   getCircularProgressIndicator();

  //   String? errorCode;
  //   String? errorMessage;

  //   try {
  //     await _auth.confirmPasswordReset(
  //       code: validationCode,
  //       newPassword: password
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     errorCode = e.code;
  //   } on SocketException catch (e) { // Handle network errors
  //     errorCode = 'Network error';
  //     errorMessage = 'Please check your internet connection and try again.';
  //   } on Exception catch (e) { // Handle other potential errors
  //     // logError(e); // Log the error for debugging
  //     errorCode = 'Unkown error';
  //     errorMessage = 'An unexpected error occurred. Please try again later.';
  //   }

  //   if (errorCode != null)
  //   { // an error occured
  //     Get.back();

  //     if (errorMessage == null) { // it's a firebase auth exception
  //       Map<String, String> errorInfo = getErrorMessageFromCode(errorCode);
  //       await showGetMessageDialog(
  //         errorInfo['errorCode']!,
  //         errorInfo['errorMessage']!
  //       );
  //     } else { // some other error
  //       await showGetMessageDialog(
  //         errorCode,
  //         errorMessage
  //       );
  //     }

  //     return;
  //   }

  //   Get.back();
  //   await showGetMessageDialog(
  //     'Password reset info',
  //     'Password has been reset successfully.'
  //   );

  //   Get.offAll(() => const Login());
  // }
}
