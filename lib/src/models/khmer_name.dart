/// A model class representing a Khmer name with both native and romanized forms.
///
/// This class encapsulates all information related to a Khmer name, including
/// both Khmer script and romanized versions, gender, meaning, origin, and other
/// metadata.
///
/// Example usage:
/// ```dart
/// // Create a name
/// final name = KhmerName(
///   givenName: 'ដារា',
///   surname: 'អ៊ូច',
///   gender: 'male',
///   romanizedGiven: 'Dara',
///   romanizedSurname: 'Ouch',
///   meaning: 'Star',
///   origin: 'Pali',
///   category: 'modern',
///   isPopular: true,
/// );
///
/// // Access properties
/// print(name.fullName);         // ដារា អ៊ូច
/// print(name.fullRomanizedName); // Dara Ouch
/// print(name.meaning);          // Star
/// ```
class KhmerName {
  /// The given name in Khmer script.
  ///
  /// This represents the first name of the person using Khmer Unicode characters.
  /// Example: ដារា
  final String givenName;

  /// The surname in Khmer script.
  ///
  /// This represents the family name or last name of the person using Khmer Unicode characters.
  /// Example: អ៊ូច
  final String surname;

  /// The gender associated with the name.
  ///
  /// Valid values are: 'male', 'female', or 'unisex'.
  /// This indicates whether the name is traditionally used for males, females, or both.
  final String gender;

  /// The romanized (Latin alphabet) version of the given name.
  ///
  /// This is the transliteration of the [givenName] into the Latin alphabet,
  /// making it pronounceable for non-Khmer speakers.
  /// Example: 'Dara' for 'ដារា'
  final String romanizedGiven;

  /// The romanized (Latin alphabet) version of the surname.
  ///
  /// This is the transliteration of the [surname] into the Latin alphabet,
  /// making it pronounceable for non-Khmer speakers.
  /// Example: 'Ouch' for 'អ៊ូច'
  final String romanizedSurname;

  /// The meaning of the name, if available.
  ///
  /// This provides the semantic meaning or significance of the name.
  /// May be null if the meaning is unknown or not provided.
  /// Example: 'Star', 'Strength', 'Beauty'
  final String? meaning;

  /// The origin of the name.
  ///
  /// Indicates the linguistic or cultural origin of the name.
  /// Common values include: 'Pali', 'Sanskrit', 'Khmer'.
  /// May be null if the origin is unknown or not provided.
  final String? origin;

  /// The category of the name.
  ///
  /// Categorizes the name based on usage or time period.
  /// Common values include: 'modern', 'traditional', 'royal'.
  /// May be null if the category is unknown or not provided.
  final String? category;

  /// Whether the name is considered popular in Cambodia.
  ///
  /// If true, the name is commonly used; if false, it may be less common.
  final bool isPopular;

  /// Creates a new [KhmerName] instance.
  ///
  /// The [givenName], [surname], [gender], [romanizedGiven], and [romanizedSurname]
  /// parameters are required. Other parameters are optional.
  ///
  /// The [gender] parameter should be one of: 'male', 'female', or 'unisex'.
  ///
  /// Example:
  /// ```dart
  /// final name = KhmerName(
  ///   givenName: 'ដារា',
  ///   surname: 'អ៊ូច',
  ///   gender: 'male',
  ///   romanizedGiven: 'Dara',
  ///   romanizedSurname: 'Ouch',
  ///   meaning: 'Star',
  ///   origin: 'Pali',
  ///   category: 'modern',
  ///   isPopular: true,
  /// );
  /// ```
  const KhmerName({
    required this.givenName,
    required this.surname,
    required this.gender,
    required this.romanizedGiven,
    required this.romanizedSurname,
    this.meaning,
    this.origin,
    this.category,
    this.isPopular = false,
  });

