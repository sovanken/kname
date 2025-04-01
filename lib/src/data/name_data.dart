import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/khmer_name.dart';

/// A provider class for loading and accessing Khmer name data from the package assets.
///
/// This class implements the Singleton pattern to ensure only one instance exists
/// throughout the application lifecycle, preventing multiple data loads and
/// optimizing memory usage.
///
/// Example usage:
/// ```dart
/// // Get the singleton instance
/// final dataProvider = NameDataProvider();
///
/// // Load the data (only needs to be called once per app session)
/// await dataProvider.loadData();
///
/// // Access the names
/// final allNames = dataProvider.getAllNames();
/// print('Total names: ${dataProvider.count}');
/// ```
class NameDataProvider {
  // Private static singleton instance
  static final NameDataProvider _instance = NameDataProvider._internal();

  /// Factory constructor that returns the singleton instance.
  ///
  /// This ensures that only one instance of [NameDataProvider] exists
  /// throughout the application, providing efficient memory usage and
  /// preventing duplicate data loading.
  factory NameDataProvider() => _instance;

  /// Private constructor for the singleton pattern.
  ///
  /// This prevents direct instantiation with the `new` keyword.
  NameDataProvider._internal();

  /// Cached list of all Khmer names.
  ///
  /// This is null until [loadData] is called. After loading,
  /// this contains all names from the JSON asset file.
  List<KhmerName>? _allNames;

  /// Indicates whether the name data has been loaded.
  ///
  /// Returns `true` if [loadData] has been successfully called
  /// and the data is available, otherwise `false`.
  bool get isLoaded => _allNames != null;

  /// Loads the name data from the bundled JSON asset file.
  ///
  /// This method reads the JSON file from the package's assets,
  /// parses it, and converts each JSON object into a [KhmerName] instance.
  /// The results are cached in memory for future access.
  ///
  /// If the data has already been loaded, this method returns immediately
  /// without performing any operation.
  ///
  /// Throws an [Exception] if the data cannot be loaded or parsed.
  Future<void> loadData() async {
    // Skip loading if data is already loaded
    if (_allNames != null) return;

    try {
      // Load the JSON data from the package assets
      // The 'packages/kname' prefix is required to access assets from this package
      final jsonString =
          await rootBundle.loadString('packages/kname/assets/khmer_names.json');

      // Parse the JSON string into a List of dynamic objects
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      // Convert each JSON object to a KhmerName instance
      _allNames = jsonList
          .map((json) => KhmerName.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Provide a clear error message with the original exception
      throw Exception('Failed to load Khmer names data: $e');
    }
  }

  /// Returns an unmodifiable list of all available Khmer names.
  ///
  /// This method provides access to all the [KhmerName] objects
  /// that have been loaded from the JSON asset.
  ///
  /// Returns:
  ///   An unmodifiable list containing all [KhmerName] objects.
  ///
  /// Throws:
  ///   [StateError] if [loadData] has not been called before accessing the names.
  List<KhmerName> getAllNames() {
    if (_allNames == null) {
      throw StateError(
        'Name data not loaded. Call loadData() before accessing names.',
      );
    }
    // Return an unmodifiable list to prevent accidental modifications
    return List.unmodifiable(_allNames!);
  }

  /// Gets the total number of names in the dataset.
  ///
  /// Returns 0 if the data has not been loaded yet.
  int get count => _allNames?.length ?? 0;

  /// Resets the cached data, clearing all loaded names from memory.
  ///
  /// This is primarily useful for testing purposes or when memory needs
  /// to be freed. After calling this method, [loadData] must be called
  /// again before accessing the names.
  void reset() {
    _allNames = null;
  }
}
