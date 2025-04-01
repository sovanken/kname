import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'khmer_name.dart';
import 'gender.dart';

/// A powerful generator for creating, filtering, and analyzing Khmer names.
///
/// The [KnamGenerator] class provides extensive capabilities for working with
/// Khmer names, including random name generation with filtering, dataset
/// statistics, popularity scoring, caching, and configurable options.
///
/// This class is designed for use in apps or tools that involve name generation,
/// search, or categorization of Khmer personal names.
///
/// ## Usage Example
/// ```dart
/// final generator = await KnamGenerator.fromAsset();
///
/// final name = generator.generate(gender: Gender.female);
/// print(name.fullName); // => Example: អ៊ូច សុភា
///
/// final names = generator.generateMultiple(3, onlyPopular: true);
/// final stats = generator.getStatistics();
/// print('Popular names: ${stats.popularNames}');
/// ```
class KnamGenerator {
  /// Internal list of all available Khmer names.
  final List<KhmerName> _names;

  /// Random number generator for name selection.
  final Random _random = Random();

  /// Cache for generated name sets by parameter key.
  final Map<String, List<KhmerName>> _cache = {};

  /// Configuration for customizing generator behavior.
  final KnamGeneratorConfig config;

  /// Private constructor used internally.
  KnamGenerator._(this._names, {KnamGeneratorConfig? config})
      : config = config ?? KnamGeneratorConfig();

  /// Creates a generator from a list of JSON-like name maps.
  factory KnamGenerator(
    List<dynamic> namesData, {
    KnamGeneratorConfig? config,
  }) {
    final names = namesData
        .map((json) => KhmerName.fromJson(json as Map<String, dynamic>))
        .toList();
    return KnamGenerator._(names, config: config);
  }

  /// Loads Khmer name data from a JSON asset file.
  ///
  /// If the asset fails to load, fallback data will be used.
  static Future<KnamGenerator> fromAsset({
    String path = 'assets/khmer_names.json',
    KnamGeneratorConfig? config,
  }) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> namesData = json.decode(jsonString);
      return KnamGenerator(namesData, config: config);
    } catch (e) {
      if (kDebugMode) {
        print('Warning: Failed to load names from asset. Using default names.');
      }
      return KnamGenerator(_defaultNames, config: config);
    }
  }

  /// Generates a single random Khmer name based on filters.
  ///
  /// Optional filters include:
  /// - [gender]: Filter by male, female, or unisex
  /// - [onlyPopular]: Whether to restrict to popular names
  /// - [startsWith]: Prefix string for romanized names
  /// - [minPopularityScore]: Custom popularity threshold
  /// - [allowedCategories]: Restrict to specific categories
  KhmerName generate({
    Gender? gender,
    bool? onlyPopular,
    String? startsWith,
    int? minPopularityScore,
    List<String>? allowedCategories,
  }) {
    final filtered = _names.where((name) {
      final genderMatch = gender == null ||
          name.gender == gender ||
          name.gender == Gender.unisex;
      final popularityMatch =
          onlyPopular == null || name.isPopular == onlyPopular;
      final startsWithMatch = startsWith == null ||
          name.romanizedName.toLowerCase().startsWith(startsWith.toLowerCase());
      final popularityScoreMatch = minPopularityScore == null ||
          (name.isPopular &&
              config.popularityScoreCalculator(name) >= minPopularityScore);
      final categoryMatch = allowedCategories == null ||
          allowedCategories.contains(name.category);

      return genderMatch &&
          popularityMatch &&
          startsWithMatch &&
          popularityScoreMatch &&
          categoryMatch;
    }).toList();

    if (filtered.isEmpty) {
      throw const NameGenerationException(
          'No names found matching the specified criteria.');
    }

    return filtered[_random.nextInt(filtered.length)];
  }

  /// Generates multiple Khmer names using the same filter options.
  ///
  /// Returns a list of [count] generated names.
  List<KhmerName> generateMultiple(
    int count, {
    Gender? gender,
    bool? onlyPopular,
    String? startsWith,
    int? minPopularityScore,
    List<String>? allowedCategories,
  }) {
    final cacheKey = _generateCacheKey(
      count: count,
      gender: gender,
      onlyPopular: onlyPopular,
      startsWith: startsWith,
      minPopularityScore: minPopularityScore,
      allowedCategories: allowedCategories,
    );

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final names = List.generate(
      count,
      (_) => generate(
        gender: gender,
        onlyPopular: onlyPopular,
        startsWith: startsWith,
        minPopularityScore: minPopularityScore,
        allowedCategories: allowedCategories,
      ),
    );

    _updateCache(cacheKey, names);
    return names;
  }

  /// Returns statistics about the current name dataset.
  ///
  /// Includes counts by gender, popularity, and category.
  KnamStatistics getStatistics() {
    return KnamStatistics(
      totalNames: _names.length,
      maleNames: getNamesByGender(Gender.male).length,
      femaleNames: getNamesByGender(Gender.female).length,
      unisexNames: getNamesByGender(Gender.unisex).length,
      popularNames: getPopularNames().length,
      categories: _calculateCategories(),
    );
  }

  /// Returns all names filtered by a specific [Gender].
  List<KhmerName> getNamesByGender(Gender gender) {
    return _names
        .where((name) => name.gender == gender || name.gender == Gender.unisex)
        .toList();
  }

  /// Returns all names marked as popular.
  List<KhmerName> getPopularNames() {
    return _names.where((name) => name.isPopular).toList();
  }

  /// Clears all cached name results.
  void clearCache() => _cache.clear();

  /// Returns the total number of names loaded.
  int get nameCount => _names.length;

  /// Generates a unique cache key based on filter parameters.
  String _generateCacheKey({
    required int count,
    Gender? gender,
    bool? onlyPopular,
    String? startsWith,
    int? minPopularityScore,
    List<String>? allowedCategories,
  }) {
    return [
      count,
      gender?.name ?? 'any',
      onlyPopular?.toString() ?? 'any',
      startsWith ?? 'any',
      minPopularityScore?.toString() ?? 'none',
      allowedCategories?.join(',') ?? 'all'
    ].join('_');
  }

  /// Updates the cache with a new entry, respecting the maximum size limit.
  void _updateCache(String key, List<KhmerName> names) {
    if (_cache.length >= config.maxCacheSize) {
      _cache.remove(_cache.keys.first); // simple FIFO eviction
    }
    _cache[key] = names;
  }

  /// Calculates the count of names in each category.
  Map<String, int> _calculateCategories() {
    final Map<String, int> counts = {};
    for (final name in _names) {
      counts[name.category] = (counts[name.category] ?? 0) + 1;
    }
    return counts;
  }
}

