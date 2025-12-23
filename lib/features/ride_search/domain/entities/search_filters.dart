class SearchFilters {
  final String fromCity;
  final String toCity;
  final DateTime date;
  final int seats;

  const SearchFilters({
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.seats,
  });

  SearchFilters copyWith({
    String? fromCity,
    String? toCity,
    DateTime? date,
    int? seats,
  }) {
    return SearchFilters(
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      date: date ?? this.date,
      seats: seats ?? this.seats,
    );
  }

  static SearchFilters initial() {
    return SearchFilters(
      fromCity: '',
      toCity: '',
      date: DateTime.now(),
      seats: 1,
    );
  }
}
