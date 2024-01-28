import 'package:flutter/material.dart';

class LendCentre extends StatefulWidget {
  const LendCentre({super.key});

  @override
  State<LendCentre> createState() => _LendCentreState();
}

class _LendCentreState extends State<LendCentre> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BorrowingInfoCard(),

          BorrowingList(),
          UnderReviewSection(),
          GetCashButton(),
        ],
      ),
    );
  }
}


class BorrowingInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BorrowingInfoRow(
                icon: Icons.currency_exchange,
                label: 'Total Borrowing',
                value: 'R2 000',
              ),
              SizedBox(height: 14), // Added space for better separation
              BorrowingInfoRow(
                icon: Icons.trending_up,
                label: 'Interest Accrued',
                value: 'R 500',
                valueColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BorrowingInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const BorrowingInfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 22)),
          Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: valueColor ?? Colors.black),
          ),
        ],
      ),
    );
  }
}

class BorrowingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text('Borrowing per Stokvel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          BorrowingListItem(
            stokvelName: 'Stokvel A',
            borrowingAmount: 'R 1 500',
            interestAmount: 'R 400',
          ),
          BorrowingListItem(
            stokvelName: 'Stokvel B',
            borrowingAmount: 'R 500',
            interestAmount: 'R 100',
          ),
        ],
      ),
    );
  }
}

class BorrowingListItem extends StatelessWidget {
  final String stokvelName;
  final String borrowingAmount;
  final String interestAmount;

  const BorrowingListItem({
    Key? key,
    required this.stokvelName,
    required this.borrowingAmount,
    required this.interestAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(stokvelName, style: TextStyle(fontSize: 16)),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(borrowingAmount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(interestAmount, style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UnderReviewSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Under Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          // Repeated cards for different "under review" items
          UnderReviewCard(title: 'Stokvel C', amount: 'R 1 500', interestRate: '20 %'),
          UnderReviewCard(title: 'Stokvel D', amount: 'R 800', interestRate: '15 %'),
        ],
      ),
    );
  }
}

class UnderReviewCard extends StatelessWidget {
  final String title;
  final String amount;
  final String interestRate;

  const UnderReviewCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.interestRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            Spacer(),
            Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 4),
            Text(interestRate, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class GetCashButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50), // double.infinity is the width and 50 is the height
          backgroundColor: Colors.blue, // Button color
          foregroundColor: Colors.white, // Text color
        ),
        onPressed: () {},
        child: Text('Get cash', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
