import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> signIn() async {
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    GoogleSignIn googleSignIn = GoogleSignIn(
      //clientId: "409120859083-0k6e7ifsh8h4o5nqbs5rlfjajj82gtuh.apps.googleusercontent.com",
    );

    try {
      await googleSignIn.signIn();
      print("Success");
    } catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: signIn, child: Text("Login"));
  }
}
