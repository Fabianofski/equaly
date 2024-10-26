import 'package:equaly/logic/navigation/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  void onBottomNavTapped(index) {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
            onTap: (index) {
              BlocProvider.of<NavigationCubit>(context).setNavBarItem(index);
            },
            currentIndex: state.index,
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
                  label: "Profile",
                  icon: Icon(Icons.person, color: Colors.blue)),
            ]);
      },
    );
  }
}
