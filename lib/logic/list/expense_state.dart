class ExpenseState {
  final String buyer;
  final num amount;
  final String description;
  final List<String> participants;

  const ExpenseState({
    required this.buyer,
    required this.amount,
    required this.description,
    required this.participants,
  });

  Map<String, dynamic> toJson() => {

    'buyer': buyer,
    'amount': amount,
    'description': description,
    'participants': participants,
  };

  factory ExpenseState.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'buyer': String buyer,
      'amount': num amount,
      'description': String description,
      'participants': String participants,
      } =>
          ExpenseState(
              buyer: buyer,
              amount: amount,
              description: description,
              participants: participants.split(',')),
      _ => throw const FormatException("Failed to load Expense from Json"),
    };
  }
}
