import 'package:flutter/material.dart';

class ExpensesTab extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const ExpensesTab({required this.transactions, super.key});

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
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

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: widget.transactions.length,
      separatorBuilder: (final _, final __) => const Divider(),
      itemBuilder: (final _, final i) {
        final tx = widget.transactions[i];

        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.receipt, color: Colors.white),
          ),
          title: Text(tx['title']),
          subtitle: Text('Paid by ${tx['paidBy']}'),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${tx['amount'].toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Today',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              '/add_expense',
              arguments: {
                'expense': tx,
                'isEdit': true,
              },
            );

            if (result == 'deleted') {
              setState(() {
                widget.transactions.remove(tx);
              });
            } 
          },
        );
      },
    );
  }
}
