import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/pages/navigation/notifications.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';
import '../../init_packages.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() => Column(
            children: [
              // profile picture
              CircleAvatar(
                radius: appController.screenHeight * 0.10,
                backgroundImage: authController.profilePhoto.isNotEmpty
                  ? Image.memory(base64Decode(authController.profilePhoto)).image 
                  : const AssetImage("assets/icons/user.png"),
              ),
              // name
              Text(
                '${authController.name} ${authController.surname}',
                style: contentTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: h1
                ),
              ),
              // email
              Text(
                authController.email,
                style: contentTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: h4,
                  fontColor: light_fonts_grey
                ),
              ),
              // phone number
              Text(
                authController.phoneNumber,
                style: contentTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: h4,
                  fontColor: light_fonts_grey
                ),
              ),
              spacer2(), 
              // edit profile
              _profileItem(
                onTap: () {}, 
                iconData: Icons.edit, 
                label: "Edit profile"
              ), 
              // settings
              _profileItem(
                onTap: () {}, 
                iconData: Icons.settings, 
                label: "Settings"
              ), 
              // notifications
              _profileItem(
                onTap:() async => await Get.to(() => const Notifications()), 
                iconData: Icons.notifications, 
                label: "Notifications"
              ), 
              // help
              _profileItem(
                onTap: () {}, 
                iconData: Icons.help, 
                label: "Help"
              ), 
              // logout
              _profileItem(
                onTap:() async => await authController.logout(), 
                iconData: Icons.exit_to_app, 
                label: "Logout"
              ), 
            ],
          )),
        ),
      ),
    );
  }

  Widget _profileItem({
    required VoidCallback onTap,
    required IconData iconData,
    required String label
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: appController.hsp * 0.50, 
        horizontal: appController.hsp
      ),
      child: Row(
        children: [
          neuBox(
            onTap: onTap,
            // color: purple,
            child: Icon(iconData, color: white),
          ),
          const SizedBox(width: 10.0),
          Text(
            label, 
            style: contentTextStyle(
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}