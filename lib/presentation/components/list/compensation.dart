import 'package:collection/collection.dart';
import 'package:equaly/logic/currency_mapper.dart';
import 'package:equaly/logic/list/expense_list_compensation_state.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/presentation/components/user_profile.dart';
import 'package:flutter/material.dart';

class Compensation extends StatelessWidget {
  final ExpenseListCompensationState compensation;
  final ExpenseListState list;

  const Compensation(
      {super.key, required this.compensation, required this.list});

  @override
  Widget build(BuildContext context) {
    var fromParticipant =
        list.participants.firstWhereOrNull((x) => x.id == compensation.from);
    var toParticipant =
        list.participants.firstWhereOrNull((x) => x.id == compensation.to);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserProfile(
          avatarUrl: fromParticipant?.avatarUrl,
          name: fromParticipant?.name,
        ),
        Text(
          "${CurrencyMapper.getSymbol(list.currency)}${compensation.amount.toStringAsFixed(2)}",
        ),
        UserProfile(
          avatarUrl: toParticipant?.avatarUrl,
          name: toParticipant?.name,
        )
      ],
    );
  }
}
