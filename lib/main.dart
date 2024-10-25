import 'package:equaly/CustomBottomNavigationBar.dart';
import 'package:equaly/CustomAppBar.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/list.dart';
import 'pages/profile.dart';
import 'pages/settings.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equaly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Open Sans',
        appBarTheme: const AppBarTheme(
          color: Color(0xFFEEF4FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFEEF4FC),
        canvasColor: const Color(0xFFE3EBF4),
        useMaterial3: true,
      ),
      home: const AppContainer(),
    );
  }
}

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _currentIndex = 0;
  String selectedListId = "";

  void selectNewList(String listId) {
    setState(() {
      selectedListId = listId;
      _currentIndex = 1;
    });
  }

  void onBottomNavTap(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body = [
      HomePage(selectNewList: selectNewList),
      ListPage(selectedListId: selectedListId),
      SettingsPage(),
      ProfilePage()
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: CustomAppBar(),
      ),
      body: body[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex, onBottomNavTapped: onBottomNavTap),
    );
  }
}
