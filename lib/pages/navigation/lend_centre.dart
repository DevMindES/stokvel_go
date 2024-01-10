import 'package:flutter/material.dart';

class LendCentre extends StatefulWidget {
  const LendCentre({super.key});

  @override
  State<LendCentre> createState() => _LendCentreState();
}

class _LendCentreState extends State<LendCentre> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text('lend'),
        )
      ],
    );;
  }
}