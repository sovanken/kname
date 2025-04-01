/// A comprehensive Khmer name generation library for Dart and Flutter.
///
/// The `kname` package allows you to generate, filter, and analyze Khmer personal
/// names with ease. It supports both native Khmer script and romanized formats,
/// along with metadata such as gender, meaning, origin, and category.
///
/// ## Features
/// - 🔠 Generate random Khmer names
/// - ⚧ Filter names by gender (male, female, unisex)
/// - 📜 View detailed metadata (meaning, origin, category, popularity)
/// - 🇰🇭 Native Khmer and Romanized name support
/// - ⚙️ Custom configuration and dataset analysis
///
/// ## Quick Example
/// ```dart
/// import 'package:kname/kname.dart';
///
/// Future<void> main() async {
///   // Load names from a JSON asset or use fallback
///   final generator = await KnamGenerator.fromAsset();
///
///   // Generate a random name
///   final randomName = generator.generate();
///   print('Random Name: ${randomName.fullName}');
///
///   // Generate a male name
///   final maleName = generator.generate(gender: Gender.male);
///   print('Male Name: ${maleName.fullName}');
///
///   // Get statistics
///   final stats = generator.getStatistics();
///   print('Total names loaded: ${stats.totalNames}');
/// }
/// ```
///
/// ## Learn More
/// Visit the package repository for detailed documentation, usage examples,
/// and contribution guidelines.
///
/// {@tool package_example}
/// You can also view this in the `example/` directory of the package.
/// {@end-tool}
library kname;

export 'src/gender.dart';
export 'src/khmer_name.dart';
export 'src/kname_generator.dart';
