import 'package:flutter/material.dart';
import 'package:kname/kname.dart';

void main() async {
  // Ensure Flutter binding is initialized before loading assets
  WidgetsFlutterBinding.ensureInitialized();

  // Load the generator from local JSON asset or fallback to default names
  final generator = await KnamGenerator.fromAsset();

  // Generate a random name
  final randomName = generator.generate();

  // Generate a popular female name
  final femaleName = generator.generate(
    gender: Gender.female,
    onlyPopular: true,
  );

  // Generate multiple modern male names
  final modernMaleNames = generator.generateMultiple(
    3,
    gender: Gender.male,
    allowedCategories: ['modern'],
  );

  // Get dataset statistics
  final stats = generator.getStatistics();

  // Output the results
  runApp(KnameExampleApp(
    randomName: randomName,
    femaleName: femaleName,
    modernMaleNames: modernMaleNames,
    statistics: stats,
  ));
}

/// A simple Flutter app demonstrating usage of the `kname` package.
class KnameExampleApp extends StatelessWidget {
  final KhmerName randomName;
  final KhmerName femaleName;
  final List<KhmerName> modernMaleNames;
  final KnamStatistics statistics;

  const KnameExampleApp({
    super.key,
    required this.randomName,
    required this.femaleName,
    required this.modernMaleNames,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kname Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Kname Generator Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _sectionTitle('🎲 Random Name'),
              _nameCard(randomName),
              _sectionTitle('👧 Popular Female Name'),
              _nameCard(femaleName),
              _sectionTitle('👦 Modern Male Names'),
              ...modernMaleNames.map(_nameCard).toList(),
              _sectionTitle('📊 Statistics'),
              _statsCard(statistics),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _nameCard(KhmerName name) {
    return Card(
      child: ListTile(
        title: Text(name.fullName, style: const TextStyle(fontSize: 18)),
        subtitle: Text(
          '${name.romanizedName} (${name.gender.name})\n'
          'Meaning: ${name.meaning}\n'
          'Origin: ${name.origin}, Category: ${name.category}',
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _statsCard(KnamStatistics stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total names: ${stats.totalNames}'),
            Text('Male names: ${stats.maleNames}'),
            Text('Female names: ${stats.femaleNames}'),
            Text('Unisex names: ${stats.unisexNames}'),
            Text('Popular names: ${stats.popularNames}'),
            const SizedBox(height: 8),
            const Text('Categories:'),
            ...stats.categories.entries.map(
              (e) => Text('- ${e.key}: ${e.value}'),
            ),
          ],
        ),
      ),
    );
  }
}
