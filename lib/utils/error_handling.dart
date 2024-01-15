import 'package:email_validator/email_validator.dart';

Map<String, String> getErrorMessageFromCode(String errorCode)
{
  switch (errorCode)
  {
    // sign-up errors
    case 'email-already-in-use':
      return {
        'errorCode': 'Email already in use',
        'errorMessage': 'There already exists an account with the given email address.',
      };
    case 'invalid-email':
      return {
        'errorCode': 'Invalid Email',
        'errorMessage': 'The email address is not valid.',
      };
    case 'operation-not-allowed':
      return {
        'errorCode': 'Operation not allowed',
        'errorMessage': 'Email/password accounts are not enabled. Please contact support to enable them.',
      };
    case 'weak-password':
      return {
        'errorCode': 'Weak Password',
        'errorMessage': 'The password is not strong enough.',
      };
    // login erros
    case 'user-disabled':
      return {
        'errorCode': 'User Disabled',
        'errorMessage': 'The user account has been disabled.',
      };
    case 'user-not-found':
      return {
        'errorCode': 'User Not Found',
        'errorMessage': 'There is no user with the given email address.',
      };
    case 'wrong-password':
      return {
        'errorCode': 'Wrong Password',
        'errorMessage': 'The password is incorrect.',
      };
    // password reset...
    case 'auth/invalid-email':
      return {
        'errorCode': 'Invalid Email',
        'errorMessage': 'The email address is not valid.',
      };
    case 'auth/missing-android-pkg-name':
      return {
        'errorCode': 'Missing Android Package Name',
        'errorMessage': 'An Android package name must be provided if the Android app is required to be installed.',
      };
    case 'auth/missing-continue-uri':
      return {
        'errorCode': 'Missing Continue URI',
        'errorMessage': 'A continue URL must be provided in the request.',
      };
    case 'auth/missing-ios-bundle-id':
      return {
        'errorCode': 'Missing iOS Bundle ID',
        'errorMessage': 'An iOS Bundle ID must be provided if an App Store ID is provided.',
      };
    case 'auth/invalid-continue-uri':
      return {
        'errorCode': 'Invalid Continue URI',
        'errorMessage': 'The continue URL provided in the request is invalid.',
      };
    case 'auth/unauthorized-continue-uri':
      return {
        'errorCode': 'Unauthorized Continue URI',
        'errorMessage': 'The domain of the continue URL is not whitelisted. Whitelist the domain in the Firebase console.',
      };
    case 'auth/user-not-found':
      return {
        'errorCode': 'User Not Found',
        'errorMessage': 'There is no user with the given email address.',
      };
    // confirm password reset
    case 'expired-action-code':
      return {
        'errorCode': 'Expired Code',
        'errorMessage': 'The password reset code has expired. Please request a new one.',
      };
    case 'invalid-action-code':
      return {
        'errorCode': 'Invalid Code',
        'errorMessage': 'The password reset code is invalid. Please check the code and try again.',
      };
    // default behavior
    default:
      return {
        'errorCode': 'Error',
        'errorMessage': 'An unexpected error occurred. Please try again later.',
      };
  }
}


int isEmailOrPhone({required String emailOrPhone})
{
  // Define a regular expression for Swaziland phone number validation
  final RegExp phoneRegex = RegExp(r"^(\+268)?(79|78|76)\d{6}$");

  // First, check if the input is a phone number
  if (phoneRegex.hasMatch(emailOrPhone)) return 0;

  // If the input is not a phone number, check if it's an email
  if (EmailValidator.validate(emailOrPhone)) return 1;
  
  return -1;
}
