import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/navigation/navigation_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseListCubit, List<ExpenseListState>>(builder: (context, state) {
      return GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: (192.0 / 234.0),
        children: [for (var list in state) ExpenseListCard(list: list)],
      );
    });
  }
}

class ExpenseListCard extends StatelessWidget {
  const ExpenseListCard({super.key, required this.list});

  final ExpenseListState list;

  void selectNewList(BuildContext context, String id) {
    BlocProvider.of<NavigationCubit>(context).setNavBarItem(1);
    BlocProvider.of<ExpenseListCubit>(context).selectList(id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => {selectNewList(context, list.id)},
            child: Container(
              decoration: BoxDecoration(
                color: Color(list.color),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  list.emoji,
                  style: const TextStyle(fontSize: 86),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            list.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: -.5,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(list.totalCost),
        ),
      ],
    );
  }
}
