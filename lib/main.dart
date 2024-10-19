import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equaly',
      theme: ThemeData(
        fontFamily: 'Open Sans',
        appBarTheme: const AppBarTheme(
          color: Color(0xFFEEF4FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFEEF4FC),
        canvasColor: const Color(0xFFEEF4FC),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          elevation: 0,
          toolbarHeight: 110,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Übersicht',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Hi, ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: 'Fabian! 👋',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const HomeBody(),
      bottomNavigationBar: BottomNavigationBar(elevation: 0, items: const [
        BottomNavigationBarItem(
            label: "Home", icon: Icon(Icons.home, color: Colors.blue)),
        BottomNavigationBarItem(
            label: "List", icon: Icon(Icons.list, color: Colors.blue)),
        BottomNavigationBarItem(
            label: "Settings", icon: Icon(Icons.settings, color: Colors.blue)),
        BottomNavigationBarItem(
            label: "Profile", icon: Icon(Icons.person, color: Colors.blue)),
      ]),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0x883AC828),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0x88E2D66A),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0x8815376A),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ],
    );
  }
}
