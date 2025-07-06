import 'dart:convert';
import 'dart:ui';

import 'package:equaly/logic/auth/auth_cubit.dart';
import 'package:equaly/logic/config.dart';
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
  final SelectedExpenseListCubit selectedCubit;

  ExpenseListCubit(this.authCubit, this.selectedCubit) : super([]) {
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
          Uri.https(AppConfig.hostUrl, '/v1/expense-lists'),
          headers: {"Authorization": "Bearer ${auth.idToken}"});
      if (response.statusCode != 200) {
        throw Exception("${response.statusCode} ${response.body}");
      }
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<ExpenseListWrapperState> expenseLists = [];
      for (var entry in jsonData) {
        var expenseList =
            ExpenseListWrapperState.fromJson(entry as Map<String, dynamic>);
        for (var participant in expenseList.expenseList.participants) {
          participant.avatarUrl = await getPresignedProfilePicture(
              expenseList.expenseList.id, participant.id);
        }
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
          participants: participants);

      var auth = await user.authentication;
      var jsonEncoded = jsonEncode(expenseList.toJson());
      final response = await http.post(
          Uri.https(AppConfig.hostUrl, '/v1/expense-list'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${auth.idToken}"
          },
          body: jsonEncoded);

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode} ${response.body}");
      }

      final json = jsonDecode(utf8.decode(response.bodyBytes));
      var resExpenseList =
          ExpenseListWrapperState.fromJson(json as Map<String, dynamic>);

      for (var participant in participants) {
        await uploadProfilePicture(resExpenseList.expenseList.id, participant);
      }
      for (var participant in resExpenseList.expenseList.participants) {
        participant.avatarUrl = await getPresignedProfilePicture(
            resExpenseList.expenseList.id, participant.id);
      }

      emit([...state, resExpenseList]);

      return true;
    } on http.ClientException catch (_) {
      showSnackBarWithException("Connection Timeout");
      return false;
    } on Exception catch (exception) {
      showSnackBarWithException(exception.toString());
      return false;
    }
  }

  Future<bool> uploadProfilePicture(
      String expenseListId, ParticipantState participant) async {
    final user = authCubit.state;

    if (user == null) {
      showSnackBarWithException("User not logged in");
      return false;
    }

    try {
      var auth = await user.authentication;
      final request = http.MultipartRequest(
        'POST',
        Uri.https(AppConfig.hostUrl,
            '/v1/static/profile/$expenseListId/${participant.id}'),
      );
      request.headers.addAll({"Authorization": "Bearer ${auth.idToken}"});

      var file =
          await http.MultipartFile.fromPath('image', participant.avatarUrl);
      request.files.add(file);

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode}");
      }
      return true;
    } on http.ClientException catch (_) {
      showSnackBarWithException("Connection Timeout");
      return false;
    } on Exception catch (exception) {
      showSnackBarWithException(
          "$exception Failed to upload profile of ${participant.name}");
      return false;
    }
  }

  Future<String> getPresignedProfilePicture(
      String expenseListId, String participantId) async {
    final user = authCubit.state;

    if (user == null) {
      showSnackBarWithException("User not logged in");
      return "";
    }

    try {
      var auth = await user.authentication;
      final presignUrl = Uri.https(AppConfig.hostUrl,
          "/v1/static/profile/$expenseListId/$participantId");
      final response = await http.get(presignUrl,
          headers: {"Authorization": "Bearer ${auth.idToken}"});

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode}");
      }
      return response.body;
    } on http.ClientException catch (_) {
      showSnackBarWithException("Connection Timeout");
      return "";
    } on Exception catch (exception) {
      showSnackBarWithException(exception.toString());
      return "";
    }
  }

  Future<bool> createExpense(String buyer, double amount, String description,
      List<String> participants, DateTime date, String listId) async {
    try {
      final user = authCubit.state;

      if (user == null) {
        showSnackBarWithException("User not logged in");
        return false;
      }

      var expenseList = ExpenseState(
          buyer: buyer,
          amount: amount,
          description: description,
          participants: participants,
          date: date,
          id: '',
          expenseListId: listId);

      var auth = await user.authentication;

      var jsonEncoded = jsonEncode(expenseList.toJson());
      final response = await http.post(
          Uri.https(AppConfig.hostUrl, '/v1/expense'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${auth.idToken}"
          },
          body: jsonEncoded);

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode} ${response.body}");
      }

      final json = jsonDecode(utf8.decode(response.bodyBytes));
      var resExpenseList =
          ExpenseListWrapperState.fromJson(json as Map<String, dynamic>);
      var index = state.indexWhere((list) => list.expenseList.id == listId);
      for (var participant in resExpenseList.expenseList.participants) {
        var other = state[index]
            .expenseList
            .participants
            .indexWhere((p) => p.id == participant.id);
        participant.avatarUrl =
            state[index].expenseList.participants[other].avatarUrl;
      }

      state[index] = resExpenseList;
      emit(state);
      selectedCubit.selectNewList(resExpenseList);

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
