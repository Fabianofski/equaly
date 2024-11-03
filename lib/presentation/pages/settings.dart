import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/app_bar/app_bar_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AppBarCubit>(context).setTitle('⚙️ Settings');
    return const Text("Settings");
  }
}
