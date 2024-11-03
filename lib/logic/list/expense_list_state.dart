part of 'expense_list_cubit.dart';

class ExpenseListState extends Equatable {
  final String title;
  final String id;
  final num totalCost;
  final String emoji;
  final int color;
  final List<Expense> expenses;
  final String currency;

  const ExpenseListState(
      {required this.id,
      required this.title,
      required this.totalCost,
      required this.emoji,
      required this.color,
      required this.expenses,
      required this.currency});

  @override
  List<Object?> get props => [title, totalCost, emoji];

  factory ExpenseListState.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'color': String color,
        'emoji': String emoji,
        'title': String title,
        'totalCost': num totalCost,
        'currency': String currency,
        'expenses': List<dynamic> expenses
      } =>
        ExpenseListState(
            id: id,
            color: int.parse(color),
            emoji: emoji,
            title: title,
            totalCost: totalCost,
            currency: currency,
            expenses: List<Expense>.from(
                expenses.map((item) => Expense.fromJson(item)))),
      _ => throw const FormatException("Failed to load Expense List"),
    };
  }
}

class Expense {
  final String buyer;
  final num amount;
  final String description;
  final List<String> participants;

  const Expense({
    required this.buyer,
    required this.amount,
    required this.description,
    required this.participants,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'buyer': String buyer,
        'amount': num amount,
        'description': String description,
        'participants': String participants,
      } =>
        Expense(
            buyer: buyer,
            amount: amount,
            description: description,
            participants: participants.split(',')),
      _ => throw const FormatException("Failed to load Expense List"),
    };
  }
}
