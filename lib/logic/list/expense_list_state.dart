part of 'expense_list_cubit.dart';

class ExpenseListState extends Equatable {
  final String title;
  final String id;
  final num totalCost;
  final String emoji;
  final int color;
  final List<ExpenseState> expenses;
  final String currency;
  final String creatorId;
  final List<ParticipantState> participants;

  const ExpenseListState({
    required this.id,
    required this.title,
    required this.creatorId,
    required this.totalCost,
    required this.emoji,
    required this.color,
    required this.expenses,
    required this.currency,
    required this.participants,
  });

  @override
  List<Object?> get props => [title, totalCost, emoji];

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color.toString(),
        'emoji': emoji,
        'title': title,
        'totalCost': totalCost,
        'creatorId': creatorId,
        'currency': currency,
        'expenses': expenses.map((e) => e.toJson()).toList(),
        'participants': participants.map((p) => p.toJson()).toList(),
      };

  factory ExpenseListState.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'color': String color,
        'emoji': String emoji,
        'title': String title,
        'totalCost': num totalCost,
        'creatorId': String creatorId,
        'currency': String currency,
        'expenses': List<dynamic> expenses,
        'participants': List<dynamic> participants
      } =>
        ExpenseListState(
          id: id,
          color: int.parse(color),
          creatorId: creatorId,
          emoji: emoji,
          title: title,
          totalCost: totalCost,
          currency: currency,
          expenses: List<ExpenseState>.from(
              expenses.map((item) => ExpenseState.fromJson(item))),
          participants: List<ParticipantState>.from(
              participants.map((item) => ParticipantState.fromJson(item))),
        ),
      _ => throw const FormatException("Failed to load Expense List from Json"),
    };
  }
}
