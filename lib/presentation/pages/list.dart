import 'package:equaly/logic/app_bar/app_bar_cubit.dart';
import 'package:equaly/logic/auth/auth_cubit.dart';
import 'package:equaly/logic/list/expense_list_compensation_state.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/logic/list/expense_list_share_state.dart';
import 'package:equaly/logic/list/expense_list_wrapper_state.dart';
import 'package:equaly/presentation/components/list/compensations_table.dart';
import 'package:equaly/presentation/components/list/expenses_table.dart';
import 'package:equaly/presentation/components/list/shares_table.dart';
import 'package:equaly/presentation/modals/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, GoogleSignInAccount?>(
        builder: (context, account) {
      return RefreshIndicator(
        onRefresh: () {
          return BlocProvider.of<ExpenseListCubit>(context)
              .fetchExpenseListsOfUser(account);
        },
        child: BlocBuilder<SelectedExpenseListCubit, ExpenseListWrapperState?>(
            builder: (context, list) {
          if (list == null) return Text("Select a list first");
          BlocProvider.of<AppBarCubit>(context)
              .setTitle('${list.expenseList.emoji} ${list.expenseList.title}');
          return Stack(children: [
            ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [ExpenseList(wrapper: list)]),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return NewExpenseModal(list: list.expenseList);
                    },
                  )
                },
                backgroundColor: Theme.of(context).primaryColor,
                shape: CircleBorder(),
                child: const Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                ),
              ),
            )
          ]);
        }),
      );
    });
  }
}

class ExpenseList extends StatelessWidget {
  final ExpenseListWrapperState wrapper;
  final ExpenseListState list;
  final List<ExpenseListCompensationState> compensations;
  final List<ExpenseListShareState> shares;

  ExpenseList({super.key, required this.wrapper})
      : compensations = wrapper.compensations,
        shares = wrapper.shares,
        list = wrapper.expenseList;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AUSGABEN", style: theme.textTheme.titleSmall),
        SizedBox(
          height: 8,
        ),
        ExpensesTable(list: list),
        SizedBox(
          height: 16,
        ),
        Text("ANTEILE", style: theme.textTheme.titleSmall),
        SizedBox(
          height: 8,
        ),
        SharesTable(shares: shares, list: list),
        SizedBox(
          height: 16,
        ),
        Text("VORGESCHLAGENER AUSGLEICH", style: theme.textTheme.titleSmall),
        SizedBox(
          height: 8,
        ),
        CompensationsTable(
          compensations: compensations,
          list: list,
        )
      ],
    );
  }
}
