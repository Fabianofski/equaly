class ExpenseListCompensationState {
  final String from;
  final String to;
  final double amount;

  ExpenseListCompensationState({
    required this.from,
    required this.to,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "amount": amount,
      };

  factory ExpenseListCompensationState.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'from': String from,
        'to': String to,
        'amount': num amount,
      } =>
        ExpenseListCompensationState(
            from: from, to: to, amount: amount.toDouble()),
      _ => throw const FormatException(
          "Failed to load ExpenseListCompensation from Json"),
    };
  }
}
