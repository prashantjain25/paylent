class Currency {
  final String name;
  final String code;
  final String symbol;

  Currency({
    required this.name,
    required this.code,
    required this.symbol,
  });

  @override
  String toString() => '$name ($code)';

  // You could add more methods if needed, like:
  static Currency fromCode(final String code) {
    // Find currency by code
    final currency = allCurrencies.firstWhere(
      (final c) => c.code == code,
      orElse: () => Currency(name: 'Unknown', code: code, symbol: code),
    );
    return currency;
  }

  // Example of a full currencies list as a static property
  static List<Currency> get allCurrencies => [
    Currency(name: 'Afghan Afghani', code: 'AFN', symbol: 'AFN'),
    Currency(name: 'Albanian Lek', code: 'ALL', symbol: 'ALL'),
    Currency(name: 'Algerian Dinar', code: 'DZD', symbol: 'DZD'),
    // ... rest of the currencies
    Currency(name: 'Zimbabwean Dollar', code: 'ZWL', symbol: 'Z\$'),
  ];
}