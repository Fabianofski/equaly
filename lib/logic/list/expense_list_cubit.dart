import 'dart:convert';
import 'dart:developer';

import 'package:equaly/logic/list/expense_list_wrapper_state.dart';
import 'package:equaly/logic/list/participant_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../utils/snack_bar.dart';
import 'expense_state.dart';

part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<List<ExpenseListWrapperState>> {
  ExpenseListCubit() : super([]);

  Future<void> fetchExpenseListsOfUser(GoogleSignInAccount? user) async {
    emit([]);
    if (user == null) {
      showSnackBarWithException("User is not logged in");
      return Future.value();
    }

    try {
      GoogleSignInAuthentication auth = await user.authentication;
      log("Signed in with: ${user.displayName}");
      final response = await http.get(
          Uri.http('192.168.188.40:3000', '/v1/expense-lists'),
          headers: {"Authorization": "Bearer ${auth.idToken}"});
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
