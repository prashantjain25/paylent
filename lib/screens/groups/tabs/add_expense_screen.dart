import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paylent/models/currency_model.dart';
import 'package:paylent/models/transaction_category.dart';
import 'package:paylent/models/transaction_model.dart';
import 'package:paylent/providers/transactions_provider.dart';
import 'package:paylent/screens/groups/tabs/currency_selection_screen.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final Transaction? transaction;
  final String groupId;
  const AddExpenseScreen({required this.groupId, this.isEdit = false, this.transaction, super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final Transaction? _transaction;
  late final bool _isEdit;
  bool _initialized = false;

  TransactionCategory _selectedCategory = TransactionCategory.food;
  String _selectedCurrencyCode = 'USD';
  final String _selectedPaidBy = 'You';
  DateTime _selectedDate = DateTime.now();

  

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    
    _transaction = widget.transaction;
    _isEdit = widget.isEdit;

    if (_isEdit && _transaction != null) {
      _amountController.text = _transaction.amount.toString();
      _descriptionController.text = _transaction.title;
      _selectedCategory = _transaction.category;
      final dynamic dateRaw = _transaction.date;
      _selectedCurrencyCode = _transaction.currency;
      _selectedDate = (dateRaw is DateTime)
          ? dateRaw
          : (dateRaw is String
              ? DateTime.tryParse(dateRaw) ?? DateTime.now()
              : DateTime.now());
    }
    _initialized = true;
  }

  Future<void> _selectDate(final BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final tx = Transaction(
        id: _isEdit
            ? _transaction!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        groupId: _transaction?.groupId ?? widget.groupId,
        title: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        paidByContactId: _selectedPaidBy,
        currency: _selectedCurrencyCode,
        category: _selectedCategory,
      );

      final notifier = ref.read(transactionsProvider.notifier);

      if (_isEdit) {
        notifier.update(tx);
      } else {
        notifier.add(tx);
      }

      Navigator.pop(context);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (final _) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context, 'deleted'); // return result
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Expense' : 'Add Expense'),
          elevation: 0,
          actions: [
            if (_isEdit)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                onPressed: _confirmDelete,
              ),
            IconButton(
              icon: const Icon(Icons.check),
              color: Colors.green,
              onPressed: _submit,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final selectedCurrency = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (final context) => CurrencySelectionScreen(
                              selectedCurrencyCode: _selectedCurrencyCode,
                            ),
                          ),
                        );

                        if (selectedCurrency != null &&
                            selectedCurrency is Currency) {
                          setState(() {
                            _selectedCurrencyCode = selectedCurrency.code;
                          });
                        }
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedCurrencyCode,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.arrow_drop_down, size: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Amount',
                        ),
                        validator: (final value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory.name,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: TransactionCategory.allCategories
                      .map((final category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (final value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory =
                            TransactionCategory.fromString(value);
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title:
                      Text('Date: ${DateFormat.yMd().format(_selectedDate)}'),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () => _selectDate(context),
                ),
              ],
            ),
          ),
        ),
      );
}
