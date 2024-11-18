import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/logic/navigation/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return SizedBox(
          height: 80,
          child: BottomNavigationBar(
              onTap: (index) {
                if (index == 1 && BlocProvider.of<SelectedExpenseListCubit>(context).state == null) {
                  return;
                }
                BlocProvider.of<NavigationCubit>(context).setNavBarItem(index);
              },
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: true,
              currentIndex: state.index,
              selectedItemColor: theme.primaryColor,
              unselectedItemColor: theme.primaryColor.withOpacity(0.5),
              iconSize: 26,
              selectedIconTheme: IconThemeData(
                size: 30
              ),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                    label: "Home", icon: Icon(FontAwesomeIcons.house)),
                BottomNavigationBarItem(
                  label: "List",
                  icon: Icon(FontAwesomeIcons.fileInvoice)
                ),
                BottomNavigationBarItem(
                  label: "Settings",
                  icon: Icon(FontAwesomeIcons.gear)
                ),
                BottomNavigationBarItem(
                  label: "Profile",
                  icon: Icon(FontAwesomeIcons.solidUser),
                ),
              ]),
        );
      },
    );
  }
}