  /// Creates a [KhmerName] from a JSON map.
  ///
  /// This factory constructor converts a JSON object (represented as a Map)
  /// into a [KhmerName] instance. This is particularly useful when loading
  /// name data from JSON files or APIs.
  ///
  /// The JSON map should contain keys matching the field names of this class.
  ///
  /// Example:
  /// ```dart
  /// final json = {
  ///   'givenName': 'ដារា',
  ///   'surname': 'អ៊ូច',
  ///   'gender': 'male',
  ///   'romanizedGiven': 'Dara',
  ///   'romanizedSurname': 'Ouch',
  ///   'meaning': 'Star',
  ///   'origin': 'Pali',
  ///   'category': 'modern',
  ///   'isPopular': true
  /// };
  /// final name = KhmerName.fromJson(json);
  /// ```
  factory KhmerName.fromJson(Map<String, dynamic> json) {
    return KhmerName(
      givenName: json['givenName'] as String,
      surname: json['surname'] as String,
      gender: json['gender'] as String,
      romanizedGiven: json['romanizedGiven'] as String,
      romanizedSurname: json['romanizedSurname'] as String,
      meaning: json['meaning'] as String?,
      origin: json['origin'] as String?,
      category: json['category'] as String?,
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }

  /// Converts this [KhmerName] to a JSON map.
  ///
  /// This method serializes the [KhmerName] instance into a Map that can be
  /// converted to JSON. Optional fields that are null will not be included
  /// in the resulting map.
  ///
  /// This is useful for storing name data or sending it over a network.
  ///
  /// Example:
  /// ```dart
  /// final name = KhmerName(/* ... */);
  /// final json = name.toJson();
  /// final jsonString = jsonEncode(json);
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'givenName': givenName,
      'surname': surname,
      'gender': gender,
      'romanizedGiven': romanizedGiven,
      'romanizedSurname': romanizedSurname,
      if (meaning != null) 'meaning': meaning,
      if (origin != null) 'origin': origin,
      if (category != null) 'category': category,
      'isPopular': isPopular,
    };
  }

  /// Returns the full name in Khmer script.
  ///
  /// Combines the given name and surname with a space in between.
  ///
  /// Example:
  /// ```dart
  /// final name = KhmerName(
  ///   givenName: 'ដារា',
  ///   surname: 'អ៊ូច',
  ///   /* ... */
  /// );
  /// print(name.fullName); // "ដារា អ៊ូច"
  /// ```
  String get fullName => '$givenName $surname';

  /// Returns the full romanized name.
  ///
  /// Combines the romanized given name and surname with a space in between.
  ///
  /// Example:
  /// ```dart
  /// final name = KhmerName(
  ///   romanizedGiven: 'Dara',
  ///   romanizedSurname: 'Ouch',
  ///   /* ... */
  /// );
  /// print(name.fullRomanizedName); // "Dara Ouch"
  /// ```
  String get fullRomanizedName => '$romanizedGiven $romanizedSurname';

  /// Returns a string representation of this name.
  ///
  /// By default, returns the full romanized name.
  @override
  String toString() => fullRomanizedName;

  /// Determines whether the given object is equal to this name.
  ///
  /// Two [KhmerName] objects are considered equal if all their properties
  /// have the same values.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KhmerName &&
        other.givenName == givenName &&
        other.surname == surname &&
        other.gender == gender &&
        other.romanizedGiven == romanizedGiven &&
        other.romanizedSurname == romanizedSurname &&
        other.meaning == meaning &&
        other.origin == origin &&
        other.category == category &&
        other.isPopular == isPopular;
  }

  /// Returns a hash code for this name.
  @override
  int get hashCode {
    return givenName.hashCode ^
        surname.hashCode ^
        gender.hashCode ^
        romanizedGiven.hashCode ^
        romanizedSurname.hashCode ^
        meaning.hashCode ^
        origin.hashCode ^
        category.hashCode ^
        isPopular.hashCode;
  }
}
