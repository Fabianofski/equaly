import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarCubit extends Cubit<String> {
  AppBarCubit() : super("🏡 Home");

  void setTitle(String title) {
    emit(title);
  }
}