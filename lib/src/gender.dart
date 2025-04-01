/// Defines the gender categories used for classifying Khmer names.
///
/// The [Gender] enumeration provides a standardized set of categories
/// representing the traditional gender associations of Khmer personal names.
/// This enum is used throughout the `kname` package to enable filtering,
/// analysis, and classification based on gender-related metadata.
///
/// ## Categories
/// - [Gender.male] — Names traditionally used by male individuals.
/// - [Gender.female] — Names traditionally used by female individuals.
/// - [Gender.unisex] — Names that are neutral and can be used by individuals of any gender.
///
/// ## Usage Example
/// ```dart
/// import 'package:kname/kname.dart';
///
/// void main() {
///   Gender gender = Gender.female;
///   print('Selected gender: ${gender.name}'); // Outputs: Selected gender: female
/// }
/// ```
///
/// ## Notes
/// - This enum is serializable and used in both [KhmerName] and [KnamGenerator].
/// - When serializing to JSON, `Gender.name` or `gender.toString().split('.').last` can be used.
/// - When deserializing, use `Gender.values.byName(string)` for safe enum parsing.
///
/// See also:
/// - [KhmerName] for metadata representation of a full Khmer name.
/// - [KnamGenerator] for generating names with gender-based filtering.
enum Gender {
  /// Represents names traditionally used for male individuals.
  male,

  /// Represents names traditionally used for female individuals.
  female,

  /// Represents names that can be used for both male and female individuals.
  unisex,
}
