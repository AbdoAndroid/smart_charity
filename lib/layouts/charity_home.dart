import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:smart_charity/layouts/charity_donations.dart';
import 'package:smart_charity/layouts/charity_search.dart';
import 'package:smart_charity/layouts/login.dart';
import 'package:smart_charity/service/auth.dart';

class CharityHome extends StatefulWidget {
  const CharityHome({Key? key}) : super(key: key);

  @override
  State<CharityHome> createState() => _CharityHomeState();
}

class _CharityHomeState extends State<CharityHome> {
  int selectedTap = 1;
  List<Widget> tabs = [
    CharityDonations(status: 1),
    CharitySearch(),
    CharityDonations(status: 2)
  ];
  List<String> titles = [
    'Under contact Donations',
    'Search ',
    'Delivered Donations'
  ];
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
              icon: Icon(Icons.refresh)),
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
          BarItem(title: 'Under contact', icon: Icons.wifi_calling_rounded),
          BarItem(title: 'Search', icon: Icons.search),
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
