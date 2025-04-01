/// Utility functions for working with Khmer strings and names.
///
/// This class provides static methods for common string operations
/// specific to Khmer text, such as script detection, diacritic removal,
/// and text formatting.
///
/// Example usage:
/// ```dart
/// // Check if text contains Khmer script
/// final hasKhmer = KhmerStringUtils.containsKhmerScript('ដារា Dara');
///
/// // Remove diacritics from romanized Khmer
/// final simplified = KhmerStringUtils.removeDiacritics('Sôvǎn');
/// ```
class KhmerStringUtils {
  /// Private constructor to prevent instantiation of utility class.
  KhmerStringUtils._();

  /// Checks if a string contains Khmer Unicode characters.
  ///
  /// This method tests whether the given [text] contains any characters
  /// from the Khmer Unicode block (U+1780 to U+17FF).
  ///
  /// Returns `true` if the string contains at least one Khmer character,
  /// `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final hasKhmer = KhmerStringUtils.containsKhmerScript('ដារា');     // true
  /// final hasKhmer = KhmerStringUtils.containsKhmerScript('Dara');     // false
  /// final hasKhmer = KhmerStringUtils.containsKhmerScript('ដារា Dara'); // true
  /// ```
  static bool containsKhmerScript(String text) {
    // Khmer Unicode range: \u1780-\u17FF
    final khmerRegex = RegExp(r'[\u1780-\u17FF]');
    return khmerRegex.hasMatch(text);
  }

  /// Removes diacritics from romanized Khmer names.
  ///
  /// This method removes accent marks and other diacritical signs from
  /// romanized Khmer text, converting it to a simplified form with basic
  /// Latin characters only.
  ///
  /// This is useful for search operations or when diacritic-insensitive
  /// matching is desired.
  ///
  /// Returns a new string with diacritics removed.
  ///
  /// Example:
  /// ```dart
  /// final simplified = KhmerStringUtils.removeDiacritics('Sôvǎn');  // 'Sovan'
  /// final simplified = KhmerStringUtils.removeDiacritics('Měněng'); // 'Meneng'
  /// ```
  static String removeDiacritics(String text) {
    // Map of diacritics to their non-diacritic equivalents
    const diacriticsMap = {
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ý': 'y',
      'ỳ': 'y',
      'ŷ': 'y',
      'ÿ': 'y',
      'ǎ': 'a',
      'ě': 'e',
      'ǐ': 'i',
      'ǒ': 'o',
      'ǔ': 'u',
    };

    return text.split('').map((char) => diacriticsMap[char] ?? char).join('');
  }

  /// Capitalizes the first letter of each word in a string.
  ///
  /// This method converts the first character of each word to uppercase
  /// and the rest of the characters to lowercase, creating a properly
  /// capitalized name or title.
  ///
  /// Words are considered to be separated by space characters.
  ///
  /// Returns a new string with capitalized words.
  ///
  /// Example:
  /// ```dart
  /// final capitalized = KhmerStringUtils.capitalizeWords('sok san');  // 'Sok San'
  /// final capitalized = KhmerStringUtils.capitalizeWords('DARA ouch'); // 'Dara Ouch'
  /// ```
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;

    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Checks if two romanized names are phonetically similar.
  ///
  /// This method implements a simplified phonetic similarity check that is
  /// tailored for romanized Khmer names. It removes diacritics and then
  /// calculates the Levenshtein distance (edit distance) between the names.
  ///
  /// Names are considered similar if their simplified forms have an edit
  /// distance of 2 or less.
  ///
  /// Returns `true` if the names are phonetically similar, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final similar = KhmerStringUtils.arePhoneticallySimilar('Sovan', 'Sǒvân');  // true
  /// final similar = KhmerStringUtils.arePhoneticallySimilar('Dara', 'Dora');    // true
  /// final similar = KhmerStringUtils.arePhoneticallySimilar('Phalla', 'Bopha'); // false
  /// ```
  static bool arePhoneticallySimilar(String name1, String name2) {
    // Simplified implementation - remove diacritics and compare
    final simplified1 = removeDiacritics(name1.toLowerCase());
    final simplified2 = removeDiacritics(name2.toLowerCase());

    // Calculate Levenshtein distance (edit distance)
    return _calculateLevenshteinDistance(simplified1, simplified2) <= 2;
  }

  /// Calculates the Levenshtein distance between two strings.
  ///
  /// The Levenshtein distance is a measure of the difference between two strings.
  /// It represents the minimum number of single-character edits (insertions,
  /// deletions, or substitutions) required to change one string into the other.
  ///
  /// This is a private helper method used by [arePhoneticallySimilar].
  ///
  /// Returns an integer representing the edit distance between [s] and [t].
  static int _calculateLevenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.filled(t.length + 1, 0);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i <= t.length; i++) {
      v0[i] = i;
    }

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost]
            .reduce((a, b) => a < b ? a : b);
      }

      for (int j = 0; j <= t.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[t.length];
  }
}
