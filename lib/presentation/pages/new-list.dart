import 'dart:convert';

import 'package:equaly/logic/list/expense_list_cubit.dart';
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

  static Color generateColor(int index) {
    final hue = (index * 18) % 360;
    final saturation = 0.34;
    final brightness = 0.87;

    return HSVColor.fromAHSV(1.0, hue.toDouble(), saturation, brightness)
        .toColor();
  }

  Future<void> createExpenseList(
      String title, Color color, String currency) async {
    var expenseList = ExpenseListState(
      id: "",
      title: title,
      totalCost: 0,
      creatorId: "user-001",
      emoji: "🔧",
      color: color.value,
      expenses: [],
      currency: currency,
    );

    var jsonEncoded = jsonEncode(expenseList.toJson());
    final response = await http.post(
        Uri.http('192.168.188.40:3000', '/v1/expense-list'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncoded);

    if (response.statusCode != 200) {
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
                TextField(
                  controller: listTitle,
                  decoration: InputDecoration(
                    labelText: 'Listentitel',
                    hintText: "Titel",
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: 'EUR',
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
                  onChanged: (value) {},
                  decoration: InputDecoration(labelText: 'Hauptwährung'),
                ),
                SizedBox(height: 16),
                Text('Cover Farbe'),
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
                Text('Teilnehmer'),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Wilhelm'),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Tanisha'),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Margot'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Teilnehmer hinzufügen'),
                ),
              ],
            ),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    createExpenseList(listTitle.text, selectedColor, "\$");
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
