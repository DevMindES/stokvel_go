// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/pages/landing.dart';
import 'package:stokvel_go/pages/onboarding/login.dart';
import 'package:stokvel_go/pages/onboarding/reset_password.dart';
import 'package:stokvel_go/utils/error_handling.dart';
import 'package:stokvel_go/utils/utils.dart';

class AuthController extends GetxController
{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  static AuthController instance = Get.find();
  Rx<User?> _user = Rx<User?>(null);
  Rx<Stream<DocumentSnapshot<Map<String,dynamic>>>?> _userDetails = Rx<Stream<DocumentSnapshot<Map<String, dynamic>>>?>(null);
  Rx<Stream<QuerySnapshot<Map<String,dynamic>>>?> homeStream = Rx<Stream<QuerySnapshot<Map<String,dynamic>>>?>(null);
  String? _firestoreErrorMessage;
  String _userName = '';
  String _userSurname = '';
  String _userGender = '';
  String _userPhoneNumber = '';
  Rx<String> profilePhoto = ''.obs;

  @override void onReady() {
    _initialScreen();
    super.onReady();
  }

  void _initialScreen()
  {
    if (_auth.currentUser == null) {
      Get.offAll(() => const Login());
    } else {
      _initUser();
      setUserDetails();
      Get.offAll(() => const Landing());
    }
  }

  void _initUser()
  {
    _user = Rx<User?>(_auth.currentUser);
    _user.bindStream(_auth.userChanges());
    
    _userDetails = Rx<Stream<DocumentSnapshot<Map<String, dynamic>>>?>(
      _firestore.collection('users')
      .doc(_auth.currentUser!.uid)
      .snapshots()
    );
  }

