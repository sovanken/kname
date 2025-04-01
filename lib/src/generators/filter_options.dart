/// Options for filtering Khmer names when generating or querying.
///
/// This class provides a flexible way to filter Khmer names based on various criteria
/// such as gender, origin, category, popularity, and meaning.
///
/// Example usage:
/// ```dart
/// // Create filter options for female names
/// final options = NameFilterOptions(gender: 'female');
///
/// // Create filter options for popular traditional names
/// final options = NameFilterOptions(
///   popularOnly: true,
///   category: 'traditional',
/// );
///
/// // Create filter options for names with a specific meaning
/// final options = NameFilterOptions(meaningContains: 'star');
/// ```
class NameFilterOptions {
  /// Filter by gender: 'male', 'female', or 'unisex'
  ///
  /// When specified, only names matching this gender will be included.
  /// If null, names of any gender will be included.
  final String? gender;

  /// Filter by origin (e.g., 'Pali', 'Sanskrit', 'Khmer')
  ///
  /// When specified, only names with this origin will be included.
  /// If null, names of any origin will be included.
  final String? origin;

  /// Filter by category (e.g., 'modern', 'traditional', 'royal')
  ///
  /// When specified, only names in this category will be included.
  /// If null, names of any category will be included.
  final String? category;

  /// Filter for popular names only
  ///
  /// When true, only names marked as popular will be included.
  /// When false or null, popularity is not considered as a filter.
  final bool? popularOnly;

  /// Filter for names containing this substring in their meaning
  ///
  /// When specified, only names whose meaning contains this substring
  /// (case-insensitive) will be included.
  /// If null, meaning is not used for filtering.
  final String? meaningContains;

  /// Filter for names with exact meaning
  ///
  /// When specified, only names with this exact meaning (case-insensitive)
  /// will be included.
  /// If null, exact meaning is not used for filtering.
  final String? exactMeaning;

  /// Creates a new set of filter options for name generation
  ///
  /// All parameters are optional. When a parameter is null, it means
  /// no filtering is applied for that criterion.
  const NameFilterOptions({
    this.gender,
    this.origin,
    this.category,
    this.popularOnly,
    this.meaningContains,
    this.exactMeaning,
  });

  /// Creates a copy of this options object with the given parameters replaced
  ///
  /// This is useful for modifying a subset of filtering options while
  /// keeping others unchanged.
  ///
  /// Example:
  /// ```dart
  /// final baseOptions = NameFilterOptions(gender: 'female');
  /// final popularFemaleOptions = baseOptions.copyWith(popularOnly: true);
  /// ```
  NameFilterOptions copyWith({
    String? gender,
    String? origin,
    String? category,
    bool? popularOnly,
    String? meaningContains,
    String? exactMeaning,
  }) {
    return NameFilterOptions(
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      category: category ?? this.category,
      popularOnly: popularOnly ?? this.popularOnly,
      meaningContains: meaningContains ?? this.meaningContains,
      exactMeaning: exactMeaning ?? this.exactMeaning,
    );
  }

  /// Creates filter options for male names only
  ///
  /// Example:
  /// ```dart
  /// final options = NameFilterOptions.male();
  /// final maleName = generator.getRandomName(options: options);
  /// ```
  static NameFilterOptions male() => const NameFilterOptions(gender: 'male');

  /// Creates filter options for female names only
  ///
  /// Example:
  /// ```dart
  /// final options = NameFilterOptions.female();
  /// final femaleName = generator.getRandomName(options: options);
  /// ```
  static NameFilterOptions female() =>
      const NameFilterOptions(gender: 'female');

  /// Creates filter options for popular names only
  ///
  /// Example:
  /// ```dart
  /// final options = NameFilterOptions.popular();
  /// final popularName = generator.getRandomName(options: options);
  /// ```
  static NameFilterOptions popular() =>
      const NameFilterOptions(popularOnly: true);

  /// Creates filter options for traditional names only
  ///
  /// Example:
  /// ```dart
  /// final options = NameFilterOptions.traditional();
  /// final traditionalName = generator.getRandomName(options: options);
  /// ```
  static NameFilterOptions traditional() =>
      const NameFilterOptions(category: 'traditional');

  /// Creates filter options for modern names only
  ///
  /// Example:
  /// ```dart
  /// final options = NameFilterOptions.modern();
  /// final modernName = generator.getRandomName(options: options);
  /// ```
  static NameFilterOptions modern() =>
      const NameFilterOptions(category: 'modern');

  /// Returns a string representation of the filter options for debugging
  @override
  String toString() {
    final filters = <String>[];

    if (gender != null) filters.add('gender: $gender');
    if (origin != null) filters.add('origin: $origin');
    if (category != null) filters.add('category: $category');
    if (popularOnly == true) filters.add('popularOnly: true');
    if (meaningContains != null) {
      filters.add('meaningContains: $meaningContains');
    }
    if (exactMeaning != null) filters.add('exactMeaning: $exactMeaning');

    return 'NameFilterOptions(${filters.join(', ')})';
  }
}
