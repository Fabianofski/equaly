class ExpenseListShareState {
  final String participantId;
  final int numberOfExpenses;
  final double expenseAmount;
  final double share;
  final double difference;

  ExpenseListShareState({
    required this.participantId,
    required this.numberOfExpenses,
    required this.expenseAmount,
    required this.share,
    required this.difference,
  });

  Map<String, dynamic> toJson() => {
    "id": participantId,
    "numberOfExpenses": numberOfExpenses,
    "expenseAmount": expenseAmount,
    "share": share,
    "difference": difference,
  };

  factory ExpenseListShareState.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': String participantId,
      'numberOfExpenses': int numberOfExpenses,
      'expenseAmount': num expenseAmount,
      'share': num share,
      'difference': num difference,
      } =>
          ExpenseListShareState(
            participantId: participantId,
            numberOfExpenses: numberOfExpenses,
            expenseAmount: expenseAmount.toDouble(),
            share: share.toDouble(),
            difference: difference.toDouble(),
          ),
      _ => throw const FormatException(
          "Failed to load ExpenseListShare from Json"),
    };
  }
}