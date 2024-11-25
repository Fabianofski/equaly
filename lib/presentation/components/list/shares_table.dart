import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equaly/logic/currency_mapper.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/logic/list/expense_list_share_state.dart';
import 'package:equaly/presentation/components/user_profile.dart';
import 'package:flutter/material.dart';

class SharesTable extends StatelessWidget {
  final List<ExpenseListShareState> shares;
  final ExpenseListState list;

  const SharesTable({super.key, required this.shares, required this.list});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SingleChildScrollView(
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
            label: SizedBox(
              width: 120,
              child: Text(
                "Teilnehmer",
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 64,
              child: Text(
                "Betrag",
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 64,
              child: Text(
                "Anteil",
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 64,
              child: Text(
                "Differenz",
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
        ],
        rows: [
          for (var share in shares)
            DataRow(
              cells: [
                DataCell(
                  Builder(
                    builder: (context) {
                      var participant = list.participants
                          .firstWhereOrNull((x) => x.id == share.participantId);
                      return UserProfile(
                        avatarUrl: participant?.avatarUrl,
                        name: participant?.name ?? "Name",
                      );
                    },
                  ),
                ),
                DataCell(Text(
                  "${CurrencyMapper.getSymbol(list.currency)}${share.expenseAmount.toStringAsFixed(2)}",
                  style: theme.textTheme.titleSmall,
                )),
                DataCell(Text(
                  "${CurrencyMapper.getSymbol(list.currency)}${share.share.toStringAsFixed(2)}",
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                )),
                DataCell(Text(
                  "${CurrencyMapper.getSymbol(list.currency)}${share.difference.toStringAsFixed(2)}",
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                )),
              ],
            ),
          for (var i = 0; i < max(0, 2 - shares.length); i++)
            DataRow(cells: List.generate(4, (index) => DataCell(Container()))),
        ],
      ),
    );
  }
}
