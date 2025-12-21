import 'package:flutter/material.dart';
import 'package:paylent/models/constants.dart';


class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Transactions'),
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textLight,
        ),
        body: const Center(
          child: Text(
            'No transactions yet!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
}