import 'package:equaly/CustomBottomNavigationBar.dart';
import 'package:equaly/CustomAppBar.dart';
import 'package:equaly/logic/navigation/constants/nav_bar_items.dart';
import 'package:equaly/logic/navigation/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/pages/home.dart';
import 'presentation/pages/list.dart';
import 'presentation/pages/profile.dart';
import 'presentation/pages/settings.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationCubit>(
      create: (context) => NavigationCubit(),
      child: MaterialApp(
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
      ),
    );
  }
}

class AppContainer extends StatelessWidget {
  final String selectedListId = "";

  const AppContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Map<NavbarItem, Widget> body = {
      NavbarItem.home: HomePage(),
      NavbarItem.list: ListPage(selectedListId: selectedListId),
      NavbarItem.settings: SettingsPage(),
      NavbarItem.profile: ProfilePage()
    };

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: CustomAppBar(),
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
          return body[state.navbarItem] ?? Text("404");
      }),
      bottomNavigationBar:
          CustomBottomNavigationBar(),
    );
  }
}
