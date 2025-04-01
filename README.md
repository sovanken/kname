# 🇰🇻 kname — Khmer Name Generator for Dart & Flutter

[![Pub Version](https://img.shields.io/pub/v/kname.svg)](https://pub.dev/packages/kname)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter Platform](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter)](https://flutter.dev)

**kname** is a powerful and fully offline-capable Khmer name generator library for Dart and Flutter. It helps you generate culturally accurate Khmer names, complete with romanized versions, gender filtering, metadata (origin, meaning, category), and more.

This package is ideal for mobile apps, education platforms, Khmer-language tools, and personalized user experiences in Khmer-speaking regions.

## ✨ Features

- 🔠 Generate random Khmer names
- ♀️♂️ Gender-based filtering (male, female, unisex)
- 🔍 Filter by category, popularity, or name prefix
- 🌐 Supports native Khmer script & romanized names
- ⚖️ Built-in dataset analysis and statistics
- 🚀 Fully offline (with asset or fallback names)
- ⚙️ Configurable popularity scoring system

## 🚀 Getting Started

### 1. Install from pub.dev

Add the dependency:

```yaml
dependencies:
  kname: ^0.1.0
```

## 🔧 Example Usage

```dart
import 'package:kname/kname.dart';

void main() async {
  final generator = await KnamGenerator.fromAsset();

  final randomName = generator.generate();
  print('Random: ${randomName.fullName}');

  final female = generator.generate(gender: Gender.female);
  print('Female: ${female.romanizedName}');

  final names = generator.generateMultiple(3, onlyPopular: true);
  for (final name in names) {
    print('Popular: ${name.romanizedName}');
  }
}
```

## 📊 Statistics Example

```dart
final stats = generator.getStatistics();
print('Total names: ${stats.totalNames}');
print('Popular: ${stats.popularNames}');
print('By category: ${stats.categories}');
```

## 📂 JSON Format (1000+ entries)

Each record in your dataset should match this structure:

```json
{
  "givenName": "ដារ",
  "surname": "ទ្រេ",
  "romanizedGiven": "Chara",
  "romanizedSurname": "Trey",
  "gender": "unisex",
  "meaning": "Moonlight",
  "origin": "Sanskrit",
  "category": "traditional",
  "isPopular": true
}
```

> If no JSON file is found, the package uses a built-in fallback dataset.

## 🛋️ API Overview

### `KnamGenerator`
- `generate()` — Returns a single [KhmerName]
- `generateMultiple(count)` — Returns a list
- `getStatistics()` — Returns [KnamStatistics]
- `clearCache()` — Clears internal cache

### Filtering Options
- `gender`: `Gender.male`, `Gender.female`, `Gender.unisex`
- `onlyPopular`: `true | false`
- `startsWith`: String
- `minPopularityScore`: int
- `allowedCategories`: List<String>

## 📆 Full Example App

See [`example/lib/main.dart`](example/lib/main.dart):

```dart
final generator = await KnamGenerator.fromAsset();
final name = generator.generate(gender: Gender.male);
print(name.fullName); // Outputs: e.g., ទេ ដារ
```

## 💪 Contributing

Want to improve the dataset? Add features? Contributions are welcome!

- Fork the repo
- Open issues or feature requests
- PRs with more Khmer names are appreciated 🌟

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 About the Author

- GitHub: [sovanken](https://github.com/sovanken)


