import 'package:equaly/logic/list/expense_list_compensation_state.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/presentation/components/list/compensation.dart';
import 'package:flutter/material.dart';

class CompensationsTable extends StatelessWidget {
  final List<ExpenseListCompensationState> compensations;
  final ExpenseListState list;

  const CompensationsTable(
      {super.key, required this.compensations, required this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var compensation in compensations) ...[
          Compensation(
            list: list,
            compensation: compensation,
          ),
          SizedBox(
            height: 8,
          )
        ]
      ],
    );
  }
}