  void setUserDetails()
  {
    if (_userDetails.value != null) {
      _userDetails.value?.first.then((documentSnapshot) {
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data()!;
          _userName = data['name'];
          _userSurname = data['surname'];
          _userGender = data['gender'];
          _userPhoneNumber = data['cell_number'];
          profilePhoto.value = data['profile_photo'];
        }
      });
    }
  }

  Future<void> logout() async
  {
    getCircularProgressIndicator();

    try {
      await _auth.signOut();
      Get.back();
      _initialScreen();
    } on Exception catch (e) {
      Get.back();
      showGetMessageDialog(
        'Error',
        e.toString()
      );
    }
  }


  Future<void> forgotPassword({required String email}) async
  {
    getCircularProgressIndicator();

    String? errorCode;
    String? errorMessage;
    bool sent = true;

    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Check for user-not-found error after sending the email
      if (_auth.currentUser == null) {
        errorCode = 'auth/user-not-found';
      }
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
    } on SocketException catch (e) { // Handle network errors
      errorCode = 'Network error';
      errorMessage = 'Please check your internet connection and try again.';
    } on Exception catch (e) { // Handle other potential errors
      // logError(e); // Log the error for debugging
      errorCode = 'Unkown error';
      errorMessage = 'An unexpected error occurred. Please try again later.';
    }

    if (errorCode != null)
    { // an error occured
      Get.back();

      if (errorMessage == null) { // it's a firebase auth exception
        Map<String, String> errorInfo = getErrorMessageFromCode(errorCode);
        await showGetMessageDialog(
          errorInfo['errorCode']!,
          errorInfo['errorMessage']!
        );
      } else { // some other error
        await showGetMessageDialog(
          errorCode,
          errorMessage
        );
      }
      
      return;
    }

    Get.back();
    await showGetMessageDialog(
      'Password reset info',
      'Password reset email sent.'
    );

    Get.to(() => const ResetPassword());
  }

  
  Future<void> validatePasswordReset({
    required String validationCode,
    required String password}) async
  {
    getCircularProgressIndicator();

    String? errorCode;
    String? errorMessage;

    try {
      await _auth.confirmPasswordReset(
        code: validationCode,
        newPassword: password
      );
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
    } on SocketException catch (e) { // Handle network errors
      errorCode = 'Network error';
      errorMessage = 'Please check your internet connection and try again.';
    } on Exception catch (e) { // Handle other potential errors
      // logError(e); // Log the error for debugging
      errorCode = 'Unkown error';
      errorMessage = 'An unexpected error occurred. Please try again later.';
    }

    if (errorCode != null)
    { // an error occured
      Get.back();

      if (errorMessage == null) { // it's a firebase auth exception
        Map<String, String> errorInfo = getErrorMessageFromCode(errorCode);
        await showGetMessageDialog(
          errorInfo['errorCode']!,
          errorInfo['errorMessage']!
        );
      } else { // some other error
        await showGetMessageDialog(
          errorCode,
          errorMessage
        );
      }
      
      return;
    }

    Get.back();
    await showGetMessageDialog(
      'Password reset info',
      'Password has been reset successfully.'
    );

    Get.offAll(() => const Login());
  }


  Future<void> login({
    required String email,
    required String password}) async
  {
    getCircularProgressIndicator();

    String? errorCode;
    String? errorMessage;

    int isEmail = isEmailOrPhone(emailOrPhone: email);

    if (isEmail != 1) {
      Get.back();
      await showGetMessageDialog(
        'Info',
        'Please use your email.'
      );

      return;
    }

    // if (isEmail == 0 && !email.startsWith('+268')) email = '+268$email';

    try {
      UserCredential? userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
    }
    on FirebaseAuthException catch (e) {
      errorCode = e.code;
    }
    on PlatformException catch (e) {
      errorCode = e.code;
      errorMessage = e.message;
    }
    on SocketException catch (e) { // Handle network errors
      errorCode = 'Network error';
      errorMessage = 'Please check your internet connection and try again.';
    }
    on Exception catch (e) {
      errorCode = 'unkown';
      errorMessage = 'unkown!';
    }
    catch (e) { // Handle other potential errors
      errorCode = 'well';
      errorMessage = 'sharks';
    }

    if (errorCode != null)
    { // an error occured
      Get.back();

      if (errorMessage == null) { // it's a firebase auth exception
        Map<String, String> errorInfo = getErrorMessageFromCode(errorCode!);
        await showGetMessageDialog(
          errorInfo['errorCode']!,
          errorInfo['errorMessage']!
        );
      } else { // some other error
        await showGetMessageDialog(
          errorCode,
          errorMessage
        );
      }
      
      return;
    }

    _initUser();
    setUserDetails();
    Get.back();
    Get.offAll(() => const Landing());
  }


  Future<void> signUp({
    required String name,
    required String surname,
    required String idNumber,
    required String? phoneNumber,
    required String? email}) async
  {
    // showCircularProgressIndicator(context: context);
    getCircularProgressIndicator();

    try { // check if this email or phone number is already existing
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkExistingUser');

      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'email': phoneNumber == null ? email : null,
        'phoneNumber': email == null ? phoneNumber : null,
      });

      String method = phoneNumber == null ? 'email' : 'phone number';

      if (result.data['status'] == 'warning') {
        Get.back();
        await showGetMessageDialog(
          'Info',
          'This $method is already assocciated with an existing account.'
        );

        return;
      }
    } on Exception catch (e) {
      // There was an unknown error
      Get.back();
      await showGetMessageDialog(
        'Error',
        e.toString()
        // 'An unkown error occured. Please try again later.'
      );

      return;
    }

    try { // add user details to temp_users
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('addToTempUsers');
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'displayName': '$name $surname',
        'idNumber': idNumber,
        'email': phoneNumber == null ? email : null,
        'phoneNumber': email == null ? phoneNumber : null,
      });

      // if (result.data != null) detailsAdded = true;
      
    } on Exception catch (e) {
      // There was an unknown error
      Get.back();
      await showGetMessageDialog(
        'Error',
        e.toString()
        // 'An unkown error occured. Please try again later.'
      );

      return;
    }

    Get.back();
    await showGetMessageDialog(
      'Signup info',
      'Your account creation request has been successfuly sent to the admin.'
    );

    Get.offAll(const Login());
  }

}