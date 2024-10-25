import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.selectNewList});

  final ValueChanged<String> selectNewList;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: (192.0 / 234.0),
      children: [
        ExpenseListCard(
            color: 0x883AC828,
            emoji: '⛰️',
            title: 'Harz Wernigerode 2024',
            cost: '€2.340',
            selectNewList: selectNewList),
        ExpenseListCard(
            color: 0x88E2D66A,
            emoji: '🏞️',
            title: 'Kanuausflug Schweden',
            cost: '€1.365',
            selectNewList: selectNewList),
        ExpenseListCard(
            color: 0x8815376A,
            emoji: '🎿',
            title: 'Skiausflug 2025',
            cost: '€4.500,20',
            selectNewList: selectNewList),
      ],
    );
  }
}

class ExpenseListCard extends StatelessWidget {
  const ExpenseListCard(
      {super.key,
      required this.color,
      required this.emoji,
      required this.title,
      required this.cost,
      required this.selectNewList});

  final int color;
  final String emoji;
  final String title;
  final String cost;

  final ValueChanged<String> selectNewList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => {selectNewList(title)},
            child: Container(
              decoration: BoxDecoration(
                color: Color(color),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 86),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: -.5,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(cost),
        ),
      ],
    );
  }
}
