import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/transaction_category.dart';
import 'package:paylent/models/transaction_model.dart';

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<Transaction>>(
  (final ref) => TransactionsNotifier(),
);

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  TransactionsNotifier() : super(_initialTransactions);

  static final _initialTransactions = <Transaction>[
    Transaction(
      id: 't1',
      groupId: 'g1',
      title: 'Rent',
      amount: 1000,
      date: DateTime(2025, 11, 25),
      category: TransactionCategory.rent,
      paidByContactId: '1',
      currency: 'USD',
    ),
    Transaction(
      id: 't2',
      groupId: 'g1',
      title: 'Groceries',
      amount: 250,
      date: DateTime(2025, 11, 28),
      category: TransactionCategory.fastFood,
      paidByContactId: '2',
      currency: 'USD',
    ),
    Transaction(
      id: 't3',
      groupId: 'g2',
      title: 'Hotel',
      amount: 5000.0,
      date: DateTime(2025, 11, 25),
      category: TransactionCategory.hotels,
      paidByContactId: '3',
      currency: 'USD',
    ),
    Transaction(
      id: 't4',
      groupId: 'g2',
      title: 'Rent a Car',
      category: TransactionCategory.taxi,
      amount: 2500,
      date: DateTime(2025, 11, 21),
      paidByContactId: '1',
      currency: 'USD',
    ),
  ];

  List<Transaction> byGroup(final String groupId) =>
      state.where((final t) => t.groupId == groupId).toList();

  void add(final Transaction tx) {
    state = [...state, tx];
  }

  void remove(final String transactionId) {
    state = state
        .where((final tx) => tx.id != transactionId)
        .toList();
  }

  /// Optional: update transaction
  void update(final Transaction updated) {
    state = [
      for (final tx in state)
        if (tx.id == updated.id) updated else tx,
    ];
  }
}
