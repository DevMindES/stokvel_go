import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stokvel_go/utils/theme_data.dart';

class NeuBox extends StatelessWidget
{
  final Widget? child;
  final double? width;
  final VoidCallback? onTap;
  static const double distance = 5.0;

  const NeuBox({
    super.key,
    required this.child,
    required this.width,
    required this.onTap
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: primary_blue,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            // lighter shdow on top left
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-distance, -distance),
              blurRadius: 8.0,
            ),
            // darker shdow on bottom right
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(distance, distance),
              blurRadius: 6.0
            ),
          ]
        ),
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}