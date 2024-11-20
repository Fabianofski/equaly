import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void showSnackBarWithException(String message) {
  if (navigatorKey.currentContext == null) return;
  final scaffold = ScaffoldMessenger.of(navigatorKey.currentContext!);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ),
  );
}
