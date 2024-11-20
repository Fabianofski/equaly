class ExpenseState {
  final String id;
  final String expenseListId;
  final String buyer;
  final num amount;
  final String description;
  final List<String> participants;
  final DateTime date;

  const ExpenseState({
    required this.buyer,
    required this.amount,
    required this.description,
    required this.participants,
    required this.date,
    required this.id,
    required this.expenseListId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'expenseListId': expenseListId,
        'buyer': buyer,
        'amount': amount,
        'description': description,
        'participants': participants.join(','),
        'date': '${date.toUtc().toIso8601String().split('.')[0]}Z',
      };

  factory ExpenseState.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'expenseListId': String expenseListId,
        'buyer': String buyer,
        'amount': num amount,
        'description': String description,
        'participants': String participants,
        'date': String date,
      } =>
        ExpenseState(
          id: id,
          expenseListId: expenseListId,
          buyer: buyer,
          amount: amount,
          description: description,
          participants: participants.split(','),
          date: DateTime.parse(date),
        ),
      _ => throw const FormatException("Failed to load Expense from Json"),
    };
  }
}
