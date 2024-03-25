import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/init_packages.dart';
import 'package:stokvel_go/pages/navigation/investment_centre.dart';
import 'package:stokvel_go/pages/navigation/lend_centre.dart';
import 'package:stokvel_go/pages/navigation/portfolio.dart';
import 'package:stokvel_go/pages/onboarding/profile.dart';
import 'package:stokvel_go/utils/theme_data.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing>
{
  final _listPages = [
    const Portfolio(),
    const InvestmentCentre(),
    const LendCentre(),
  ];

  @override
  Widget build(BuildContext context)
  {
    return Obx(() => Scaffold(
      appBar: AppBar(
        elevation: 0.0, 
        backgroundColor: light_neumorphic_blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () => Get.to(() => const Profile()),
                child: const Icon(
                  Icons.person,
                  color: dark_fonts_grey,
                ),
              ),
            )
          ]
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _listPages[appController.navBarIndex]
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primary_blue,
        elevation: 0.0,
        currentIndex: appController.navBarIndex,
        selectedItemColor: white, 
        unselectedItemColor: dark_neumorphic_blue,
        onTap: (index) => appController.setNavBarIndex(index: index),
        items: [
          _item(iconData: Icons.wallet_rounded, itemLabel: 'Portfolio'),
          _item(iconData: Icons.attach_money_rounded, itemLabel: 'Investments'),
          _item(iconData: Icons.shopping_basket_outlined, itemLabel: 'Lending'),
        ],
      ),
    ));
  }

  BottomNavigationBarItem _item({
    required IconData iconData,
    required String itemLabel
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: light_neumorphic_blue,
      ),
      label: itemLabel
    );
  }
}