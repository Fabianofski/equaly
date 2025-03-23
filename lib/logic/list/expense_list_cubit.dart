import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:equaly/logic/auth/auth_cubit.dart';
import 'package:equaly/logic/list/expense_list_wrapper_state.dart';
import 'package:equaly/logic/list/participant_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../utils/snack_bar.dart';
import 'expense_state.dart';

part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<List<ExpenseListWrapperState>> {
  final AuthCubit authCubit;

  ExpenseListCubit(this.authCubit) : super([]) {
    init();
  }

  Future<void> init() async {
    await authCubit.signInSilently();
    fetchExpenseListsOfUser();
  }

  Future<void> fetchExpenseListsOfUser() async {
    final user = authCubit.state;

    emit([]);
    if (user == null) {
      showSnackBarWithException("User is not logged in");
      return Future.value();
    }

    try {
      GoogleSignInAuthentication auth = await user.authentication;
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

  Future<bool> createExpenseList(String title, Color color, String emoji,
      String currency, List<ParticipantState> participants) async {
    final user = authCubit.state;

    if (user == null) {
      showSnackBarWithException("User not logged in");
      return false;
    }

    try {
      var expenseList = ExpenseListState(
        id: "",
        title: title,
        totalCost: 0,
        creatorId: user.id,
        emoji: emoji,
        color: color.value,
        expenses: [],
        currency: currency,
        participants: participants,
      );

      var auth = await user.authentication;
      var jsonEncoded = jsonEncode(expenseList.toJson());
      final response = await http.post(
          Uri.http('192.168.188.40:3000', '/v1/expense-list'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${auth.idToken}"
          },
          body: jsonEncoded);

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode} ${response.body}");
      }
      return true;
    } on http.ClientException catch (_) {
      showSnackBarWithException("Connection Timeout");
      return false;
    } on Exception catch (exception) {
      showSnackBarWithException(exception.toString());
      return false;
    }
  }
}

class SelectedExpenseListCubit extends Cubit<ExpenseListWrapperState?> {
  SelectedExpenseListCubit(super.state);

  void selectNewList(ExpenseListWrapperState newState) {
    emit(newState);
  }
}
