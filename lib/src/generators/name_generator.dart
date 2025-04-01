import 'dart:math';

import '../models/khmer_name.dart';
import '../data/name_data.dart';
import 'filter_options.dart';

/// A generator for Khmer names with various filtering capabilities.
///
/// This class provides methods to generate random Khmer names,
/// search for names with specific criteria, and access the full
/// dataset of names.
///
/// Example usage:
/// ```dart
/// // Create a generator
/// final generator = KhmerNameGenerator();
///
/// // Get a random name
/// final randomName = generator.getRandomName();
///
/// // Get a random female name
/// final femaleName = generator.getRandomName(
///   options: NameFilterOptions(gender: 'female')
/// );
///
/// // Get multiple unique names
/// final names = generator.getRandomNames(count: 5);
/// ```
class KhmerNameGenerator {
  /// Data provider for accessing the Khmer name dataset
  final NameDataProvider _dataProvider;

  /// Random number generator for selecting names
  final Random _random;

  /// Creates a new [KhmerNameGenerator] with an optional random seed.
  ///
  /// If [seed] is provided, the random generator will produce a
  /// deterministic sequence of names, which can be useful for testing
  /// or reproducible results.
  ///
  /// Example:
  /// ```dart
  /// // Create with default random behavior
  /// final generator = KhmerNameGenerator();
  ///
  /// // Create with a specific seed for deterministic results
  /// final generator = KhmerNameGenerator(seed: 42);
  /// ```
  KhmerNameGenerator({int? seed})
      : _dataProvider = NameDataProvider(),
        _random = Random(seed);

  /// Gets a random name from the dataset.
  ///
  /// If [options] is provided, the name will be filtered according to those options.
  /// For example, you can filter by gender, origin, category, or other attributes.
  ///
  /// Returns a single [KhmerName] that matches the given criteria.
  ///
  /// Throws [StateError] if no names match the given filter criteria.
  ///
  /// Example:
  /// ```dart
  /// // Get any random name
  /// final name = generator.getRandomName();
  ///
  /// // Get a random female name
  /// final femaleName = generator.getRandomName(
  ///   options: NameFilterOptions(gender: 'female')
  /// );
  ///
  /// // Get a random popular traditional name
  /// final traditionalName = generator.getRandomName(
  ///   options: NameFilterOptions(
  ///     category: 'traditional',
  ///     popularOnly: true
  ///   )
  /// );
  /// ```
  KhmerName getRandomName({NameFilterOptions? options}) {
    final filteredNames = _getFilteredNames(options);
    if (filteredNames.isEmpty) {
      throw StateError('No names match the given filter criteria');
    }
    return filteredNames[_random.nextInt(filteredNames.length)];
  }

  /// Gets multiple random names from the dataset.
  ///
  /// [count] specifies how many names to return.
  ///
  /// If [options] is provided, the names will be filtered according to those options.
  ///
  /// If [unique] is true (default), all returned names will be unique (if possible).
  /// If false, the same name may appear multiple times in the result.
  ///
  /// Returns a list of [KhmerName] objects that match the given criteria.
  ///
  /// Throws [StateError] if no names match the given filter criteria.
  /// Throws [ArgumentError] if [unique] is true and [count] exceeds the number
  /// of available names that match the criteria.
  ///
  /// Example:
  /// ```dart
  /// // Get 5 unique random names
  /// final names = generator.getRandomNames(count: 5);
  ///
  /// // Get 10 female names (may contain duplicates if needed)
  /// final femaleNames = generator.getRandomNames(
  ///   count: 10,
  ///   options: NameFilterOptions(gender: 'female'),
  ///   unique: false
  /// );
  /// ```
  List<KhmerName> getRandomNames({
    required int count,
    NameFilterOptions? options,
    bool unique = true,
  }) {
    final filteredNames = _getFilteredNames(options);
    if (filteredNames.isEmpty) {
      throw StateError('No names match the given filter criteria');
    }

    if (unique && count > filteredNames.length) {
      throw ArgumentError(
        'Requested $count unique names but only ${filteredNames.length} names match the filter criteria',
      );
    }

    if (unique) {
      // Fisher-Yates shuffle for efficient random sampling without replacement
      final namesCopy = List<KhmerName>.from(filteredNames);
      final result = <KhmerName>[];

      for (var i = 0; i < count; i++) {
        final randomIndex = _random.nextInt(namesCopy.length);
        result.add(namesCopy[randomIndex]);

        // Move the last element to the position of the one we just used
        // (unless we just used the last element)
        if (randomIndex < namesCopy.length - 1) {
          namesCopy[randomIndex] = namesCopy.last;
        }
        namesCopy.removeLast();
      }

      return result;
    } else {
      // Simple random sampling with replacement
      return List.generate(
        count,
        (_) => filteredNames[_random.nextInt(filteredNames.length)],
      );
    }
  }

