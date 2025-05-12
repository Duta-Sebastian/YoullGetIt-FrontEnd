import 'package:flutter/material.dart';

class JobFiltersScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initialLocation;
  final String? initialCompany;
  final String? initialWorkMode;
  final String? initialField;
  final List<String> initialSkills;

  const JobFiltersScreen({
    super.key, 
    this.initialQuery,
    this.initialLocation,
    this.initialCompany,
    this.initialWorkMode,
    this.initialField,
    this.initialSkills = const [],
  });

  @override
  State<JobFiltersScreen> createState() => _JobFiltersScreenState();
}

class _JobFiltersScreenState extends State<JobFiltersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  String? _selectedWorkMode;
  String? _selectedField;
  List<String> _selectedSkills = [];

  final List<String> _workModeOptions = ['All', 'Remote', 'Hybrid', 'On-site'];
  final List<String> _fieldOptions = [
    'All',
    'Software Development',
    'Data Science',
    'Design',
    'Marketing',
    'Finance',
    'Human Resources'
  ];
  final List<String> _skillOptions = [
    'Flutter',
    'Dart',
    'React',
    'Node.js', 
    'Python',
    'AWS',
    'Firebase',
    'JavaScript',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values if provided
    _searchController.text = widget.initialQuery ?? '';
    _locationController.text = widget.initialLocation ?? '';
    _companyController.text = widget.initialCompany ?? '';
    _selectedWorkMode = widget.initialWorkMode;
    _selectedField = widget.initialField;
    _selectedSkills = List.from(widget.initialSkills);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _locationController.clear();
      _companyController.clear();
      _selectedWorkMode = null;
      _selectedField = null;
      _selectedSkills = [];
    });
  }

  void _applyFilters() {
    Navigator.pop(context, {
      'query': _searchController.text,
      'location': _locationController.text,
      'company': _companyController.text,
      'workMode': _selectedWorkMode,
      'field': _selectedField,
      'skills': _selectedSkills,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Filter Jobs',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              'Reset All',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search query
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search jobs, titles...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Company filter
                  const Text(
                    'Company',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      hintText: 'Enter company name',
                      prefixIcon: const Icon(Icons.business),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Location filter
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Enter location/country',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Field filter
                  const Text(
                    'Field',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _fieldOptions.map((field) {
                      final bool isSelected = _selectedField == field;
                      return ChoiceChip(
                        label: Text(field),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedField = selected ? field : null;
                          });
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.blue.shade100,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.blue.shade800 : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Work mode filter
                  const Text(
                    'Work Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _workModeOptions.map((mode) {
                      final bool isSelected = _selectedWorkMode == mode;
                      return ChoiceChip(
                        label: Text(mode),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedWorkMode = selected ? mode : null;
                          });
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.blue.shade100,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.blue.shade800 : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Skills filter
                  const Text(
                    'Skills',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skillOptions.map((skill) {
                      final bool isSelected = _selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: isSelected,
                        onSelected: (selected) {
                          _toggleSkill(skill);
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.blue.shade100,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.blue.shade800 : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        showCheckmark: true,
                        checkmarkColor: Colors.blue.shade800,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Bottom apply button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}