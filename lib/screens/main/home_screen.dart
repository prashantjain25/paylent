import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylent/models/constants.dart';
import 'package:paylent/models/enums.dart';
import 'package:paylent/main.dart';
import 'package:paylent/screens/groups/split_screen.dart';
import 'package:paylent/screens/main/account_screen.dart';

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
    const SplitScreen(),
    const BudgetScreen(),
    const AccountScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(final BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: _screens[_tabIdx],
            bottomNavigationBar: _CustomBNB(
              currentIndex: _tabIdx,
              onTap: (final idx) => setState(() => _tabIdx = idx),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey[200], // Light grey for distinction
            body: _screens[_tabIdx],
            bottomNavigationBar: _CustomBNB(
              currentIndex: _tabIdx,
              onTap: (final idx) => setState(() => _tabIdx = idx),
            ),
          );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
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

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, Prashant';
    if (hour < 17) return 'Good afternoon, Prashant';
    return 'Good evening, Prashant';
  }

  @override
  Widget build(final BuildContext context) => Row(
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  static const List<Map<String, dynamic>> _expenseList = [
    {'title': 'Lunch', 'amount': -350.0},
    {'title': 'Uber', 'amount': -120.0},
    {'title': 'Groceries', 'amount': -900.0},
  ];

  double get total => _expenseList.fold(0.0, (final sum, final item) => sum + (item['amount'] as double));

  String currencySymbol(final CurrencyType curr) {
    switch (curr) {
      case CurrencyType.inr:
        return '₹';
      case CurrencyType.usd:
        return '\$';
    }
  }

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<CurrencyType>(
      valueListenable: currency,
      builder: (final context, final curr, final _) {
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
  Widget build(final BuildContext context) => Column(
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
          builder: (final context, final curr, final _) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _expenseList.length,
              itemBuilder: (final context, final idx) {
                final exp = _expenseList[idx];
                return _ExpenseTile(
                  title: exp['title'],
                  amount: '-${currencySymbol(curr)}${(exp['amount'] as double).abs().toStringAsFixed(0)}',
                  date: exp['date'],
                  color: exp['color'],
                  key: ValueKey('${exp['title']}_${exp['date']}'),
                );
              },
            ),
        ),
      ],
    );
}



class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

// --- Custom Bottom Navigation Bar (BNB-45 style, glass) ---
class _CustomBNB extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _CustomBNB({required this.currentIndex, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color selectedColor = Theme.of(context).primaryColor;
    final Color unselectedColor = isDark ? Colors.white60 : Colors.grey;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // isDark
          //?
           Container(
              margin: const EdgeInsets.only(bottom: 16, left:1, right: 1),
              height: 72,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                //borderRadius: BorderRadius.circular(36),
                //border: Border.all(color: Colors.white.withOpacity(0.15), width: 2),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.40),
                //     blurRadius: 10,
                //     offset: const Offset(0, 6),
                //   ),
                // ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BNBItem(icon: Icons.home_outlined, label: 'Home', selected: currentIndex == 0, selectedColor: selectedColor, unselectedColor: unselectedColor, onTap: () => onTap(0)),
                  _BNBItem(icon: Icons.group_outlined, label: 'Split', selected: currentIndex == 1, selectedColor: selectedColor, unselectedColor: unselectedColor, onTap: () => onTap(1)),
                  //const SizedBox(width: 56),
                  _BNBItem(icon: Icons.money, label: 'Finance', selected: currentIndex == 2, selectedColor: selectedColor, unselectedColor: unselectedColor, onTap: () => onTap(2)),
                  _BNBItem(icon: Icons.contacts, label: 'Contacts', selected: currentIndex == 3, selectedColor: selectedColor, unselectedColor: unselectedColor, onTap: () => onTap(3)),
                  _BNBItem(icon: Icons.person_outline, label: 'Account', selected: currentIndex == 4, selectedColor: selectedColor, unselectedColor: unselectedColor, onTap: () => onTap(4)),
                ],
              ),
            )
          //  GlassNavBar(
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         _BNBItem(icon: Icons.home_outlined, label: 'Home', selected: currentIndex == 0, selectedColor: selectedColor, unselectedColor: unselectedColor, onTap: () => onTap(0)),
          //         _BNBItem(icon: Icons.group_outlined, label: 'Groups', selected: currentIndex == 1, selectedColor: selectedColor, unselectedColor: unselectedColor, onTap: () => onTap(1)),
          //         const SizedBox(width: 56),
          //         _BNBItem(icon: Icons.contacts_outlined, label: 'Contacts', selected: currentIndex == 2, selectedColor: selectedColor, unselectedColor: unselectedColor, onTap: () => onTap(2)),
          //         _BNBItem(icon: Icons.person_outline, label: 'Account', selected: currentIndex == 3, selectedColor: selectedColor, unselectedColor: unselectedColor, onTap: () => onTap(3)),
          //       ],
          //     ),
          //   ),
        // Positioned(
        //   bottom: 8, // Float slightly above the nav bar
        //   left: 0,
        //   right: 0,
        //   child: Center(
        //     child: Container( // Wrap if GlassButton doesn't support solid color
        //       decoration: const BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Colors.yellow, // Yellow background to match attachment
        //         // Add shadow if needed: boxShadow: [BoxShadow(color: Colors.yellow.withOpacity(0.5), blurRadius: 10)],
        //       ),
        //     child: GlassButton(
        //       width: 72,
        //       height: 72,
        //       borderRadius: 36,
        //       onTap: () => Navigator.pushNamed(context, '/add_expense'),
        //       child: Icon(Icons.add, size: 36, color: selectedColor),
        //     ),
        //     ),
        //   ),
      ],
    );
  }
}

class _BNBItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;
  const _BNBItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) => Expanded(
      child: InkWell(
        onTap: onTap,
       // borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          //  color: selected ? selectedColor.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? selectedColor : unselectedColor, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? selectedColor : unselectedColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                  letterSpacing: 0.2,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