/// Custom configuration for [KnamGenerator].
///
/// You can provide a custom [popularityScoreCalculator] or change the
/// [maxCacheSize] to control memory usage for generated name caching.
class KnamGeneratorConfig {
  /// Function to assign popularity score to a [KhmerName].
  final int Function(KhmerName name) popularityScoreCalculator;

  /// Maximum number of cached name result sets.
  final int maxCacheSize;

  /// Constructs a config with optional overrides.
  KnamGeneratorConfig({
    int Function(KhmerName name)? popularityScoreCalculator,
    this.maxCacheSize = 100,
  }) : popularityScoreCalculator =
            popularityScoreCalculator ?? _defaultPopularityScoreCalculator;

  /// Default implementation returns 100 if name is popular, otherwise 0.
  static int _defaultPopularityScoreCalculator(KhmerName name) {
    return name.isPopular ? 100 : 0;
  }
}

/// Statistics returned by [KnamGenerator.getStatistics].
///
/// Includes name counts by gender and category distribution.
class KnamStatistics {
  final int totalNames;
  final int maleNames;
  final int femaleNames;
  final int unisexNames;
  final int popularNames;
  final Map<String, int> categories;

  const KnamStatistics({
    required this.totalNames,
    required this.maleNames,
    required this.femaleNames,
    required this.unisexNames,
    required this.popularNames,
    required this.categories,
  });
}

/// Exception thrown when name generation fails due to no matching names.
class NameGenerationException implements Exception {
  final String message;

  const NameGenerationException(this.message);

  @override
  String toString() => 'NameGenerationException: $message';
}

/// Default fallback name list used if JSON loading fails.
final List<dynamic> _defaultNames = [
  {
    'givenName': 'ដារា',
    'surname': 'អ៊ូច',
    'gender': 'male',
    'romanizedGiven': 'Dara',
    'romanizedSurname': 'Ouch',
    'meaning': 'Star',
    'origin': 'Pali',
    'category': 'modern',
    'isPopular': true,
  },
];
