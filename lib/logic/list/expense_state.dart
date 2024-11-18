class ExpenseState {
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
  });

  Map<String, dynamic> toJson() => {
        'buyer': buyer,
        'amount': amount,
        'description': description,
        'participants': participants,
        'date': date
      };

  factory ExpenseState.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'buyer': String buyer,
        'amount': num amount,
        'description': String description,
        'participants': String participants,
        'date': String date,
      } =>
        ExpenseState(
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
