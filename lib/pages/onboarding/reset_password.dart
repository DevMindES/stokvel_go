import 'package:flutter/material.dart';
import 'package:stokvel_go/controllers/app_controller.dart';
import 'package:stokvel_go/controllers/auth_controller.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
{
  final _authController = AuthController.instance;
  final _appController = AppController.instance;

  final TextEditingController _validationCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  bool _allFieldsFilled() {
    if (_validationCodeController.text.trim().isEmpty) return false;
    if (_passwordController.text.trim().isEmpty) return false;
    return true;
  }

  bool _passwordsMatch() {
    bool passwordsMatch = false;
    if (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
      passwordsMatch = true;
    }
    return passwordsMatch;
  }

  Future<void> _resetPasswordOnPressed() async
  {
    if (!_allFieldsFilled()) {
      await showGetMessageDialog(
        tittle: 'Password reset info',
        message: 'Please fill in all fields.'
      );

      return;
    }

    if (!_passwordsMatch()) {
      await showGetMessageDialog(
        tittle: 'Passwords info',
        message: 'Please ensure passwords are the same.'
      );

      return;
    }
  }

  @override
  Widget build(BuildContext context)
  {    
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: light_neumorphic_blue,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: light_neumorphic_blue,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              spacer1(),
              // greeting text
              const Text(
                'Setup your new password',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              // user details form
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Form(
                  child: Column(
                    children: [
                      // CONFIRMATION CODE
                      _appController.formDataField(
                        fieldController: _validationCodeController,
                        lableText: 'Confirmation code',
                        textInputType: TextInputType.text
                      ),
                      // PASSWORD
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          width: _appController.widgetWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                    ],
                  )
                ),
              ),
              spacer3(),
              // RESET PASSWORD BUTTON
              _appController.neuBox(
                onTap: _resetPasswordOnPressed,
                width: null,
                child: const Center(
                  child: Text(
                    'Reset password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: h3,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3
                    ),
                  ),
                )
              ),
            ]
          ),
        ),
      ),
    );
  }
}