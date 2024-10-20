import 'package:equaly/pages/home.dart';
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
      home: const HomePage(),
    );
  }
}

