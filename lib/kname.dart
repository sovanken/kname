/// A package for generating and working with Khmer names.
///
/// The KName package provides tools for generating authentic Khmer names,
/// with support for both Khmer script and romanized versions. It includes
/// a comprehensive dataset of 1000+ Khmer names with metadata such as
/// gender, meaning, origin, and popularity.
///
/// The package works entirely offline, with all name data bundled within.
///
/// Basic usage example:
/// ```dart
/// import 'package:kname/kname.dart';
///
/// void main() async {
///   // Initialize the package first
///   await initializeKname();
///
///   // Create a name generator
///   final generator = KhmerNameGenerator();
///
///   // Get a random name
///   final name = generator.getRandomName();
///
///   print('Name in Khmer: ${name.fullName}');
///   print('Romanized name: ${name.fullRomanizedName}');
///   print('Meaning: ${name.meaning}');
/// }
/// ```
library kname;

// Export public API

// Models
export 'src/models/khmer_name.dart';

// Generators
export 'src/generators/name_generator.dart';
export 'src/generators/filter_options.dart';

// Utils
export 'src/utils/string_utils.dart';

// Core functionality
import 'package:kname/kname.dart';

import 'src/data/name_data.dart';

/// Initializes the KName package by loading the name data.
///
/// This function must be called before using any name generation functions,
/// typically during app initialization. It loads the Khmer name dataset
/// from the package's assets and prepares it for use.
///
/// The initialization process is very fast (typically under 200ms) and
/// the data is cached for subsequent use, so there's no need to call
/// this function more than once per app session.
///
/// Example:
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:kname/kname.dart';
///
/// void main() async {
///   // Ensure Flutter binding is initialized
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Initialize KName package
///   await initializeKname();
///
///   // Now you can use the package
///   runApp(MyApp());
/// }
/// ```
///
/// Throws an [Exception] if the name data cannot be loaded, typically
/// due to missing assets or package configuration issues.
Future<void> initializeKname() async {
  await NameDataProvider().loadData();
}

/// The current version of the KName package.
///
/// This constant can be used to check which version of the package
/// is being used at runtime.
const String packageVersion = '0.1.1';

/// The total number of names available in the dataset.
///
/// This getter provides the count of unique name records in the package's dataset.
/// It can only be called after [initializeKname] has been invoked.
///
/// Throws a [StateError] if accessed before initializing the package.
///
/// Example:
/// ```dart
/// await initializeKname();
/// print('Total names available: ${nameCount}');
/// ```
int get nameCount {
  final provider = NameDataProvider();
  if (!provider.isLoaded) {
    throw StateError(
      'Name data not loaded. Call initializeKname() before accessing nameCount.',
    );
  }
  return provider.count;
}

/// Creates a new name generator with optional random seed.
///
/// This is a convenience function to create a [KhmerNameGenerator] instance.
/// It's equivalent to calling the constructor directly.
///
/// If [seed] is provided, the random generator will produce a deterministic
/// sequence of names, which can be useful for testing or reproducible results.
///
/// Example:
/// ```dart
/// // Create with default random behavior
/// final generator = createNameGenerator();
///
/// // Create with a specific seed
/// final deterministicGenerator = createNameGenerator(seed: 42);
/// ```
KhmerNameGenerator createNameGenerator({int? seed}) {
  return KhmerNameGenerator(seed: seed);
}
