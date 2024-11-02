import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<List<ExpenseListState>> {
  ExpenseListCubit() : super([]) {
    fetchExpenseListsOfUser();
  }

  void fetchExpenseListsOfUser() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/user-expense-lists'));
    if (response.statusCode != 200) {
      return;
    }

    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<ExpenseListState> expenseLists = [];
    for (var entry in jsonData) {
      var expenseList = ExpenseListState.fromJson(entry as Map<String, dynamic>);
      expenseLists.add(expenseList);
    }
    emit(expenseLists);
  }
}

class SelectedExpenseListCubit extends Cubit<ExpenseListState> {
  SelectedExpenseListCubit(super.state);

  void selectNewList(ExpenseListState newState) {
    emit(newState);
  }
}
