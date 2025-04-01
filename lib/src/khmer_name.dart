import 'gender.dart';

/// Represents a full Khmer name with detailed metadata and utilities.
///
/// The [KhmerName] class is a core data model used throughout the `kname` package.
/// It encapsulates traditional and modern Khmer personal names, supporting
/// both native Khmer script and romanized Latin script representations.
///
/// This class also includes contextual metadata such as the name's gender,
/// cultural origin, meaning, category, and popularity status.
///
/// ## Example Usage
/// ```dart
/// final name = KhmerName(
///   givenName: 'ដារា',
///   surname: 'អ៊ូច',
///   romanizedGiven: 'Dara',
///   romanizedSurname: 'Ouch',
///   gender: Gender.male,
///   meaning: 'Star',
///   origin: 'Pali',
///   category: 'modern',
///   isPopular: true,
/// );
///
/// print(name.fullName);         // Outputs: អ៊ូច ដារា
/// print(name.romanizedName);    // Outputs: Ouch Dara
/// print(name.gender.name);      // Outputs: male
/// print(name.toJson());         // Converts to JSON map
/// ```
class KhmerName {
  /// The given (first) name written in Khmer script.
  final String givenName;

  /// The surname (family name) written in Khmer script.
  final String surname;

  /// The romanized form of the given name, in Latin script.
  final String romanizedGiven;

  /// The romanized form of the surname, in Latin script.
  final String romanizedSurname;

  /// The gender classification of this name (male, female, or unisex).
  final Gender gender;

  /// The semantic or symbolic meaning of the name.
  final String meaning;

  /// The linguistic or cultural origin of the name (e.g., Pali, Sanskrit, Khmer).
  final String origin;

  /// The category or style of the name (e.g., traditional, modern, royal).
  final String category;

  /// Indicates whether the name is widely recognized or commonly used.
  final bool isPopular;

  /// Constructs a new [KhmerName] instance with all required metadata.
  ///
  /// All parameters must be provided to ensure a complete and valid name object.
  const KhmerName({
    required this.givenName,
    required this.surname,
    required this.romanizedGiven,
    required this.romanizedSurname,
    required this.gender,
    required this.meaning,
    required this.origin,
    required this.category,
    required this.isPopular,
  });

  /// Returns the full name in native Khmer script, formatted as "surname givenName".
  ///
  /// Example:
  /// ```dart
  /// print(name.fullName); // => អ៊ូច ដារា
  /// ```
  String get fullName => '$surname $givenName';

  /// Returns the full romanized name in Latin script, formatted as "romanizedSurname romanizedGiven".
  ///
  /// Example:
  /// ```dart
  /// print(name.romanizedName); // => Ouch Dara
  /// ```
  String get romanizedName => '$romanizedSurname $romanizedGiven';

  /// Serializes the [KhmerName] into a JSON-compatible map.
  ///
  /// This is useful for saving, transmitting, or caching name data.
  Map<String, dynamic> toJson() => {
        'givenName': givenName,
        'surname': surname,
        'romanizedGiven': romanizedGiven,
        'romanizedSurname': romanizedSurname,
        'gender': gender.name,
        'meaning': meaning,
        'origin': origin,
        'category': category,
        'isPopular': isPopular,
      };

  /// Creates a [KhmerName] instance from a JSON-compatible map.
  ///
  /// This factory constructor is used to deserialize name data
  /// retrieved from JSON files or APIs.
  factory KhmerName.fromJson(Map<String, dynamic> json) {
    return KhmerName(
      givenName: json['givenName'] ?? '',
      surname: json['surname'] ?? '',
      romanizedGiven: json['romanizedGiven'] ?? '',
      romanizedSurname: json['romanizedSurname'] ?? '',
      gender: Gender.values.byName(json['gender']),
      meaning: json['meaning'] ?? '',
      origin: json['origin'] ?? '',
      category: json['category'] ?? '',
      isPopular: json['isPopular'] ?? false,
    );
  }

  /// Returns a string representation of this name.
  ///
  /// By default, this returns the full romanized name.
  @override
  String toString() => romanizedName;

  /// Checks whether two [KhmerName] instances are equal.
  ///
  /// Equality is based on all fields being identical.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KhmerName &&
          runtimeType == other.runtimeType &&
          givenName == other.givenName &&
          surname == other.surname &&
          romanizedGiven == other.romanizedGiven &&
          romanizedSurname == other.romanizedSurname &&
          gender == other.gender &&
          meaning == other.meaning &&
          origin == other.origin &&
          category == other.category &&
          isPopular == other.isPopular;

  /// Returns a hash code for this [KhmerName].
  ///
  /// This is used to support equality comparisons in collections.
  @override
  int get hashCode => Object.hash(
        givenName,
        surname,
        romanizedGiven,
        romanizedSurname,
        gender,
        meaning,
        origin,
        category,
        isPopular,
      );
}
