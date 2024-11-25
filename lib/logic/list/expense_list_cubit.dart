import 'dart:convert';

import 'package:equaly/logic/list/expense_list_wrapper_state.dart';
import 'package:equaly/logic/list/participant_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../utils/snack_bar.dart';
import 'expense_state.dart';

part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<List<ExpenseListWrapperState>> {
  ExpenseListCubit() : super([]) {
    fetchExpenseListsOfUser();
  }

  Future<void> fetchExpenseListsOfUser() async {
    emit([]);
    try {
      final response = await http.get(Uri.http(
          '192.168.188.40:3000', '/v1/expense-lists', {"userId": "user-001"}));
      if (response.statusCode != 200) {
        throw Exception("${response.statusCode} ${response.body}");
      }
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<ExpenseListWrapperState> expenseLists = [];
      for (var entry in jsonData) {
        var expenseList =
            ExpenseListWrapperState.fromJson(entry as Map<String, dynamic>);
        expenseLists.add(expenseList);
      }
      emit(expenseLists);
    } on http.ClientException catch (_) {
      showSnackBarWithException("Connection Timeout");
    } on Exception catch (exception) {
      showSnackBarWithException(exception.toString());
    }
  }
}

class SelectedExpenseListCubit extends Cubit<ExpenseListWrapperState?> {
  SelectedExpenseListCubit(super.state);

  void selectNewList(ExpenseListWrapperState newState) {
    emit(newState);
  }
}
