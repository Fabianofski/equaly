import 'package:equaly/logic/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../logic/app_bar/app_bar_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AppBarCubit>(context).setTitle('👤 Profile');

    return BlocBuilder<AuthCubit, GoogleSignInAccount?>(
        builder: (context, account) {
      if (account != null) {
        return LoginPage(account: account);
      } else {
        return FilledButton(
          onPressed: BlocProvider.of<AuthCubit>(context).signIn,
          child: Text("Login"),
        );
      }
    });
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.account});

  final GoogleSignInAccount account;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(account.displayName ?? "DisplayName"),
        Text(account.email),
        FilledButton(onPressed: BlocProvider.of<AuthCubit>(context).signOut, child: Text("Sign Out"))
      ],
    );
  }
}
