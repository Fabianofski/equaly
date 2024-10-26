part of 'expense_list_cubit.dart';

class ExpenseListState extends Equatable {
  final String title;
  final String id;
  final String totalCost;
  final String emoji;
  final int color;

  const ExpenseListState(
      {required this.id,
      required this.title,
      required this.totalCost,
      required this.emoji,
      required this.color});

  @override
  List<Object?> get props => [title, totalCost, emoji];
}
