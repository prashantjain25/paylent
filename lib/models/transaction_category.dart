enum TransactionCategory {
  // ───── General ─────
  general,
  adjustment,

  // ───── Entertainment ─────
  games,
  movies,
  music,
  concerts,
  sports,
  streaming,

  // ───── Food & Drink ─────
  groceries,
  dining,
  cafe,
  fastFood,
  liquor,

  // ───── Transport ─────
  fuel,
  taxi,
  publicTransport,
  parking,
  vehicleMaintenance,

  // ───── Home ─────
  rent,
  utilities,
  internet,
  mobile,
  repairs,

  // ───── Health ─────
  medical,
  pharmacy,
  fitness,
  insurance,

  // ───── Travel ─────
  flights,
  hotels,
  activities,

  // ───── Shopping ─────
  clothing,
  electronics,
  gifts,

  // ───── Fallback ─────
  others;



  static TransactionCategory fromString(final String value) => TransactionCategory.values.firstWhere(
      (final e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TransactionCategory.others,
    );
  // Optional: Helper to get a capitalized string for the UI
  String get name {
     switch (this) {
      case TransactionCategory.general: return 'General';
      case TransactionCategory.adjustment: return 'Adjustment';

      case TransactionCategory.games: return 'Games';
      case TransactionCategory.movies: return 'Movies';
      case TransactionCategory.music: return 'Music';
      case TransactionCategory.concerts: return 'Concerts';
      case TransactionCategory.sports: return 'Sports';
      case TransactionCategory.streaming: return 'Streaming';

      case TransactionCategory.groceries: return 'Groceries';
      case TransactionCategory.dining: return 'Dining Out';
      case TransactionCategory.cafe: return 'Cafe';
      case TransactionCategory.fastFood: return 'Fast Food';
      case TransactionCategory.liquor: return 'Liquor';

      case TransactionCategory.fuel: return 'Fuel';
      case TransactionCategory.taxi: return 'Taxi / Ride share';
      case TransactionCategory.publicTransport: return 'Public Transport';
      case TransactionCategory.parking: return 'Parking';
      case TransactionCategory.vehicleMaintenance: return 'Vehicle Maintenance';

      case TransactionCategory.rent: return 'Rent';
      case TransactionCategory.utilities: return 'Utilities';
      case TransactionCategory.internet: return 'Internet';
      case TransactionCategory.mobile: return 'Mobile';
      case TransactionCategory.repairs: return 'Repairs';

      case TransactionCategory.medical: return 'Medical';
      case TransactionCategory.pharmacy: return 'Pharmacy';
      case TransactionCategory.fitness: return 'Fitness';
      case TransactionCategory.insurance: return 'Insurance';

      case TransactionCategory.flights: return 'Flights';
      case TransactionCategory.hotels: return 'Hotels';
      case TransactionCategory.activities: return 'Activities';

      case TransactionCategory.clothing: return 'Clothing';
      case TransactionCategory.electronics: return 'Electronics';
      case TransactionCategory.gifts: return 'Gifts';

      case TransactionCategory.others: return 'Others';
    }
  }

  static List<String> get allCategories => TransactionCategory.values.map((final e) => e.name).toList();
}