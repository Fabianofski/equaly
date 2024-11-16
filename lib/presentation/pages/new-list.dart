import 'dart:convert';
import 'dart:io';

import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/logic/list/participant_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewListPage extends StatefulWidget {
  const NewListPage({super.key});

  @override
  State<NewListPage> createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  var listTitle = TextEditingController();
  var selectedColor = generateColor(0);
  var participants = <ParticipantState>[];
  var currency = "EUR";

  static Color generateColor(int index) {
    final hue = (index * 18) % 360;
    final saturation = 0.34;
    final brightness = 0.87;

    return HSVColor.fromAHSV(1.0, hue.toDouble(), saturation, brightness)
        .toColor();
  }

  void showParticipantModal() {
    var theme = Theme.of(context);
    var participantName = TextEditingController();
    File? _profileImage;

    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {

                      },
                      child: Center(
                        child: CircleAvatar(
                          radius: 72,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: _profileImage == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.grey[700],
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Teilnehmer Name",
                      style: theme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 4),
                    TextField(
                      controller: participantName,
                      decoration: InputDecoration(
                        hintText: "Name",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (participantName.text.isEmpty) return;
                        setState(() {
                          participants.add(ParticipantState(
                              avatarUrl: "",
                              name: participantName.text,
                              id: ""));
                        });
                        Navigator.pop(context);
                      },
                      style: theme.filledButtonTheme.style,
                      child: Text(
                        "Teilnehmer hinzufügen",
                        style: theme.textTheme.labelLarge,
                      ),
                    ))
              ],
            ),
          );
        });
  }

  Future<void> createExpenseList(String title, Color color, String currency,
      List<ParticipantState> participants) async {
    var expenseList = ExpenseListState(
      id: "",
      title: title,
      totalCost: 0,
      creatorId: "user-001",
      emoji: "🔧",
      color: color.value,
      expenses: [],
      currency: currency,
      participants: participants,
    );

    var jsonEncoded = jsonEncode(expenseList.toJson());
    final response = await http.post(
        Uri.http('192.168.188.40:3000', '/v1/expense-list'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncoded);

    if (response.statusCode != 200) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text("${response.statusCode} ${response.body}"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Neue Liste",
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Listentitel",
                  style: theme.textTheme.labelMedium,
                ),
                SizedBox(height: 4),
                TextField(
                  controller: listTitle,
                  decoration: InputDecoration(
                    hintText: "Titel",
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Hauptwährung",
                  style: theme.textTheme.labelMedium,
                ),
                SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: currency,
                  items: [
                    DropdownMenuItem(
                        value: 'EUR',
                        child: Row(
                          children: [
                            Text(
                              '€',
                              style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'EUR',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        )),
                    DropdownMenuItem(
                        value: 'USD',
                        child: Row(
                          children: [
                            Text(
                              '\$',
                              style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'USD',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        )),
                  ],
                  onChanged: (value) {
                    currency = value!;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Cover Farbe',
                  style: theme.textTheme.labelMedium,
                ),
                SizedBox(height: 4),
                Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 8,
                  runSpacing: 6,
                  children: List.generate(20, (index) {
                    final color = generateColor(index);
                    final selected = selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                          border: selected
                              ? Border.all(width: 3, color: Colors.black)
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16),
                Text(
                  'Teilnehmer',
                  style: theme.textTheme.labelMedium,
                ),
                if (participants.isEmpty) SizedBox(height: 4),
                for (var participant in participants)
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(participant.name),
                  ),
                FilledButton(
                  onPressed: () {
                    showParticipantModal();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            color: theme.primaryColor, shape: BoxShape.circle),
                        child: Icon(
                          Icons.add,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Teilnehmer hinzufügen',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    createExpenseList(
                        listTitle.text, selectedColor, currency, participants);
                  },
                  style: theme.filledButtonTheme.style,
                  child: Text(
                    "Erstellen",
                    style: theme.textTheme.labelLarge,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
