import 'package:equaly/logic/app_bar/app_bar_cubit.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedExpenseListCubit, ExpenseListState>(builder: (context, list) {
      BlocProvider.of<AppBarCubit>(context).setTitle('${list.emoji} ${list.title}');
      return Text("List: ${list.title}");
    });
  }
}

