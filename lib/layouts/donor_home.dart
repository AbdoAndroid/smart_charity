import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:smart_charity/layouts/add_donation.dart';
import 'package:smart_charity/layouts/donor_donations.dart';
import 'package:smart_charity/layouts/login.dart';
import 'package:smart_charity/service/auth.dart';

class NormalUserHome extends StatefulWidget {
  const NormalUserHome({Key? key}) : super(key: key);

  @override
  State<NormalUserHome> createState() => _NormalUserHomeState();
}

class _NormalUserHomeState extends State<NormalUserHome> {
  //String city = 'All cities';
  int selectedTap = 1;
  List<Widget> tabs = [
    DonorDonations(
      status: 1,
    ),
    AddDonation(),
    DonorDonations(status: 2)
  ];

  List<String> titles = ['Waiting Donations', 'Donate', 'Delivered Donations'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedTap]),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () async {
                await logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              )),
        ],
      ),
      body: tabs[selectedTap],
      bottomNavigationBar: SlidingClippedNavBar(
        barItems: [
          BarItem(title: 'Waiting', icon: Icons.pending_actions),
          BarItem(title: 'Donate', icon: Icons.add),
          BarItem(title: 'Delivered', icon: Icons.done_all),
        ],
        selectedIndex: selectedTap,
        onButtonPressed: (int index) {
          setState(() {
            selectedTap = index;
          });
        },
        activeColor: Colors.blue,
      ),
    );
  }
}
