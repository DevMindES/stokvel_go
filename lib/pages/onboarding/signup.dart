import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stokvel_go/providers/app_data.dart';
import 'package:stokvel_go/providers/auth_provider.dart';
import 'package:stokvel_go/utils/error_handling.dart';
import 'package:stokvel_go/utils/neubox.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>
{
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _allFieldsFilled() {
    if (_nameController.text.trim().isEmpty) return false;
    if (_surnameController.text.trim().isEmpty) return false;
    if (_idController.text.trim().isEmpty) return false;
    if (_emailOrPhoneController.text.trim().isEmpty) return false;
    if (_passwordController.text.trim().isEmpty) return false;
    if (_confirmPasswordController.text.trim().isEmpty) return false;
    if (_confirmPasswordController.text.trim().isEmpty) return false;
    return true;
  }

  bool _passwordsMatch() {
    bool passwordsMatch = false;
    if (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
      passwordsMatch = true;
    }
    return passwordsMatch;
  }

  Future<void> _signUpButtonOnPressed() async
  {
    if (!_allFieldsFilled()) {
      await showMyDialog(
        context,
        'Info',
        'Please fill out all text fields.'
      );
      return;
    }

    final isEmailORphone = isEmailOrPhone(
      context: context,
      emailOrPhone: _emailOrPhoneController.text.trim()
    );

    if (isEmailORphone == -1) {
      // If it's not a valid email or phone, show the dialog
      await showMyDialog(
        context,
        'Info',
        'Please ensure you have entered a valid email address or phone number'
      );

      return;
    }

    if (!_passwordsMatch()) {
      await showMyDialog(
        context,
        'Info',
        'Please double check your passwords.'
      );
      return;
    }

    String? phoneNumber;

    if (isEmailORphone == 0 && !_emailOrPhoneController.text.trim().startsWith('+268')) {
      phoneNumber = '+268${_emailOrPhoneController.text.trim()}';
    }

    context.read<AuthProvider>().signup(
      context: context,
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      idNumber: _idController.text.trim(),
      email: isEmailORphone == 1 ? _emailOrPhoneController.text.trim() : null,
      phoneNumber: isEmailORphone == 0 ? phoneNumber : null,
      password: _passwordController.text.trim()
    );
  }

  @override
  Widget build(BuildContext context)
  {
    final _appData = Provider.of<AppData>(context, listen: false);

    return Scaffold(
      appBar: appBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: offwhite_background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                spacer2(),
                const Text(
                  'Please sign up below',
                  style: TextStyle(
                    fontSize: h1,
                    fontWeight: FontWeight.bold,
                    color: dark_fonts_grey
                  ),
                ),
                spacer1(),
                // NAME
                _appData.formDataField(
                  fieldController: _nameController,
                  lableText: 'Name',
                  textInputType: TextInputType.name
                ),
                // SURNNAME
                _appData.formDataField(
                  fieldController: _surnameController,
                  lableText: 'Surname',
                  textInputType: TextInputType.name
                ),
                // ID
                _appData.formDataField(
                  fieldController: _idController,
                  lableText: 'ID Number',
                  textInputType: TextInputType.number
                ),
                // EMAIL
                _appData.formDataField(
                  fieldController: _emailOrPhoneController,
                  lableText: 'Email or Phone number',
                  textInputType: TextInputType.emailAddress
                ),
                // PASSWORD
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    width: _appData.getWidgetWidth(),
                    decoration: BoxDecoration(
                      color: Colors.white, //.withOpacity(0.1),
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
                    width: _appData.getWidgetWidth(),
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
                NeuBox(
                  width: _appData.getWidgetWidth(),
                  onTap: _signUpButtonOnPressed,
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: contentTextStyle(
                        fontSize: h3,
                        fontColor: Colors.white
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}