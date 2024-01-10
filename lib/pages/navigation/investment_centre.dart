import 'package:flutter/material.dart';

class InvestmentCentre extends StatefulWidget {
  const InvestmentCentre({super.key});

  @override
  State<InvestmentCentre> createState() => _InvestmentCentreState();
}

class _InvestmentCentreState extends State<InvestmentCentre>
{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text('investments'),
        )
      ],
    );
  }
}