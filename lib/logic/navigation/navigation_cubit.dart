import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/nav_bar_items.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(NavbarItem.home, 0));

  void setNavBarItem(int index) {
    switch (index) {
      case 0:
        emit(NavigationState(NavbarItem.home, 0));
        break;
      case 1:
        emit(NavigationState(NavbarItem.list, 1));
        break;
      case 2:
        emit(NavigationState(NavbarItem.settings, 2));
        break;
      case 3:
        emit(NavigationState(NavbarItem.profile, 3));
        break;
    }
  }
}