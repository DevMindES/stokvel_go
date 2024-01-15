import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/pages/navigation/investment_centre.dart';
import 'package:stokvel_go/pages/navigation/lend_centre.dart';
import 'package:stokvel_go/pages/navigation/notifications.dart';
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
    const Notifications()
  ];

  int _navBarIndex = 0;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: offwhite_background,
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
      backgroundColor: offwhite_background,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: offwhite_background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: _listPages[_navBarIndex]
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: offwhite_background,
        elevation: 5.0,
        currentIndex: _navBarIndex,
        selectedItemColor: primary_blue,
        unselectedItemColor: dark_fonts_grey,
        onTap: (index) {
          setState(() => _navBarIndex = index);
        },
        items: [
          _item(iconData: Icons.wallet_rounded, itemLabel: 'Portfolio'),
          _item(iconData: Icons.attach_money_rounded, itemLabel: 'Investments'),
          _item(iconData: Icons.shopping_basket_outlined, itemLabel: 'Lending'),
          _item(iconData: Icons.notifications, itemLabel: 'Notifications')
        ],
      ),
    );
  }

  BottomNavigationBarItem _item({
    required IconData iconData,
    required String itemLabel
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: dark_fonts_grey,
      ),
      label: itemLabel
    );
  }
}