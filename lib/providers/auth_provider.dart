
// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stokvel_go/pages/landing.dart';
import 'package:stokvel_go/pages/onboarding/login.dart';
import 'package:stokvel_go/pages/onboarding/reset_password.dart';
import 'package:stokvel_go/utils/error_handling.dart';
import 'package:stokvel_go/utils/utils.dart';

class AuthProvider extends ChangeNotifier
{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;


  String? _name;
  String? _surname;
  String? _dateOfBirth;
  String? _country;
  String? _phoneNumber;
  String? _email;
  String? _password;
  String? _verificationID;
  User? _user;
  Stream<DocumentSnapshot<Map<String,dynamic>>>? _userDetails;
  String? _firestoreErrorMessage;

  AuthProvider()
  {
    if (_auth.currentUser != null) {
      _initUser();
      setUserDetails();
    }
  }

  void setName({required String name}) async {
    _name = name;
    notifyListeners();
  }

  String getName() => _name!;

  void setSurname({required String surname}) async {
    _surname = surname;
    notifyListeners();
  }

  void setDateOfBirth({required String dateOfBirth}) async {
    _dateOfBirth = dateOfBirth;
    notifyListeners();
  }

  void setCountry({required String country}) async {
    _country = country;
    notifyListeners();
  }

  void setPhoneNumber({required String phoneNumber}) async {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  String getPhoneNumber() => _phoneNumber!;

  void setEmail({required String email}) async {
    _email = email;
    notifyListeners();
  }

  String getEmail() => _email!;

  void setVerificationID({required String verificationID}) async {
    _verificationID = verificationID;
    notifyListeners();
  }

  void setPassword({required String password}) async {
    _password = password;
    notifyListeners();
  }

  String getUserID() => _user!.uid;

  void _initUser()
  {
    _user = _auth.currentUser;
    
    _userDetails = _firestore.collection('users')
      .doc(_auth.currentUser!.uid)
      .snapshots();
  }

  
  Future<void> setUserDetails() async
  {
    if (_userDetails != null) {
      await _userDetails!.first.then((documentSnapshot) {
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data()!;
          _name = data['displayName'];
          // _userSurname = data['surname'];
          // _userGender = data['gender'];
          _phoneNumber = data['phoneNumber'];
          // profilePhoto.value = data['profile_photo'];
        }
      });

    }
  }


  Future<void> forgotPassword({
    required String email,
    required BuildContext context}) async
  {
    showCircularProgressIndicator(context: context);

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
      Navigator.pop(context);

      if (errorMessage == null) { // it's a firebase auth exception
        Map<String, String> errorInfo = getErrorMessageFromCode(errorCode);
        await showMyDialog(
          context,
          errorInfo['errorCode'],
          errorInfo['errorMessage']
        );
      } else { // some other error
        await showMyDialog(
          context,
          errorCode,
          errorMessage
        );
      }
      
      return;
    }

    Navigator.pop(context);
    await showMyDialog(
      context,
      'Password reset info',
      'Password reset email sent.'
    );

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPassword()),
    );
  }

  
  Future<void> validatePasswordReset({
    required BuildContext context,
    required String validationCode,
    required String password}) async
  {
      showCircularProgressIndicator(context: context);

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
        Navigator.pop(context);

        if (errorMessage == null) { // it's a firebase auth exception
          Map<String, String> errorInfo = getErrorMessageFromCode(errorCode);
          await showMyDialog(
            context,
            errorInfo['errorCode'],
            errorInfo['errorMessage']
          );
        } else { // some other error
          await showMyDialog(
            context,
            errorCode,
            errorMessage
          );
        }
        
        return;
      }

      Navigator.pop(context);
      await showMyDialog(
        context,
        'Password reset info',
        'Password has been reset successfully.'
      );

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }


  Future<void> login({
    required BuildContext context,
    required String email,
    required String password}) async
  {
    showCircularProgressIndicator(context: context);

    String? errorCode;
    String? errorMessage;

    int isEmail = isEmailOrPhone(
      context: context,
      emailOrPhone: email
    );

    if (isEmail != 1) {
      Navigator.pop(context);
      await showMyDialog(
        context,
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
      Navigator.pop(context);

      if (errorMessage == null) { // it's a firebase auth exception
        Map<String, String> errorInfo = getErrorMessageFromCode(errorCode!);
        await showMyDialog(
          context,
          errorInfo['errorCode'],
          errorInfo['errorMessage']
        );
      } else { // some other error
        await showMyDialog(
          context,
          errorCode,
          errorMessage
        );
      }
      
      return;
    }

    _initUser();
    setUserDetails();

    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Landing()),
    );
  }


  Future<void> signUp({
    required BuildContext context,
    required String name,
    required String surname,
    required String idNumber,
    required String? phoneNumber,
    required String? email}) async
  {
    showCircularProgressIndicator(context: context);

    try { // check if this email or phone number is already existing
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkExistingUser');

      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'email': phoneNumber == null ? email : null,
        'phoneNumber': email == null ? phoneNumber : null,
      });

      String method = phoneNumber == null ? 'email' : 'phone number';

      if (result.data['status'] == 'warning') {
        Navigator.pop(context);
        await showMyDialog(
          context,
          'Info',
          'This $method is already assocciated with an existing account.'
        );

        return;
      }
    } on Exception catch (e) {
      // There was an unknown error
      Navigator.pop(context);
      await showMyDialog(
        context,
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
      Navigator.pop(context);
      await showMyDialog(
        context,
        'Error',
        e.toString()
        // 'An unkown error occured. Please try again later.'
      );

      return;
    }

    Navigator.pop(context);
    await showMyDialog(
      context,
      'Signup info',
      'Your account creation request has been successfuly sent to the admin.'
    );

    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );

  }



  Future<void> signup({
    required BuildContext context,
    required String name,
    required String surname,
    required String idNumber,
    required String? phoneNumber,
    required String? email ,
    required String password ,}) async
  {
    showCircularProgressIndicator(context: context);

    UserCredential? userCredential;
    String? errorCode;
    String? errorMessage;
    bool detailsAdded = false;

    if (email == null) {
      Navigator.pop(context);
      await showMyDialog(
        context,
        'Info',
        'Please use your email.'
      );

      return;
    }

    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
    } on SocketException catch (e) { // Handle network errors
      errorCode = 'Network error';
      errorMessage = 'Please check your internet connection and try again.';
    } catch (e) { // Handle other potential errors
      // logError(e); // Log the error for debugging
      errorCode = 'Unkown error';
      errorMessage = 'An unexpected error occurred. Please try again later.';
      // errorMessage = e.toString();
    }

    if (errorCode != null)
    { // an error occured
      Navigator.pop(context);

      if (errorMessage == null) { // it's a firebase auth exception
        Map<String, String> errorInfo = getErrorMessageFromCode(errorCode);
        await showMyDialog(
          context,
          errorInfo['errorCode'],
          errorInfo['errorMessage']
        );
      } else { // some other error
        await showMyDialog(
          context,
          errorCode,
          errorMessage
        );
      }
      
      return;
    }

    // await userCredential.user?.sendEmailVerification();

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
      Navigator.pop(context);
      await showMyDialog(
        context,
        'Error',
        e.toString()
        // 'An unkown error occured. Please try again later.'
      );

      return;
    }

    Navigator.pop(context);
    await showMyDialog(
      context,
      'Signup info',
      'Your account has been created successfully. Please enter your credentials again in the login screen.'
    );

    _initUser();
    setUserDetails();

    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );

  }
}