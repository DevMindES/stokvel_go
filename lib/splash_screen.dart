import 'package:flutter/material.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';

class SplashScreen extends StatelessWidget
{
  SplashScreen({super.key});


  @override Widget build(BuildContext context)
  {
    return Scaffold(
      // appBar: _utils.appBar(false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Image(
                image: AssetImage('assets/images/intro_building_square.jpg'),
                width: 50.0,
                height: 50.0,
              ) 
            ),
          ),
          spacer3(),
          const Center(
            child: CircularProgressIndicator(
              color: dark_fonts_grey,
            ),
          ),
        ],
      ),
    );
  }
}