import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseListCubit, List<ExpenseListState>>(builder: (context, state) {
      ExpenseListState list = context.read<ExpenseListCubit>().getSelectedList();
      return Text("List: ${list.title}");
    });
  }
}

