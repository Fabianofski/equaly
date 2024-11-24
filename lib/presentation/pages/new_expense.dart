import 'dart:async';
import 'dart:convert';

import 'package:equaly/logic/currency_mapper.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/presentation/components/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  var amount = TextEditingController();
  var converted = 0.0;
  Timer? debounce;
  String? buyer;
  String currency = "";
  DateTime date = DateTime.now();
  List<String> checkedParticipants = [];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1999),
      lastDate: DateTime(2099),
      helpText: "Datum wählen"
    );
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  void convertCurrency(String value) {
    setState(() {
      if (value.isEmpty) {
        converted = 0;
      } else {
        converted = CurrencyMapper.convertToMainCurrency(
            double.parse(value), currency, widget.list.currency);
      }
    });
  }

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
  void initState() {
    checkedParticipants = widget.list.participants.map((p) => p.id).toList();
    buyer = widget.list.participants.firstOrNull?.id;
    currency = widget.list.currency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
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
              Row(
                children: [
                  DropdownButton(
                      value: currency,
                      items: [
                        for (var currency
                            in CurrencyMapper.getAllCurrencies().entries)
                          DropdownMenuItem(
                              value: currency.key,
                              child: Text(
                                currency.value,
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(fontSize: 32),
                              )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          currency = value!;
                        });
                        convertCurrency(amount.text);
                      }),
                  const SizedBox(width: 4),
                  IntrinsicWidth(
                    child: TextField(
                      controller: amount,
                      onChanged: convertCurrency,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.bottom,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 32,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        filled: false,
                        isDense: true,
                        hintText: amount.text.isEmpty ? '00.00' : '',
                        hintStyle: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 32,
                          color: Colors.grey[600],
                        ),
                      ),
                      inputFormatters: [CurrencyInputFormatter()],
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (currency != widget.list.currency)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "(${CurrencyMapper.getSymbol(widget.list.currency)}${converted.toStringAsFixed(2)})",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                "Datum",
                style: theme.textTheme.labelMedium,
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  await selectDate(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd.MM.yyyy').format(date),
                          style: theme.inputDecorationTheme.labelStyle,
                        ),
                        Icon(FontAwesomeIcons.solidCalendarDays),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Käufer",
                style: theme.textTheme.labelMedium,
              ),
              SizedBox(height: 4),
              DropdownButtonFormField(
                  value: buyer,
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
                  hintText: "Supermarkt, Tanken...",
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Teilnehmer',
                style: theme.textTheme.labelMedium,
              ),
              SizedBox(height: 4),
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
                        createExpense(buyer!, converted, listTitle.text,
                            checkedParticipants, date);
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
      ),
    );
  }
}
