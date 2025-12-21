import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paylent/models/currency_model.dart';
import 'package:paylent/screens/groups/currency_selection_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? expense;
  const AddExpenseScreen({this.isEdit = false, this.expense, super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final Map<String, dynamic>? _expense;
  late final bool _isEdit;
  bool _initialized = false;

  String _selectedCategory = 'Food';
  String _selectedCurrencyCode = 'USD';
  String _selectedCurrencyName = 'United States Dollar';
  String _selectedCurrencySymbol = '\$';
  final String _selectedPaidBy = 'You';
  final String _selectedSplitBy = 'Equally';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Others'
  ];

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

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    _expense = args?['expense'];
    _isEdit = args?['isEdit'] ?? false;

    if (_isEdit && _expense != null) {
      _amountController.text = _expense['amount']?.toString() ?? '';
      _descriptionController.text = _expense['title'] ?? '';
      _selectedCategory = _expense['category'] ?? 'Food';
     // _selectedDate = _expense['date'] ?? DateTime.now();
      _selectedCurrencyCode = _expense['currency'] ?? 'USD';
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
      Navigator.pop(context, {
        'title': _descriptionController.text,
        'amount': double.parse(_amountController.text),
        'category': _selectedCategory,
        'currency': _selectedCurrencyCode,
        'date': _selectedDate,
      });
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
                            _selectedCurrencyName = selectedCurrency.name;
                            _selectedCurrencySymbol = selectedCurrency.symbol;
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
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: _categories
                      .map((final category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (final value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
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
