import 'package:equaly/logic/app_bar/app_bar_cubit.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/presentation/components/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

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
        SizedBox(
          height: 8,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            horizontalMargin: 15,
            columnSpacing: 20,
            headingRowHeight: 40,
            dataRowMaxHeight: 50,
            dataRowMinHeight: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Color(0x8815376A)),
            ),
            columns: [
              DataColumn(
                label: Text(
                  "KÄUFER",
                  style: theme.textTheme.titleSmall,
                ),
              ),
              DataColumn(
                label: Text(
                  "BETRAG",
                  style: theme.textTheme.titleSmall,
                ),
              ),
              DataColumn(
                label: Text(
                  "BESCHREIBUNG",
                  style: theme.textTheme.titleSmall,
                ),
              ),
              DataColumn(
                label: Text(
                  "TEILNEHMER",
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
            rows: [
              for (var expense in list.expenses)
                DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: Builder(
                          builder: (context) {
                            var participant = list.participants
                                .firstWhereOrNull((x) => x.id == expense.buyer);
                            return UserProfile(
                              avatarUrl: participant?.avatarUrl,
                              name: participant?.name ?? "Name",
                              subtitle: DateFormat('dd.MM.yyyy').format(expense.date),
                            );
                          },
                        ),
                      ),
                    ),
                    DataCell(Text(
                      "${list.currency}${expense.amount.toStringAsFixed(2)}",
                      style: theme.textTheme.titleSmall,
                    )),
                    DataCell(Text(
                      expense.description,
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    )),
                    DataCell(
                      Row(
                        children: [
                          for (var pid in expense.participants)
                            UserProfile(avatarUrl: list.participants.firstWhereOrNull((p) => p.id == pid)?.avatarUrl,)
                        ],
                      ),
                        ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
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
        SizedBox(
          height: 16,
        ),
        Text("ANTEILE", style: theme.textTheme.titleSmall),
        SizedBox(
          height: 16,
        ),
        Text("VORGESCHLAGENER AUSGLEICH", style: theme.textTheme.titleSmall),
      ],
    );
  }
}
