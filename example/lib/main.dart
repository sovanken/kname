import 'package:flutter/material.dart';
import 'package:kname/kname.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the kname package to load name data
  await initializeKname();

  runApp(const KnameExampleApp());
}

class KnameExampleApp extends StatelessWidget {
  const KnameExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KName Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Kantumruy', // Khmer-compatible font
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KName Demo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Single Name', icon: Icon(Icons.person)),
            Tab(text: 'Name List', icon: Icon(Icons.list)),
            Tab(text: 'Search', icon: Icon(Icons.search)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SingleNameTab(),
          NameListTab(),
          SearchNameTab(),
        ],
      ),
    );
  }
}

class SingleNameTab extends StatefulWidget {
  const SingleNameTab({Key? key}) : super(key: key);

  @override
  State<SingleNameTab> createState() => _SingleNameTabState();
}

class _SingleNameTabState extends State<SingleNameTab> {
  final _generator = KhmerNameGenerator();
  KhmerName? _currentName;
  String _gender = 'any';
  bool _popularOnly = false;
  String _category = 'any';

  @override
  void initState() {
    super.initState();
    _generateName();
  }

  void _generateName() {
    NameFilterOptions? options;

    if (_gender != 'any' || _popularOnly || _category != 'any') {
      options = NameFilterOptions(
        gender: _gender != 'any' ? _gender : null,
        popularOnly: _popularOnly ? true : null,
        category: _category != 'any' ? _category : null,
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Filter Controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Gender filter
                  Row(
                    children: [
                      const Text('Gender:',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(value: 'any', child: Text('Any')),
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(
                              value: 'female', child: Text('Female')),
                        ],
                      ),
                    ],
                  ),

                  // Category filter
                  Row(
                    children: [
                      const Text('Category:',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _category,
                        onChanged: (value) {
                          setState(() {
                            _category = value!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(value: 'any', child: Text('Any')),
                          DropdownMenuItem(
                              value: 'modern', child: Text('Modern')),
                          DropdownMenuItem(
                              value: 'traditional', child: Text('Traditional')),
                          DropdownMenuItem(
                              value: 'royal', child: Text('Royal')),
                        ],
                      ),
                    ],
                  ),

                  // Popularity filter
                  Row(
                    children: [
                      Checkbox(
                        value: _popularOnly,
                        onChanged: (value) {
                          setState(() {
                            _popularOnly = value!;
                          });
                        },
                      ),
                      const Text('Popular names only'),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Generate button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _generateName,
                      child: const Text('Generate Name'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Name Display
          Expanded(
            child: Center(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Khmer name
                      Text(
                        _currentName!.fullName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Romanized name
                      Text(
                        _currentName!.fullRomanizedName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Divider(height: 32),

                      // Name attributes
                      InfoRow(
                        label: 'Gender',
                        value: _capitalize(_currentName!.gender),
                        icon: _currentName!.gender == 'male'
                            ? Icons.male
                            : Icons.female,
                        color: _currentName!.gender == 'male'
                            ? Colors.blue
                            : Colors.pink,
                      ),

                      if (_currentName!.meaning != null)
                        InfoRow(
                          label: 'Meaning',
                          value: _currentName!.meaning!,
                          icon: Icons.translate,
                          color: Colors.green,
                        ),

                      if (_currentName!.origin != null)
                        InfoRow(
                          label: 'Origin',
                          value: _currentName!.origin!,
                          icon: Icons.history_edu,
                          color: Colors.amber,
                        ),

                      if (_currentName!.category != null)
                        InfoRow(
                          label: 'Category',
                          value: _capitalize(_currentName!.category!),
                          icon: Icons.category,
                          color: Colors.purple,
                        ),

                      InfoRow(
                        label: 'Popular',
                        value: _currentName!.isPopular ? 'Yes' : 'No',
                        icon: Icons.trending_up,
                        color: _currentName!.isPopular
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class NameListTab extends StatefulWidget {
  const NameListTab({Key? key}) : super(key: key);

  @override
  State<NameListTab> createState() => _NameListTabState();
}

class _NameListTabState extends State<NameListTab> {
  final _generator = KhmerNameGenerator();
  final List<KhmerName> _names = [];
  String _gender = 'any';
  bool _popularOnly = false;
  int _count = 10;
  bool _showKhmerScript = true;

  @override
  void initState() {
    super.initState();
    _generateNames();
  }

  void _generateNames() {
    NameFilterOptions? options;

    if (_gender != 'any' || _popularOnly) {
      options = NameFilterOptions(
        gender: _gender != 'any' ? _gender : null,
        popularOnly: _popularOnly ? true : null,
      );
    }

    setState(() {
      _names.clear();
      _names.addAll(_generator.getRandomNames(
        count: _count,
        options: options,
        unique: true,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'List Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Count slider
                  Row(
                    children: [
                      const Text('Count: '),
                      Expanded(
                        child: Slider(
                          value: _count.toDouble(),
                          min: 5,
                          max: 50,
                          divisions: 9,
                          label: _count.toString(),
                          onChanged: (value) {
                            setState(() {
                              _count = value.toInt();
                            });
                          },
                        ),
                      ),
                      Text('$_count'),
                    ],
                  ),

                  // Gender filter
                  Row(
                    children: [
                      const Text('Gender: '),
                      const SizedBox(width: 8),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'any', label: Text('Any')),
                          ButtonSegment(value: 'male', label: Text('Male')),
                          ButtonSegment(value: 'female', label: Text('Female')),
                        ],
                        selected: {_gender},
                        onSelectionChanged: (Set<String> selection) {
                          setState(() {
                            _gender = selection.first;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Popular only
                  Row(
                    children: [
                      Checkbox(
                        value: _popularOnly,
                        onChanged: (value) {
                          setState(() {
                            _popularOnly = value!;
                          });
                        },
                      ),
                      const Text('Popular names only'),

                      const Spacer(),

                      // Script toggle
                      const Text('Script:'),
                      const SizedBox(width: 8),
                      Switch(
                        value: _showKhmerScript,
                        onChanged: (value) {
                          setState(() {
                            _showKhmerScript = value;
                          });
                        },
                        thumbIcon:
                            MaterialStateProperty.resolveWith<Icon?>((states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Icon(Icons.translate);
                          }
                          return const Icon(Icons.abc);
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Generate button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _generateNames,
                      child: const Text('Generate Names'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Names list
          Expanded(
            child: Card(
              child: ListView.separated(
                itemCount: _names.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final name = _names[index];
                  return ListTile(
                    title: Text(
                      _showKhmerScript ? name.fullName : name.fullRomanizedName,
                      style: TextStyle(
                        fontSize: _showKhmerScript ? 18 : 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      _showKhmerScript ? name.fullRomanizedName : name.fullName,
                      style: TextStyle(
                        fontStyle: _showKhmerScript ? FontStyle.italic : null,
                      ),
                    ),
                    trailing: Icon(
                      name.gender == 'male' ? Icons.male : Icons.female,
                      color: name.gender == 'male' ? Colors.blue : Colors.pink,
                    ),
                    leading: CircleAvatar(
                      backgroundColor:
                          name.isPopular ? Colors.amber : Colors.grey,
                      child: Text(
                        _showKhmerScript
                            ? name.givenName.characters.first
                            : name.romanizedGiven[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(name.fullName),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Romanized: ${name.fullRomanizedName}'),
                              if (name.meaning != null)
                                Text('Meaning: ${name.meaning}'),
                              Text('Gender: ${name.gender}'),
                              if (name.origin != null)
                                Text('Origin: ${name.origin}'),
                              if (name.category != null)
                                Text('Category: ${name.category}'),
                              Text('Popular: ${name.isPopular ? "Yes" : "No"}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchNameTab extends StatefulWidget {
  const SearchNameTab({Key? key}) : super(key: key);

  @override
  State<SearchNameTab> createState() => _SearchNameTabState();
}

class _SearchNameTabState extends State<SearchNameTab> {
  final _generator = KhmerNameGenerator();
  final _meaningController = TextEditingController();

  List<KhmerName> _searchResults = [];
  String _selectedGender = 'any';
  String _selectedOrigin = 'any';
  String _selectedCategory = 'any';
  bool _popularOnly = false;
  bool _isExactMatch = false;

  void _performSearch() {
    final meaningText = _meaningController.text.trim();

    if (meaningText.isEmpty &&
        _selectedGender == 'any' &&
        _selectedOrigin == 'any' &&
        _selectedCategory == 'any' &&
        !_popularOnly) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final options = NameFilterOptions(
      gender: _selectedGender != 'any' ? _selectedGender : null,
      origin: _selectedOrigin != 'any' ? _selectedOrigin : null,
      category: _selectedCategory != 'any' ? _selectedCategory : null,
      popularOnly: _popularOnly ? true : null,
      exactMeaning:
          _isExactMatch && meaningText.isNotEmpty ? meaningText : null,
      meaningContains:
          !_isExactMatch && meaningText.isNotEmpty ? meaningText : null,
    );

    setState(() {
      _searchResults = _generator.searchNames(options: options);
    });
  }

  @override
  void dispose() {
    _meaningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search Names',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Meaning search field
                  TextField(
                    controller: _meaningController,
                    decoration: const InputDecoration(
                      labelText: 'Search by meaning',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Exact match toggle
                  Row(
                    children: [
                      Checkbox(
                        value: _isExactMatch,
                        onChanged: (value) {
                          setState(() {
                            _isExactMatch = value!;
                          });
                        },
                      ),
                      const Text('Exact meaning match'),
                    ],
                  ),

                  const Divider(),

                  // Filters
                  ExpansionTile(
                    title: const Text('Advanced Filters'),
                    childrenPadding: const EdgeInsets.all(16),
                    children: [
                      // Gender filter
                      Row(
                        children: [
                          const Text('Gender:',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                  value: 'any', child: Text('Any')),
                              DropdownMenuItem(
                                  value: 'male', child: Text('Male')),
                              DropdownMenuItem(
                                  value: 'female', child: Text('Female')),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Origin filter
                      Row(
                        children: [
                          const Text('Origin:',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: _selectedOrigin,
                            onChanged: (value) {
                              setState(() {
                                _selectedOrigin = value!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                  value: 'any', child: Text('Any')),
                              DropdownMenuItem(
                                  value: 'Pali', child: Text('Pali')),
                              DropdownMenuItem(
                                  value: 'Sanskrit', child: Text('Sanskrit')),
                              DropdownMenuItem(
                                  value: 'Khmer', child: Text('Khmer')),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Category filter
                      Row(
                        children: [
                          const Text('Category:',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: _selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                  value: 'any', child: Text('Any')),
                              DropdownMenuItem(
                                  value: 'modern', child: Text('Modern')),
                              DropdownMenuItem(
                                  value: 'traditional',
                                  child: Text('Traditional')),
                              DropdownMenuItem(
                                  value: 'royal', child: Text('Royal')),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Popularity filter
                      Row(
                        children: [
                          Checkbox(
                            value: _popularOnly,
                            onChanged: (value) {
                              setState(() {
                                _popularOnly = value!;
                              });
                            },
                          ),
                          const Text('Popular names only'),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Search button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _performSearch,
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(
                    child: Text(
                      'Enter search criteria and press Search',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Found ${_searchResults.length} names',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final name = _searchResults[index];
                              return ListTile(
                                title: Row(
                                  children: [
                                    Text(name.fullName),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(${name.fullRomanizedName})',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: name.meaning != null
                                    ? Text('Meaning: ${name.meaning}')
                                    : null,
                                trailing: Chip(
                                  label: Text(name.gender),
                                  backgroundColor: name.gender == 'male'
                                      ? Colors.blue.withOpacity(0.2)
                                      : Colors.pink.withOpacity(0.2),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
