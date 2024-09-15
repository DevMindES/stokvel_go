import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stokvel_go/utils/error_handling.dart';
import 'package:stokvel_go/utils/neubox.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';
import '../../init_packages.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _allFieldsFilled() {
    if (_nameController.text.trim().isEmpty) return false;
    if (_surnameController.text.trim().isEmpty) return false;
    if (_idController.text.trim().isEmpty) return false;
    if (_emailController.text.trim().isEmpty) return false;
    if (_phoneNumberController.text.trim().isEmpty) return false;
    if (_passwordController.text.trim().isEmpty) return false;
    if (_confirmPasswordController.text.trim().isEmpty) return false;
    return true;
  }

// Signup - Nqoba

  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating the user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _idController.text);
      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
  }

// error message to user

  void showErrorMessage(String Message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              Message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // bool _passwordsMatch() => _passwordController.text.trim() == _confirmPasswordController.text.trim();

  Future<void> _signUpButtonOnPressed() async {
    if (!_allFieldsFilled()) {
      await showGetMessageDialog(message: 'Please fill out all text fields.');
      return;
    }

    final isEmail = isEmailOrPhone(emailOrPhone: _emailController.text.trim());

    if (isEmail == -1) {
      // If it's not a valid email or phone, show the dialog
      await showGetMessageDialog(
          message: 'Please ensure you have entered a valid email address.');

      return;
    }

    String phoneNumber = _phoneNumberController.text.trim();
    if (!phoneNumber.startsWith("+268")) phoneNumber = "+268$phoneNumber";

    final isPhoneNumber = isEmailOrPhone(emailOrPhone: phoneNumber);

    if (isPhoneNumber == -1) {
      // If it's not a valid email or phone, show the dialog
      await showGetMessageDialog(
          message: 'Please ensure you have entered a valid phone number.');

      return;
    }

    await authController.signUp(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        idNumber: _idController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: phoneNumber,
        password: _confirmPasswordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: appController.hsp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                spacer2(),
                contentText(
                  data: 'Please sign up below',
                  fontSize: h1,
                  fontWeight: FontWeight.bold,
                ),
                spacer1(),
                // NAME
                formDataField(
                    fieldController: _nameController,
                    lableText: 'Name',
                    textInputType: TextInputType.name),
                spacer4(),
                // SURNNAME
                formDataField(
                    fieldController: _surnameController,
                    lableText: 'Surname',
                    textInputType: TextInputType.name),
                spacer4(),
                // ID
                formDataField(
                    fieldController: _idController,
                    lableText: 'ID Number',
                    textInputType: TextInputType.number),
                spacer4(),
                // EMAIL
                formDataField(
                    fieldController: _emailController,
                    lableText: 'Email',
                    textInputType: TextInputType.emailAddress),
                spacer4(),
                // PHONE NUMBER
                formDataField(
                    fieldController: _phoneNumberController,
                    lableText: 'Phone number',
                    textInputType: TextInputType.number),
                // PASSWORD
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    width: appController.widgetWidth,
                    decoration: BoxDecoration(
                      color: white, //.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {return 'Please enter some text';}
                        return null;
                      },
                      controller: _passwordController,
                      style: const TextStyle(
                        fontSize: h3,
                        color: dark_fonts_grey
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: _isPasswordVisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          onPressed:() => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          color: Colors.redAccent,
                        ),
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          color: dark_fonts_grey
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                  ),
                ),
                // CONFIRM PASSWORD
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    width: appController.widgetWidth,
                    decoration: BoxDecoration(
                      color: Colors.white, //.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {return 'Please enter some text';}
                        return null;
                      },
                      controller: _confirmPasswordController,
                      style: const TextStyle(
                        fontSize: h3,
                        color: dark_fonts_grey
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: _isConfirmPasswordVisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          onPressed:() => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                          color: Colors.redAccent,
                        ),
                        labelText: 'Confirm password',
                        labelStyle: const TextStyle(
                          color: dark_fonts_grey
                        ),
                      ),
                      obscureText: !_isConfirmPasswordVisible,
                    ),
                  ),
                ),

                // SIGN UP BUTTON
                spacer1(),
                neuBox(
                  // onTap: signUserUp,+
                  onTap: _signUpButtonOnPressed,
                  wide: true,
                  child: contentText(
                      data: 'Sign Up',
                      fontColor: white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
