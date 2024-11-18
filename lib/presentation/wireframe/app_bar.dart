import 'package:equaly/logic/app_bar/app_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      toolbarHeight: 110,
      title: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Übersicht',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 24),
            BlocBuilder<AppBarCubit, String>(
              builder: (context, state) {
                return RichText(
                  maxLines: 1,
                  text: TextSpan(
                    text: state,
                    style: theme.textTheme.titleMedium,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
