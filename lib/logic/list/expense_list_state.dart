part of 'expense_list_cubit.dart';

class ExpenseListState extends Equatable {
  final String title;
  final String id;
  final String totalCost;
  final String emoji;
  final int color;
  final List<Expense> expenses;

  const ExpenseListState({required this.id,
    required this.title,
    required this.totalCost,
    required this.emoji,
    required this.color,
    required this.expenses});

  @override
  List<Object?> get props => [title, totalCost, emoji];

  factory ExpenseListState.fromJson(Map<String, dynamic> json) {
    print(json);
    return switch (json) {
      {
      'id': String id,
      'color': String color,
      'emoji': String emoji,
      'title': String title,
      'totalCost': num totalCost
      } => ExpenseListState(id: id,
          color: int.parse(color),
          emoji: emoji,
          title: title,
          totalCost: "€$totalCost",
          expenses: []),
      _ => throw const FormatException("Failed to load Expense List"),
    };
  }
}

class Expense {
  final String buyer;
  final double amount;
  final String description;
  final List<String> participants;

  const Expense({
    required this.buyer,
    required this.amount,
    required this.description,
    required this.participants,
  });
}
