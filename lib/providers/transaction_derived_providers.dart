import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/providers/transactions_provider.dart';

final groupTotalAmountProvider =
    Provider.family<double, String>((final ref, final groupId) {
  final transactions = ref.watch(transactionsProvider);

  return transactions
      .where((final tx) => tx.groupId == groupId)
      .fold<double>(0.0, (final sum, final tx) => sum + tx.amount);
});
