import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onBottomNavTapped});

  final int currentIndex;
  final ValueChanged<int> onBottomNavTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: onBottomNavTapped,
        currentIndex: currentIndex,
        elevation: 0,
        fixedColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
              label: "Home", icon: Icon(Icons.home, color: Colors.blue)),
          BottomNavigationBarItem(
              label: "List", icon: Icon(Icons.list, color: Colors.blue)),
          BottomNavigationBarItem(
              label: "Settings",
              icon: Icon(Icons.settings, color: Colors.blue)),
          BottomNavigationBarItem(
              label: "Profile", icon: Icon(Icons.person, color: Colors.blue)),
        ]);
  }
}