  /// Gets a random given name and surname pair, potentially mixing from different records.
  ///
  /// This method creates new name combinations by randomly selecting a given name
  /// and a surname, which might come from different records in the dataset.
  ///
  /// If [options] is provided, both names will be filtered according to those options.
  ///
  /// If [romanized] is true, the returned map will contain romanized versions of the names.
  /// If false (default), it will contain names in Khmer script.
  ///
  /// Returns a map with 'givenName' and 'surname' keys containing the selected names.
  ///
  /// Throws [StateError] if no names match the given filter criteria.
  ///
  /// Example:
  /// ```dart
  /// // Get a random name pair in Khmer script
  /// final namePair = generator.getRandomNamePair();
  /// print('${namePair['givenName']} ${namePair['surname']}');
  ///
  /// // Get a romanized name pair
  /// final romanizedPair = generator.getRandomNamePair(romanized: true);
  /// print('${romanizedPair['givenName']} ${romanizedPair['surname']}');
  /// ```
  Map<String, String> getRandomNamePair({
    NameFilterOptions? options,
    bool romanized = false,
  }) {
    final givenNameOptions = options ?? const NameFilterOptions();
    final surnameOptions = options ?? const NameFilterOptions();

    final givenName = getRandomName(options: givenNameOptions);
    final surname = getRandomName(options: surnameOptions);

    return {
      'givenName': romanized ? givenName.romanizedGiven : givenName.givenName,
      'surname': romanized ? surname.romanizedSurname : surname.surname,
    };
  }

  /// Searches for names matching the given criteria.
  ///
  /// This method filters the names dataset based on the provided [options]
  /// and returns all matching names, optionally limited to [limit] results.
  ///
  /// The [options] parameter is required and specifies the filtering criteria.
  ///
  /// If [limit] is greater than 0, at most that many results will be returned.
  /// If 0 (default), all matching names will be returned.
  ///
  /// Returns a list of [KhmerName] objects that match the given criteria.
  ///
  /// Example:
  /// ```dart
  /// // Search for female names with 'star' in their meaning
  /// final starNames = generator.searchNames(
  ///   options: NameFilterOptions(
  ///     gender: 'female',
  ///     meaningContains: 'star'
  ///   )
  /// );
  ///
  /// // Get top 5 popular names
  /// final topNames = generator.searchNames(
  ///   options: NameFilterOptions(popularOnly: true),
  ///   limit: 5
  /// );
  /// ```
  List<KhmerName> searchNames({
    required NameFilterOptions options,
    int limit = 0,
  }) {
    final filteredNames = _getFilteredNames(options);
    if (limit > 0 && limit < filteredNames.length) {
      return filteredNames.sublist(0, limit);
    }
    return filteredNames;
  }

  /// Gets all available names from the dataset.
  ///
  /// Returns an unmodifiable list containing all [KhmerName] objects
  /// in the dataset, without any filtering.
  ///
  /// Example:
  /// ```dart
  /// final allNames = generator.getAllNames();
  /// print('Total names: ${allNames.length}');
  /// ```
  List<KhmerName> getAllNames() {
    return _dataProvider.getAllNames();
  }

  /// Private helper method to filter names based on options.
  ///
  /// This method applies the filtering criteria specified in [options]
  /// to the full dataset and returns all matching names.
  ///
  /// If [options] is null, all names in the dataset will be returned.
  ///
  /// Returns a list of [KhmerName] objects that match the given criteria.
  List<KhmerName> _getFilteredNames(NameFilterOptions? options) {
    if (options == null) {
      return _dataProvider.getAllNames();
    }

    return _dataProvider.getAllNames().where((name) {
      // Apply each filter criteria if provided
      if (options.gender != null && name.gender != options.gender) {
        return false;
      }

      if (options.origin != null && name.origin != options.origin) {
        return false;
      }

      if (options.category != null && name.category != options.category) {
        return false;
      }

      if (options.popularOnly == true && !name.isPopular) {
        return false;
      }

      if (options.exactMeaning != null &&
          name.meaning?.toLowerCase() != options.exactMeaning!.toLowerCase()) {
        return false;
      }

      if (options.meaningContains != null &&
          !(name.meaning
                  ?.toLowerCase()
                  .contains(options.meaningContains!.toLowerCase()) ??
              false)) {
        return false;
      }

      return true;
    }).toList();
  }
}
