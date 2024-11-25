import 'package:equaly/logic/list/expense_list_compensation_state.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/logic/list/expense_list_share_state.dart';


class ExpenseListWrapperState {
  final ExpenseListState expenseList;
  final List<ExpenseListShareState> shares;
  final List<ExpenseListCompensationState> compensations;

  ExpenseListWrapperState({
    required this.expenseList,
    required this.shares,
    required this.compensations,
  });

  Map<String, dynamic> toJson() => {
    "expenseList": expenseList,
    "shares": shares.map((s) => s.toJson()).toList(),
    "compensations": compensations.map((c) => c.toJson()).toList(),
  };

  factory ExpenseListWrapperState.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'expenseList': Map<String, dynamic> expenseList,
      'shares': List<dynamic> shares,
      'compensations': List<dynamic> compensations,
      } =>
          ExpenseListWrapperState(
            expenseList: ExpenseListState.fromJson(expenseList),
            shares: shares
                .map((s) => ExpenseListShareState.fromJson(s))
                .toList(),
            compensations: compensations
                .map((c) => ExpenseListCompensationState.fromJson(c))
                .toList(),
          ),
      _ => throw const FormatException(
          "Failed to load ExpenseListWrapper from Json"),
    };
  }
}
