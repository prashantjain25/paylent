import 'package:paylent/models/transaction_category.dart';

class Transaction {
  final String id;
  final String groupId;
  final String title;
  final double amount;
  final DateTime date;
  final String paidByContactId;
  final String currency;
  final TransactionCategory category;

  Transaction({
    required this.category,
    required this.id,
    required this.groupId,
    required this.title,
    required this.amount,
    required this.date,
    required this.paidByContactId,
    required this.currency,
  });
}
