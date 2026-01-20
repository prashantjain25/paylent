class Transaction {
  final String id;
  final String groupId;
  final String title;
  final double amount;
  final DateTime date;
  final String paidByContactId;
  final String currency;

  Transaction({
    required this.id,
    required this.groupId,
    required this.title,
    required this.amount,
    required this.date,
    required this.paidByContactId,
    required this.currency,
  });
}
