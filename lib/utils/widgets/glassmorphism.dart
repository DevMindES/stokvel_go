import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stokvel_go/init_packages.dart';
import 'package:stokvel_go/utils/theme_data.dart';

class GlassMorphism extends StatelessWidget 
{
  final double blur = 10.0;
  final double opacity = 0.1;
  final Widget child;
  
  const GlassMorphism({
    super.key, 
    required this.child
  });

  @override
  Widget build(BuildContext context) 
  {
    return ClipRRect(
      // borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: appController.screenWidth,
          height: appController.screenHeight,
          decoration: BoxDecoration(
            color: white.withOpacity(opacity)
          ),
          child: child,
        ),
      ),
    );
  }
}