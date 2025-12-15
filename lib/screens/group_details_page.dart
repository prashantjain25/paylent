import 'package:flutter/material.dart';

class GroupDetailsPage extends StatefulWidget {
  final Map<String, dynamic> group;
  const GroupDetailsPage({super.key, required this.group});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  late List<Map<String, dynamic>> transactions;
  late String groupTitle;
  final TextEditingController _amountController = TextEditingController();
  int _transactionCounter = 0;
  final int _defaultSplitCount = 4;

  @override
  void initState() {
    super.initState();
    groupTitle = widget.group['name'] as String? ?? 'Group';
    final originalTransactions  = List<Map<String, dynamic>>.from(
        widget.group['transactions'] as List? ?? []);

    // Initialize counter based on existing transactions
    transactions = originalTransactions.map((tx) {
  final Map<String, dynamic> updatedTx = Map<String, dynamic>.from(tx);

  // Set defaults if not already present
  updatedTx.putIfAbsent('splitBetween', () => _defaultSplitCount);

  // Calculate splitAmount only if it's missing and amount exists
  if (updatedTx['splitAmount'] == null && updatedTx['amount'] != null) {
    final num amount = updatedTx['amount'] as num;
    if (_defaultSplitCount > 0) {
      updatedTx['splitAmount'] = amount.toDouble() / _defaultSplitCount;
    } else {
      // Handle edge case: avoid division by zero
      updatedTx['splitAmount'] = amount.toDouble();
    }
  }

  return updatedTx;
}).toList();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _addTransaction() {
    final amountText = _amountController.text;
    if (amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null) return;

    // Calculate additional fields
    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Calculate tax (example: 10% tax)
    final tax = amount * 0.10;
    final totalAmount = amount + tax;

    // Calculate split amount (assuming 4 people)
    final splitBetween = 4;
    final splitAmount = totalAmount / splitBetween;

    // Determine who paid (rotate between people)
    final people = ['Alice', 'Bob', 'Charlie', 'Diana'];
    final payerIndex = transactions.length % people.length;

    setState(() {
      _transactionCounter++;
      transactions.add({
        'title': 'Transaction #$_transactionCounter',
        'amount': amount,
        'tax': tax,
        'totalAmount': totalAmount,
        'splitAmount': splitAmount,
        'date': formattedDate,
        'time':
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        'paidBy': people[payerIndex],
        'splitBetween': splitBetween,
        'originalAmount': amount,
      });

      // Clear the input
      _amountController.clear();
    });

    // Close the dialog
    Navigator.of(context).pop();
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tax (10%) and split calculations will be added automatically.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addTransaction,
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }

  double _calculateTotal() {
    return transactions.fold(0.0, (sum, tx) => sum + (tx['amount'] as double));
  }

  double _calculatePerPerson() {
    if (transactions.isEmpty) return 0.0;

    // Calculate total split amounts per person
    final Map<String, double> balances = {};

    for (var tx in transactions) {
      final paidBy = tx['paidBy'] as String;
      final totalAmount = tx['amount'] as double;
      final splitBetween = tx['splitBetween'] as int;
      final perPersonShare = totalAmount / splitBetween;

      // Add to payer's balance (they paid the full amount)
      balances.update(paidBy, (value) => value + totalAmount,
          ifAbsent: () => totalAmount);

      // Subtract from everyone's balance (they owe their share)
      for (int i = 0; i < splitBetween; i++) {
        final person =
            tx['paidBy'] as String; // In real app, would use actual person list
        balances.update(person, (value) => value - perPersonShare,
            ifAbsent: () => -perPersonShare);
      }
    }

    // For simplicity, return average per person
    return _calculateTotal() / 4;
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();
    final perPerson = _calculatePerPerson();

    return Scaffold(
      appBar: AppBar(
        title: Text(groupTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Summary'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Transactions: ${transactions.length}'),
                      Text('Total Amount: \$${total.toStringAsFixed(2)}'),
                      Text(
                          'Average per person: \$${perPerson.toStringAsFixed(2)}'),
                      const SizedBox(height: 16),
                      const Text('Calculations include:'),
                      const Text('• 10% tax added to each transaction'),
                      const Text('• Split between 4 people'),
                      const Text('• Automatic payer rotation'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Group Expenses',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '~ \$${perPerson.toStringAsFixed(2)} per person',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Chip(
                    label: Text('${transactions.length} items'),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                ],
              ),
            ),
          ),

          // Transactions List
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No transactions yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Tap + to add your first transaction',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final tx = transactions[i];
                      final txTitle = tx['title'] ?? '';
                      final originalAmount =
                          tx['originalAmount'] as double? ?? 0.0;
                      final tax = tx['tax'] as double? ?? 0.0;
                      final totalAmount = tx['totalAmount'] as double? ?? 0.0;
                      final txDate = tx['date'] ?? '';
                      final txTime = tx['time'] ?? '';
                      final paidBy = tx['paidBy'] ?? '';
                      final splitAmount = tx['splitAmount'] as double? ?? 0.0;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Colors.primaries[i % Colors.primaries.length],
                            child: Text(
                              txTitle.isNotEmpty ? txTitle[0] : '?',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(txTitle),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$txDate $txTime • Paid by $paidBy'),
                              Text(
                                'Original: \$${originalAmount.toStringAsFixed(2)} • '
                                'Tax: \$${tax.toStringAsFixed(2)} • '
                                'Each owes: \$${splitAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '\$${splitAmount.toStringAsFixed(2)} each',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onLongPress: () {
                            // Option to delete
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Transaction?'),
                                content: Text('Delete $txTitle?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        transactions.removeAt(i);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTransactionDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
