import 'package:flutter/material.dart';
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
    const AddScreen(),
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
          onTap: (final int idx) => setState(() => _tabIdx = idx),
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

  static const List<Map<String, dynamic>> _expenseList = [
    {
      'title': 'Lunch with Friends',
      'amount': -350.0,
      'date': 'Today',
      'color': Colors.redAccent
    },
    {
      'title': 'Uber Ride',
      'amount': -120.0,
      'date': 'Yesterday',
      'color': Colors.orangeAccent
    },
    {
      'title': 'Groceries',
      'amount': -900.0,
      'date': 'Yesterday',
      'color': Colors.green
    },
  ];

  double get total => _expenseList.fold(
      0.0,
      (final double sum, final Map<String, dynamic> item) =>
          sum + (item['amount'] as double));

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, Prashant';
    if (hour < 17) return 'Good afternoon, Prashant';
    return 'Good evening, Prashant';
  }

  String currencySymbol(final CurrencyType curr) {
    switch (curr) {
      case CurrencyType.inr:
        return '₹';
      case CurrencyType.usd:
        return '\$';
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: AppBar(
      elevation: 0,
      title: Text(
        'Dashboard',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
            color: AppColors.primaryBlue,
          ),
          tooltip: Theme.of(context).brightness == Brightness.dark
              ? 'Switch to Light Mode'
              : 'Switch to Dark Mode',
          onPressed: () => themeMode.value = Theme.of(context).brightness == Brightness.dark
                  ? ThemeMode.light
                  : ThemeMode.dark,
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none,
              color: AppColors.primaryBlue),
          onPressed: () {},
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(AppPaddings.screen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue),
          ),
          const SizedBox(height: AppPaddings.section),
          ValueListenableBuilder<CurrencyType>(
            valueListenable: currency,
            builder: (final BuildContext context, final CurrencyType curr, final Widget? _) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Total Expense',
                    style: TextStyle(color: AppColors.textLight, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total',
                    style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppPaddings.section),
          const Text(
            'Recent Expenses',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder<CurrencyType>(
              valueListenable: currency,
              builder: (final BuildContext context, final CurrencyType curr, final Widget? _) => ListView.builder(
                itemCount: _expenseList.length,
                itemBuilder: (final BuildContext context, final int idx) {
                  final exp = _expenseList[idx];
                  return _ExpenseTile(
                    title: exp['title'],
                    amount:
                        '-${currencySymbol(curr)}${(exp['amount'] as double).abs().toStringAsFixed(0)}',
                    date: exp['date'],
                    color: exp['color'],
                    key: ValueKey('${exp['title']}_${exp['date']}'),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppPaddings.section),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to Add Expense screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.add, size: 20),
              label: Text('Add Expense',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    ),
  );
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

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Add'),
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textLight,
        ),
        body: const Center(
          child: Text(
            'Add a new expense',
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
  Widget build(final BuildContext context) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Color.lerp(Colors.white, color, 0.2),
            child: Icon(Icons.receipt_long, color: color),
          ),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(date, style: const TextStyle(color: Colors.black54)),
          trailing: Text(amount,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ),
      );
}
