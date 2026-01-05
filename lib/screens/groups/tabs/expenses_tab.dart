import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylent/models/constants.dart';
import 'package:paylent/models/enums.dart';

class ExpensesTab extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const ExpensesTab({required this.transactions, super.key});

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  // Helper to safely get DateTime from either String or DateTime
  DateTime _getDateTime(final dynamic dateValue) {
    if (dateValue is DateTime) {
      return dateValue;
    }
    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        return DateTime(2025); // fallback for invalid dates
      }
    }
    return DateTime.now(); // ultimate fallback
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.transactions.isEmpty) {
      return const Center(
        child: Text(
          'No expenses yet',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Create a working copy and ensure dates are DateTime
    final List<Map<String, dynamic>> processedTransactions =
        processTransactions();

    // Sort descending: newest first
    sortTransactions(processedTransactions);

    // Group by month and year
    final Map<String, List<Map<String, dynamic>>> grouped =
        groupMap(processedTransactions);

    // Sort months descending (latest first)
    final List<String> sortedMonths = sortList(grouped);

    // Build flat list for ListView
    final List<dynamic> flatList = [];
    for (final month in sortedMonths) {
      flatList.add(month); // header
      flatList.addAll(grouped[month]!);
    }

    return Scrollbar(
      thumbVisibility: false,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
        itemCount: flatList.length,
        itemBuilder: (final context, final i) {
          final item = flatList[i];

          // Month Header
          if (item is String) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            );
          }

          // Expense Item
          final tx = item as Map<String, dynamic>;
          final isFirstInGroup = i > 0 && flatList[i - 1] is String;

          return Column(
            children: [
              if (!isFirstInGroup)
                const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color.fromARGB(59, 46, 46, 46)),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.receipt, color: Colors.white),
                ),
                title: Text(tx[TransactionKeys.title] ?? 'Untitled'),
                subtitle:
                    Text('Paid by ${tx[TransactionKeys.paidBy] ?? 'Unknown'}'),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${tx[TransactionKeys.code] ?? CurrencyType.USD.name} ${(tx[TransactionKeys.amount] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate((tx[TransactionKeys.date] as DateTime)
                          .toIso8601String()),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.addExpense,
                    arguments: {
                      'expense': tx,
                      'isEdit': true,
                    },
                  );

                  if (result == 'deleted') {
                    setState(() {
                      widget.transactions
                          // ignore: prefer_final_parameters
                          .removeWhere((e) => e['id'] == tx['id']);
                    });
                  } else if (result is Map<String, dynamic>) {
                    setState(() {
                      final index = widget.transactions.indexWhere(
                        (final e) => e['id'] == result['id'],
                      );
                      if (index != -1) {
                        widget.transactions[index] = result;
                      }
                    });
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------- helpers ----------

  List<Map<String, dynamic>> processTransactions() =>
      widget.transactions.map((final tx) {
        final copy = Map<String, dynamic>.from(tx);
        copy[TransactionKeys.date] = _getDateTime(copy[TransactionKeys.date]);
        return copy;
      }).toList();

  void sortTransactions(final List<Map<String, dynamic>> list) {
    list.sort((final a, final b) => (b[TransactionKeys.date] as DateTime)
        .compareTo(a[TransactionKeys.date] as DateTime));
  }

  Map<String, List<Map<String, dynamic>>> groupMap(
      final List<Map<String, dynamic>> list) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final tx in list) {
      final key =
          DateFormat('MMMM yyyy').format(tx[TransactionKeys.date] as DateTime);
      grouped.putIfAbsent(key, () => []).add(tx);
    }
    return grouped;
  }

  List<String> sortList(final Map<String, List<Map<String, dynamic>>> grouped) {
    final keys = grouped.keys.toList();
    keys.sort((final a, final b) => DateFormat('MMMM yyyy').parse(b).compareTo(
          DateFormat('MMMM yyyy').parse(a),
        ));
    return keys;
  }

  String formatDate(final String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${DateFormat('MMM').format(date)} ${date.day}';
    } catch (_) {
      return dateString;
    }
  }
}
