import 'dart:convert';

import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/presentation/components/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../logic/list/expense_state.dart';
import '../../logic/utils/snack_bar.dart';

class NewExpenseModal extends StatefulWidget {
  const NewExpenseModal({super.key, required this.list});

  final ExpenseListState list;

  @override
  State<NewExpenseModal> createState() => _NewExpenseModalState();
}

class _NewExpenseModalState extends State<NewExpenseModal> {
  var listTitle = TextEditingController();
  String? buyer;
  List<String> checkedParticipants = [];

  Future<void> createExpense(String buyer, double amount, String description,
      List<String> participants, DateTime date) async {
    try {
      var expenseList = ExpenseState(
          buyer: buyer,
          amount: amount,
          description: description,
          participants: participants,
          date: date,
          id: '',
          expenseListId: widget.list.id);

      var jsonEncoded = jsonEncode(expenseList.toJson());
      print(jsonEncoded);
      final response = await http.post(
          Uri.http('192.168.188.40:3000', '/v1/expense'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncoded);

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode} ${response.body}");
      }
      if (navigatorKey.currentContext != null) {
        Navigator.pop(navigatorKey.currentContext!);
      }
    } on http.ClientException catch (e) {
      showSnackBarWithException("Connection Timeout");
    } on Exception catch (exception) {
      showSnackBarWithException(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "NEUE AUSGABE",
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            Text(
              "Käufer",
              style: theme.textTheme.labelMedium,
            ),
            SizedBox(height: 4),
            DropdownButtonFormField(
                items: [
                  for (var participant in widget.list.participants)
                    DropdownMenuItem(
                        value: participant.id,
                        child: UserProfile(
                          avatarUrl: participant.avatarUrl,
                          name: participant.name,
                        )),
                ],
                onChanged: (value) {
                  setState(() {
                    buyer = value;
                  });
                }),
            SizedBox(height: 16),
            Text(
              "Beschreibung",
              style: theme.textTheme.labelMedium,
            ),
            SizedBox(height: 4),
            TextField(
              controller: listTitle,
              decoration: InputDecoration(
                hintText: "Supermark, Tanken...",
              ),
            ),
            SizedBox(height: 16),
            SizedBox(height: 16),
            Text(
              'Teilnehmer',
              style: theme.textTheme.labelMedium,
            ),
            Wrap(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 42,
                runSpacing: 6,
                children: [
                  for (var participant in widget.list.participants)
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            if (checkedParticipants.contains(participant.id)) {
                              checkedParticipants.remove(participant.id);
                            } else {
                              checkedParticipants.add(participant.id);
                            }
                          });
                        },
                        child: UserProfile(
                          avatarUrl: participant.avatarUrl,
                          name: participant.name,
                          checked: checkedParticipants.contains(participant.id),
                        ))
                ]),
            SizedBox(
              height: 96,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      createExpense(buyer!, 10, listTitle.text,
                          checkedParticipants, DateTime.now());
                    },
                    style: theme.filledButtonTheme.style,
                    child: Text(
                      "Hinzufügen",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
