# KName - ឈ្មោះខ្មែរ

[![Pub](https://img.shields.io/pub/v/kname.svg)](https://pub.dev/packages/kname)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter Platform](https://img.shields.io/badge/Flutter-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue)](https://github.com/sovanken/kname)

A comprehensive Dart/Flutter package for offline Khmer name generation with a database of 1000+ authentic Cambodian names. Perfect for developers building applications with Khmer language support or needing realistic test data.

## 📋 Table of Contents

- [KName - ឈ្មោះខ្មែរ](#kname---ឈ្មោះខ្មែរ)
  - [📋 Table of Contents](#-table-of-contents)
  - [✨ Features](#-features)
  - [📥 Installation](#-installation)
  - [🚀 Usage](#-usage)
    - [Initialize the Package](#initialize-the-package)
    - [Basic Usage](#basic-usage)
    - [Filtering Names](#filtering-names)
    - [Advanced Usage](#advanced-usage)
      - [Generate Multiple Names](#generate-multiple-names)
      - [Create Custom Name Combinations](#create-custom-name-combinations)
      - [Search for Specific Names](#search-for-specific-names)
      - [String Utilities](#string-utilities)
    - [Complete Example](#complete-example)
  - [📚 API Reference](#-api-reference)
    - [KhmerName](#khmername)
    - [KhmerNameGenerator](#khmernamegenerator)
    - [NameFilterOptions](#namefilteroptions)
    - [KhmerStringUtils](#khmerstringutils)
  - [📊 Data Structure](#-data-structure)
  - [⚡ Performance](#-performance)
  - [🤝 Contributing](#-contributing)
  - [📄 License](#-license)

## ✨ Features

- **Comprehensive Dataset**: 1000+ authentic Khmer names with romanized versions
- **Complete Metadata**: Gender, meaning, origin, and category for each name
- **Fully Offline**: Works without internet access and minimal package size
- **Powerful Filtering**: Filter by gender, popularity, origin, meaning, and more
- **Flexible API**: Generate one name, multiple names, or customized name pairs
- **Khmer Script Support**: Access names in both Khmer Unicode and romanized Latin script
- **Detailed Information**: Get meaning, origin, and categorization for cultural authenticity
- **Efficient Implementation**: Fast performance even on low-end devices
- **Deep Customization**: Create specialized name sets for your app's requirements

## 📥 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  kname: ^0.1.1
```

Then run:

```bash
flutter pub get
```

That's it! All name data is bundled with the package, so you don't need to add any additional files.

## 🚀 Usage

### Initialize the Package

Before using KName, initialize the package to load the name data:

```dart
import 'package:kname/kname.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the package first
  await initializeKname();
  
  // Now you can use the package
  runApp(MyApp());
}
```

### Basic Usage

```dart
// Create a name generator
final generator = KhmerNameGenerator();

// Get a random name
final randomName = generator.getRandomName();

// Access name in Khmer script
print('Khmer Name: ${randomName.fullName}');  // ដារា អ៊ូច

// Access romanized version
print('Romanized: ${randomName.fullRomanizedName}');  // Dara Ouch

// Get name information
print('Meaning: ${randomName.meaning}');  // Star
print('Origin: ${randomName.origin}');    // Pali
print('Gender: ${randomName.gender}');    // male
```

### Filtering Names

KName offers powerful filtering capabilities to match specific criteria:

```dart
// Get only female names
final femaleName = generator.getRandomName(
  options: NameFilterOptions(gender: 'female')
);

// Using static constructors for common filters
final maleName = generator.getRandomName(
  options: NameFilterOptions.male()
);

// Get only popular modern names
final modernName = generator.getRandomName(
  options: NameFilterOptions(
    popularOnly: true,
    category: 'modern'
  )
);

// Find names with specific meaning
final starName = generator.getRandomName(
  options: NameFilterOptions(
    meaningContains: 'star'
  )
);

// Combine multiple filters
final traditionalFemaleName = generator.getRandomName(
  options: NameFilterOptions(
    gender: 'female',
    category: 'traditional',
    origin: 'Sanskrit'
  )
);
```

### Advanced Usage

#### Generate Multiple Names

```dart
// Get 5 unique random names
final names = generator.getRandomNames(
  count: 5,
  unique: true
);

// Get 10 popular female names
final popularFemaleNames = generator.getRandomNames(
  count: 10,
  options: NameFilterOptions(
    gender: 'female',
    popularOnly: true
  )
);

// Generate a list of names for dropdown
final dropdownNames = generator.getRandomNames(
  count: 20,
  options: NameFilterOptions.traditional()
);
```

#### Create Custom Name Combinations

```dart
// Mix and match given names and surnames
final customNamePair = generator.getRandomNamePair();
print('${customNamePair['givenName']} ${customNamePair['surname']}');

// Get romanized version
final romanizedPair = generator.getRandomNamePair(romanized: true);
print('${romanizedPair['givenName']} ${romanizedPair['surname']}');
```

#### Search for Specific Names

```dart
// Search for names with specific criteria
final starNames = generator.searchNames(
  options: NameFilterOptions(
    meaningContains: 'star'
  )
);

// Limit search results
final topFivePopularNames = generator.searchNames(
  options: NameFilterOptions(popularOnly: true),
  limit: 5
);
```

#### String Utilities

```dart
// Check if string contains Khmer script
final containsKhmer = KhmerStringUtils.containsKhmerScript('ដារា');  // true

// Remove diacritics from romanized text
final simplified = KhmerStringUtils.removeDiacritics('Sôvǎn');  // Sovan

// Capitalize words properly
final capitalized = KhmerStringUtils.capitalizeWords('sok san');  // Sok San
```

### Complete Example

Here's a complete Flutter widget that demonstrates name generation with filters:

```dart
class KhmerNameGeneratorWidget extends StatefulWidget {
  const KhmerNameGeneratorWidget({Key? key}) : super(key: key);

  @override
  State<KhmerNameGeneratorWidget> createState() => _KhmerNameGeneratorWidgetState();
}

class _KhmerNameGeneratorWidgetState extends State<KhmerNameGeneratorWidget> {
  final _generator = KhmerNameGenerator();
  KhmerName? _currentName;
  String _selectedGender = 'any';
  bool _popularOnly = false;

  @override
  void initState() {
    super.initState();
    _generateName();
  }

  void _generateName() {
    NameFilterOptions? options;
    
    if (_selectedGender != 'any' || _popularOnly) {
      options = NameFilterOptions(
        gender: _selectedGender != 'any' ? _selectedGender : null,
        popularOnly: _popularOnly,
      );
    }
    
    setState(() {
      _currentName = _generator.getRandomName(options: options);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentName == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _currentName!.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _currentName!.fullRomanizedName,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            if (_currentName!.meaning != null)
              Text('Meaning: ${_currentName!.meaning}'),
            Text('Gender: ${_currentName!.gender}'),
            if (_currentName!.origin != null)
              Text('Origin: ${_currentName!.origin}'),
            if (_currentName!.category != null)
              Text('Category: ${_currentName!.category}'),
            Text('Popular: ${_currentName!.isPopular ? "Yes" : "No"}'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Gender:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedGender,
                  items: const [
                    DropdownMenuItem(value: 'any', child: Text('Any')),
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(width: 16),
                Checkbox(
                  value: _popularOnly,
                  onChanged: (value) {
                    setState(() {
                      _popularOnly = value!;
                    });
                  },
                ),
                const Text('Popular only'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateName,
              child: const Text('Generate New Name'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📚 API Reference

### KhmerName

The core model representing a Khmer name:

```dart
KhmerName({
  required String givenName,       // Given name in Khmer script
  required String surname,         // Surname in Khmer script
  required String gender,          // 'male', 'female', or 'unisex'
  required String romanizedGiven,  // Romanized given name
  required String romanizedSurname,// Romanized surname
  String? meaning,                 // Name meaning (if available)
  String? origin,                  // Name origin (e.g., 'Pali', 'Sanskrit')
  String? category,                // Name category (e.g., 'modern', 'traditional')
  bool isPopular = false,          // Whether the name is popular
})
```

**Properties:**
- `fullName`: Gets the full name in Khmer script
- `fullRomanizedName`: Gets the full romanized name

**Methods:**
- `fromJson(Map<String, dynamic> json)`: Create a KhmerName from JSON
- `toJson()`: Convert the name to JSON

### KhmerNameGenerator

The main class for generating and searching names:

```dart
KhmerNameGenerator({int? seed})
```

**Methods:**
- `getRandomName({NameFilterOptions? options})`: Get a single random name
- `getRandomNames({required int count, NameFilterOptions? options, bool unique = true})`: Get multiple random names
- `getRandomNamePair({NameFilterOptions? options, bool romanized = false})`: Get a random given name and surname pair
- `searchNames({required NameFilterOptions options, int limit = 0})`: Search for names matching criteria
- `getAllNames()`: Get all available names

### NameFilterOptions

Options for filtering names:

```dart
NameFilterOptions({
  String? gender,          // 'male', 'female', or 'unisex'
  String? origin,          // Name origin (e.g., 'Pali', 'Sanskrit')
  String? category,        // Name category (e.g., 'modern', 'traditional')
  bool? popularOnly,       // Whether to only include popular names
  String? meaningContains, // Search for names with meaning containing this substring
  String? exactMeaning,    // Search for names with this exact meaning
})
```

**Static Constructors:**
- `NameFilterOptions.male()`: Filter for male names
- `NameFilterOptions.female()`: Filter for female names
- `NameFilterOptions.popular()`: Filter for popular names
- `NameFilterOptions.traditional()`: Filter for traditional names
- `NameFilterOptions.modern()`: Filter for modern names

### KhmerStringUtils

Utility functions for working with Khmer strings:

**Methods:**
- `containsKhmerScript(String text)`: Check if a string contains Khmer script
- `removeDiacritics(String text)`: Remove diacritics from romanized Khmer text
- `capitalizeWords(String text)`: Capitalize the first letter of each word
- `arePhoneticallySimilar(String name1, String name2)`: Check if two names sound similar

## 📊 Data Structure

The package uses a JSON dataset with the following structure:

```json
[
  {
    "givenName": "ដារា",
    "surname": "អ៊ូច",
    "gender": "male",
    "romanizedGiven": "Dara",
    "romanizedSurname": "Ouch",
    "meaning": "Star",
    "origin": "Pali",
    "category": "modern",
    "isPopular": true
  },
  // 1000+ more records...
]
```

All 1000+ names are included in the package and are loaded at initialization time for optimal performance.

## ⚡ Performance

- **Initialization Time**: ~100-200ms on first load (cached afterward)
- **Memory Usage**: ~1-2MB for the complete dataset
- **Search Speed**: O(n) complexity with filter-first optimization
- **Random Generation**: O(1) complexity for single names

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

You can also contribute by:
- Adding more names to the dataset
- Improving romanization accuracy
- Expanding cultural information
- Enhancing documentation
- Reporting bugs

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
