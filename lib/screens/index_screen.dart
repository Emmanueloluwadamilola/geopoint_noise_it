import 'package:flutter/material.dart';
import 'package:futa_noise_app/constants.dart';
import 'package:futa_noise_app/screens/home_screen.dart';
import 'package:futa_noise_app/screens/list_page.dart';
import 'package:futa_noise_app/screens/map_screen.dart';
import 'package:futa_noise_app/screens/settings_page.dart';

class IndexScreen extends StatefulWidget {
  static const id = 'index';
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int selectedIndex = 0;

  final screens = [
    const Home(),
    const ListPage(),
    const MapScreen(),
    const SettingPage(),
  ];

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 28,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_outlined),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: kPrimaryColour.withOpacity(0.3),
        selectedItemColor: kPrimaryColour,
        onTap: changeIndex,
      ),
    );
  }
}
