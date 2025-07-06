import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylent/constants.dart';
import 'package:paylent/enums.dart';
import 'package:paylent/main.dart';

// Notifier for selected currency symbol
final ValueNotifier<CurrencyType> currency =
    ValueNotifier<CurrencyType>(CurrencyType.inr);

/// Main home screen with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIdx = 0;

  late final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionsScreen(),
    Container(), // Placeholder for the Add button, which now pushes a route
    const BudgetScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: _screens[_tabIdx],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: Colors.grey,
          currentIndex: _tabIdx,
          onTap: (final int idx) {
            if (idx == 2) {
              Navigator.pushNamed(context, '/add_expense');
            } else {
              setState(() => _tabIdx = idx);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 30),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Budgets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      );
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppPaddings.screen),
          children: const [
            _WelcomeHeader(),
            SizedBox(height: AppPaddings.section),
            _BalanceCard(),
            SizedBox(height: AppPaddings.section),
            _RecentTransactions(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, Prashant';
    if (hour < 17) return 'Good afternoon, Prashant';
    return 'Good evening, Prashant';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          greeting,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: AppColors.primaryBlue,
              ),
              tooltip: Theme.of(context).brightness == Brightness.dark
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
              onPressed: () {
                themeMode.value = Theme.of(context).brightness == Brightness.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: AppColors.primaryBlue),
              onPressed: () {
                // Notification logic
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  static const List<Map<String, dynamic>> _expenseList = [
    {'title': 'Lunch', 'amount': -350.0},
    {'title': 'Uber', 'amount': -120.0},
    {'title': 'Groceries', 'amount': -900.0},
  ];

  double get total => _expenseList.fold(0.0, (sum, item) => sum + (item['amount'] as double));

  String currencySymbol(final CurrencyType curr) {
    switch (curr) {
      case CurrencyType.inr:
        return '₹';
      case CurrencyType.usd:
        return '\$';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CurrencyType>(
      valueListenable: currency,
      builder: (context, curr, _) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${currencySymbol(curr)}${NumberFormat('#,##0.00', 'en_US').format(total.abs())}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions();

  static const List<Map<String, dynamic>> _expenseList = [
    {'title': 'Lunch with Friends', 'amount': -350.0, 'date': 'Today', 'color': Colors.redAccent},
    {'title': 'Uber Ride', 'amount': -120.0, 'date': 'Yesterday', 'color': Colors.orangeAccent},
    {'title': 'Groceries', 'amount': -900.0, 'date': 'Yesterday', 'color': Colors.green},
  ];

  String currencySymbol(final CurrencyType curr) {
    switch (curr) {
      case CurrencyType.inr:
        return '₹';
      case CurrencyType.usd:
        return '\$';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<CurrencyType>(
          valueListenable: currency,
          builder: (context, curr, _) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _expenseList.length,
              itemBuilder: (context, idx) {
                final exp = _expenseList[idx];
                return _ExpenseTile(
                  title: exp['title'],
                  amount: '-${currencySymbol(curr)}${(exp['amount'] as double).abs().toStringAsFixed(0)}',
                  date: exp['date'],
                  color: exp['color'],
                  key: ValueKey('${exp['title']}_${exp['date']}'),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
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

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Budget'),
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textLight,
        ),
        body: const Center(
          child: Text(
            'Budget Overview',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textLight,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppPaddings.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.selectCurrency,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue)),
              const SizedBox(height: AppPaddings.section),
              ValueListenableBuilder<CurrencyType>(
                valueListenable: currency,
                builder: (final BuildContext context, final CurrencyType curr, final Widget? _) => DropdownButton<CurrencyType>(
                  value: curr,
                  items: const [
                    DropdownMenuItem(
                        value: CurrencyType.inr, child: Text('₹')),
                    DropdownMenuItem(
                        value: CurrencyType.usd, child: Text('\$')),
                  ],
                  onChanged: (final CurrencyType? newCurr) {
                    newCurr != null ? currency.value = newCurr : null;
                  },
                ),
              ),
              const SizedBox(height: 32),
              const Text('Other profile features here...'),
            ],
          ),
        ),
      );
}

class _ExpenseTile extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final Color color;

  const _ExpenseTile({
    required this.title,
    required this.amount,
    required this.date,
    required this.color,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          child: const Icon(Icons.arrow_downward),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        subtitle: Text(date, style: TextStyle(color: textColor.withOpacity(0.7))),
        trailing: Text(
          amount,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 16),
        ),
      ),
    );
  }
}
