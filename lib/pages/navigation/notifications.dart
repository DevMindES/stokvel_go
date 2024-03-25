import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today', style: TextStyle(color: Colors.black, fontSize: 18)),
            SizedBox(height: 8),
            NotificationTile(
              icon: Icons.check_circle_outline,
              text: 'Loan Approved - R 1200',
              backgroundColor: Colors.blue,
            ),
            NotificationTile(
              icon: Icons.people_outline,
              text: 'Contribution window closes in 2 days',
              backgroundColor: Colors.white,
            ),
            NotificationTile(
              icon: Icons.remove_circle_outline,
              text: 'Monthly Contribution + R 400',
              backgroundColor: Colors.blue,
            ),
            NotificationTile(
              icon: Icons.check,
              text: 'Change of address successfully',
              backgroundColor: Colors.white,
            ),
            // ... Add the other NotificationTile widgets here for 'Today'
            SizedBox(height: 16),
            Text('Last Week', style: TextStyle(color: Colors.black, fontSize: 18)),
            SizedBox(height: 8),
            NotificationTile(
              icon: Icons.cancel_outlined,
              text: 'Loan Application Declined',
              backgroundColor: Colors.white,
            ),
            NotificationTile(
              icon: Icons.people_outline,
              text: 'Unpaid contribution for September.',
              backgroundColor: Colors.white,
            ),
            NotificationTile(
              icon: Icons.campaign_outlined,
              text: "We're launching a new Investment vehicle in September. Be on the lookout!",
              backgroundColor: Colors.white,
            ),
            NotificationTile(
              icon: Icons.people_outline,
              text: 'Initial Contributions due on 01/01/2024',
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;

  const NotificationTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: backgroundColor == Colors.white ? Colors.black : Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: backgroundColor == Colors.white ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
