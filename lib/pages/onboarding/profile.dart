import 'package:flutter/material.dart';
import 'package:stokvel_go/controllers/auth_controller.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
{
  final _authController = AuthController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offwhite_background,
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              spacer1(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 12.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async => await _authController.logout(),
                      child: const Icon(
                        Icons.highlight_off_rounded,
                        color: dark_fonts_grey,
                      ),
                    ),
                    const SizedBox(width: 20.0,),
                    Text(
                      'Logout',
                      style: contentTextStyle(),
                    )
                  ],
                ),
              ),
              const Center(
                child: Text('profile'),
              )
            ],
          ),
        ),
      ),
    );
  }
}