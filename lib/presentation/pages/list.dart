import 'package:equaly/logic/app_bar/app_bar_cubit.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          BlocProvider.of<ExpenseListCubit>(context).fetchExpenseListsOfUser,
      child: Stack(children: [
        ListView(physics: AlwaysScrollableScrollPhysics(), children: [
          BlocBuilder<SelectedExpenseListCubit, ExpenseListState?>(
              builder: (context, list) {
            if (list == null) return Text("Select a list first");

            BlocProvider.of<AppBarCubit>(context)
                .setTitle('${list.emoji} ${list.title}');
            return ExpenseList(list: list);
          }),
        ]),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () => {},
            backgroundColor: Theme.of(context).primaryColor,
            shape: CircleBorder(),
            child: const Icon(
              FontAwesomeIcons.plus,
              color: Colors.white,
            ),
          ),
        )
      ]),
    );
  }
}

class ExpenseList extends StatelessWidget {
  final ExpenseListState list;

  const ExpenseList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AUSGABEN", style: theme.textTheme.titleSmall),
        Table(
          border: TableBorder.symmetric(),
          columnWidths: {
            0: FlexColumnWidth(),
            1: FixedColumnWidth(80),
            2: FixedColumnWidth(130),
            3: FlexColumnWidth()
          },

          children: [
            TableRow(children: [
              TableCell(
                  child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                child: Text("KÄUFER", style: theme.textTheme.titleSmall),
              )),
              TableCell(
                  child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text("BETRAG", style: theme.textTheme.titleSmall),
              )),
              TableCell(
                  child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "BESCHREIBUNG",
                  style: theme.textTheme.titleSmall?.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              )),
              TableCell(
                child: Text("TEILNEHMER", style: theme.textTheme.titleSmall),
              ),
            ]),
            for (var expense in list.expenses)
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TableCell(child: Text(expense.buyer)),
                ),
                TableCell(
                    child: Text(
                  "${list.currency}${expense.amount.toStringAsFixed(2)}",
                  style: theme.textTheme.titleSmall,
                )),
                TableCell(
                    child: Text(expense.description,
                        style: TextStyle(overflow: TextOverflow.ellipsis))),
                TableCell(
                    child: Text(
                  expense.participants.join(','),
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                )),
              ]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: theme.textTheme.bodySmall,
            ),
            Text(
              "${list.currency}${list.totalCost.toStringAsFixed(2)}",
              style: theme.textTheme.titleSmall,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total p.P.",
              style: theme.textTheme.bodySmall,
            ),
            Text(
              "${list.currency}${(list.totalCost / 6).toStringAsFixed(2)}",
              style: theme.textTheme.titleSmall,
            )
          ],
        ),
        Text("ANTEILE", style: theme.textTheme.titleSmall),
        Text("VORGESCHLAGENER AUSGLEICH", style: theme.textTheme.titleSmall),
      ],
    );
  }
}
