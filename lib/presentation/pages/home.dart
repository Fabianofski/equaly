import 'package:equaly/logic/app_bar/app_bar_cubit.dart';
import 'package:equaly/logic/currency_mapper.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/logic/list/expense_list_wrapper_state.dart';
import 'package:equaly/presentation/modals/new_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../logic/navigation/navigation_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AppBarCubit>(context).setTitle('🏡 Home');

    return BlocBuilder<ExpenseListCubit, List<ExpenseListWrapperState>>(
        builder: (context, state) {
      return RefreshIndicator(
        onRefresh: () {
          return BlocProvider.of<ExpenseListCubit>(context)
              .fetchExpenseListsOfUser();
        },
        child: Stack(
          children: [
            GridView.count(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: (192.0 / 234.0),
              children: [
                for (var list in state) ExpenseListCard(list: list),
                if (state.isEmpty) Container()
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewListPage()))
                },
                backgroundColor: Theme.of(context).primaryColor,
                shape: CircleBorder(),
                child: const Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

class ExpenseListCard extends StatelessWidget {
  const ExpenseListCard({super.key, required this.list});

  final ExpenseListWrapperState list;

  void selectNewList(BuildContext context, ExpenseListWrapperState state) {
    BlocProvider.of<NavigationCubit>(context).setNavBarItem(1);
    BlocProvider.of<SelectedExpenseListCubit>(context).selectNewList(state);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => {selectNewList(context, list)},
            child: Container(
              decoration: BoxDecoration(
                color: Color(list.expenseList.color),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  list.expenseList.emoji,
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
            list.expenseList.title,
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: -.5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
              "${CurrencyMapper.getSymbol(list.expenseList.currency)}${list.expenseList.totalCost.toStringAsFixed(2)}"),
        ),
      ],
    );
  }
}
