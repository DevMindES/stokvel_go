import 'package:flutter/material.dart';

class InvestmentCentre extends StatefulWidget {
  const InvestmentCentre({super.key});

  @override
  State<InvestmentCentre> createState() => _InvestmentCentreState();
}

class _InvestmentCentreState extends State<InvestmentCentre> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildContributionCard(),
          SizedBox(height: 12),
          _buildContributionList(),
        ],
      ),
    );
  }

  Widget _buildContributionCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildContributionValueTile(),
              _buildInterestEarnedTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContributionValueTile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://placehold.co/40x40?description=Profile%20Image'),
      ),
      title: Text('Total Contribution Value', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
      subtitle: Text('R13 000', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInterestEarnedTile() {
    return ListTile(
      leading: Icon(Icons.trending_up, color: Colors.green),
      title: Text('Interest earned', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
      subtitle: Text('R 6 000', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildContributionList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contribution Per Stokvel', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _buildStokvelChipRow(),
          Divider(),
          _buildStokvelItem('Stokvel A', 'R 5 000', '+R 3 000'),
          Divider(),
          _buildStokvelItem('Stokvel B', 'R 4 000', '+R 1 500'),
          Divider(),
          _buildStokvelItem('Stokvel C', 'R 1 000', '+R 500'),
          Divider(),
          _buildStokvelItem('Stokvel D', 'R 3 000', '+R 1 000'),
        ],
      ),
    );
  }

  Widget _buildStokvelChipRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Chip(
          label: Text('Stokvel'),
          backgroundColor: Colors.blue,
          labelStyle: TextStyle(color: Colors.white),
        ),
        Text('Total contribution', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
      ],
    );
  }

  Widget _buildStokvelItem(String name, String total, String interest) {
    return ListTile(
      title: Text(name, style: TextStyle(color: Colors.black, fontSize: 16)),
      subtitle: Text(interest, style: TextStyle(color: Colors.green, fontSize: 14)),
      trailing: Text(total, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
