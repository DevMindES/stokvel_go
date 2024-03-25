import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/pages/onboarding/signup.dart';
import 'package:stokvel_go/utils/error_handling.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';

import '../../init_packages.dart';


class Login extends StatefulWidget
{
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>
{
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  bool _allFieldsFilled() {
    if (_emailOrPhoneController.text.trim().isEmpty) return false;
    if (_passwordController.text.trim().isEmpty) return false;
    return true;
  }

  Future<void> _loginButtonOnPresed() async
  {
    if (!_allFieldsFilled()) {
      await showGetMessageDialog(
        message: 'Please fill out all text fields.'
      );
      
      return;
    }

    final isEmailORphone = isEmailOrPhone(emailOrPhone: _emailOrPhoneController.text.trim());

    if (isEmailORphone == -1) {
      await showMyDialog(
        context,
        'Info',
        'Please ensure you have entered a valid email address or phone number'
      );

      return;
    }

    String? phoneNumber;

    if (isEmailORphone == 0 && !_emailOrPhoneController.text.trim().startsWith('+268')) {
      phoneNumber = '+268${_emailOrPhoneController.text.trim()}';
    }

    await authController.login(
      email: phoneNumber ?? _emailOrPhoneController.text.trim(),
      password: _passwordController.text.trim()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: appController.hsp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // building image
                spacer1(),
                Container(
                  width: appController.widgetWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: const Image(
                    image: AssetImage("assets/images/intro_building_rect.jpg"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                // greeting text
                spacer1(),
                contentText(
                  data: "Hello, please sign in below",
                  fontSize: h1,
                  fontWeight: FontWeight.bold),
                // user details form
                spacer1(),
                Form(
                  child: Column(
                    children: [
                      // EMAIL OR PHONE NUMBER
                      formDataField(
                        fieldController: _emailOrPhoneController, 
                        lableText: "Email", 
                        textInputType: TextInputType.text),
                        spacer4(),
                      // PASSWORD
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          width: appController.widgetWidth,
                          decoration: BoxDecoration(
                            color: white,
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
                              labelStyle: contentTextStyle(
                                fontSize: h4,
                                fontColor: primary_blue
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                          ),
                        ),
                      ),
                              
                    ],
                  )
                ),
                spacer3(),
                // fORGOT PASSWORD
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    width: appController.widgetWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async
                          {
                            if (_emailOrPhoneController.text.trim().isEmpty) {
                              await showMyDialog(
                                context,
                                'Password reset info',
                                'Please fill in your email first'
                              );
              
                              return;
                            }
              
                            if (!EmailValidator.validate(_emailOrPhoneController.text.trim())) {
                              showMyDialog(
                                context,
                                'Info',
                                'Please enter a valid email address'
                              );
              
                              return;
                            }
              
                            await authController.forgotPassword(email: _emailOrPhoneController.text.trim());
                          },
                          child: contentText(
                            data: "Forgot password",
                            fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                spacer3(),
                // LOGIN
                neuBox(
                  onTap: _loginButtonOnPresed,
                  wide: true, 
                  color: primary_blue,
                  child: contentText(
                    data: "Login",
                    fontColor: white,
                    fontWeight: FontWeight.bold,)
                ),
                // to REGISTER page
                spacer1(),
                SizedBox(
                  width: appController.widgetWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      contentText(data: "Not a member?"),
                      spacer4(),
                      GestureDetector(
                        onTap: () async => await Get.to(() => const SignUp()),
                        child: contentText(
                          data: "Register here.",
                          fontColor: primary_blue,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }

  @override void dispose()
  {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}