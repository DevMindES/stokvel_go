import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/init_packages.dart';
import 'package:stokvel_go/pages/navigation/join_stokvel.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          spacer4(), 
          Padding(
            padding: EdgeInsets.symmetric(horizontal: appController.hsp),
            child: _buildSummaryCard(),
          ), 
          spacer1(), 
          // join stokvel nutton
          Padding(
            padding: EdgeInsets.symmetric(horizontal: appController.hsp),
            child: neuBox(
              onTap:() async => await Get.to(() => const JoinStokvel()),
              color: primary_blue,
              child: Row(
                children: [
                  const Icon(
                    Icons.add_circle_outline_rounded, 
                    color: white, 
                    size: 30.0,
                  ), 
                  spacer4(), 
                  Text(
                    "Join stokvel", 
                    style: contentTextStyle(
                      fontColor: white,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              )),
          ), 
            spacer2(), 
          _buildAssetsSection(), 
          spacer1()
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return neuBox(
      color: light_neumorphic_blue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryItem('   Total Contributions', '   R13 000'),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Interest earned', 'R 6 000', icon: Icons.trending_up, iconColor: Colors.green),
                _buildSummaryItem('Interest Accrued', 'R 3 000', icon: Icons.trending_down, iconColor: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, {IconData? icon, Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(icon, color: iconColor),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey)),
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildAssetsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appController.hsp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your assets', 
            style: contentTextStyle(
              fontWeight: FontWeight.bold
            )
          ),
          spacer3(),
          _buildAssetCard('Stokvel A', 'R 2 600', '52%'),
          spacer2(), 
          _buildAssetCard('Stokvel B', 'R 1 400', '35%'),
          spacer2(), 
          _buildAssetCard('Stokvel C', 'R 500', '50%'),
          spacer2(), 
          _buildAssetCard('Stokvel D', 'R 1000', '33.33%'),
        ],
      ),
    );
  }

  Widget _buildAssetCard(String name, String amount, String percentage) {
    return neuBox(
      // color: purple,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name, 
              style: contentTextStyle(
                // fontColor: white
              )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount, 
                  style: contentTextStyle(
                    fontWeight: FontWeight.bold, 
                    // fontColor: white
                  )
                ),
                Text(
                  percentage, 
                  style: contentTextStyle(
                    // fontColor: white
                  )
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
