import 'dart:developer';

import 'package:equaly/logic/utils/snack_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<GoogleSignInAccount?> {
  AuthCubit() : super(null);

  final GoogleSignIn googleSignIn = GoogleSignIn(
    serverClientId: "409120859082-v12cnpu453kqp6bm0drvk5289d0ll108.apps.googleusercontent.com"
  );

  Future<void> signIn() async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      emit(account);

      if (account != null) {
        showSnackBarSuccess("Logged in successfully");
        GoogleSignInAuthentication auth = await account.authentication;
        log("${auth.idToken}");
      } else {
        showSnackBarWithException("Something went wrong...");
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      emit(null);
    } catch (error) {
      log(error.toString());
      showSnackBarWithException(error.toString());
    }
  }
}
