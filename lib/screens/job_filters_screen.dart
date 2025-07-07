import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/widgets/skills_filter_widget.dart';

class JobFiltersScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initialLocation;
  final String? initialCompany;
  final List<String>? initialWorkMode;
  final List<String>? initialField;
  final List<String>? initialSkills;
  final List<String>? initialDurations;

  const JobFiltersScreen({
    super.key, 
    this.initialQuery,
    this.initialLocation,
    this.initialCompany,
    this.initialWorkMode,
    this.initialField,
    this.initialSkills,
    this.initialDurations,
  });

  @override
  State<JobFiltersScreen> createState() => _JobFiltersScreenState();
}

class _JobFiltersScreenState extends State<JobFiltersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  List<String> _selectedDurations = [];
  List<String> _selectedFields = [];
  List<String> _selectedWorkModes = [];
  List<String> _selectedSkills = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values if provided
    _searchController.text = widget.initialQuery ?? '';
    _locationController.text = widget.initialLocation ?? '';
    _companyController.text = widget.initialCompany ?? '';
    _selectedFields = widget.initialField != null ? List.from(widget.initialField!) : [];
    _selectedSkills = widget.initialSkills != null? List.from(widget.initialSkills!) : [];
    _selectedWorkModes = widget.initialWorkMode != null? List.from(widget.initialWorkMode!) : [];

    // Initialize durations
    _selectedDurations = [];
    if (widget.initialDurations != null) {
      for (String durationValue in widget.initialDurations!) {
        final matchingOption = _getDurationOptions().firstWhere(
          (option) => option['value'] == durationValue,
          orElse: () => {},
        );
        if (matchingOption.isNotEmpty) {
          _selectedDurations.add(matchingOption['label']);
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getDurationOptions() {
    final localizations = AppLocalizations.of(context)!;
    return [
      {
        'label': localizations.optionOneToThreeMonths, 
        'iconPath': 'assets/1-3months.png',
        'value': '1-3'
      },
      {
        'label': localizations.optionThreeToSixMonths, 
        'iconPath': 'assets/3-6months.png',
        'value': '3-6'
      },
      {
        'label': localizations.optionSixToTwelveMonths, 
        'iconPath': 'assets/6-12months.png',
        'value': '6-12'
      },
      {
        'label': localizations.optionMoreThanTwelveMonths, 
        'iconPath': 'assets/12months.png',
        'value': '12+'
      },
    ];
  }

  List<String> _getWorkModeOptions() {
    final localizations = AppLocalizations.of(context)!;
    return [localizations.workModeRemote, localizations.workModeHybrid, localizations.workModeOnSite];
  }

  List<String> _getFieldOptions() {
    final localizations = AppLocalizations.of(context)!;
    return [
      localizations.optionEngineering, 
      localizations.optionItDataScience, 
      localizations.optionMarketingCommunication, 
      localizations.optionFinanceEconomics, 
      localizations.optionPoliticalScience, 
      localizations.optionSalesBusiness, 
      localizations.optionArtsCulture, 
      localizations.optionBiologyChemistry
    ];
  }

  void _toggleWorkMode(String mode) {
    setState(() {
      if (_selectedWorkModes.contains(mode)) {
        _selectedWorkModes.remove(mode);
      } else {
        _selectedWorkModes.add(mode);
      }
    });
  }

  void _toggleField(String field) {
    setState(() {
      if (_selectedFields.contains(field)) {
        _selectedFields.remove(field);
      } else {
        _selectedFields.add(field);
      }
    });
  }

  void _toggleDuration(String duration) {
    setState(() {
      if (_selectedDurations.contains(duration)) {
        _selectedDurations.remove(duration);
      } else {
        _selectedDurations.add(duration);
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _locationController.clear();
      _companyController.clear();
      _selectedWorkModes = [];
      _selectedFields = [];
      _selectedDurations = [];
      _selectedSkills = [];
    });
  }

  void _applyFilters() {
    // Convert selected duration labels to API values
    List<String> durationValues = [];
    for (String selectedLabel in _selectedDurations) {
      final selectedOption = _getDurationOptions().firstWhere(
        (option) => option['label'] == selectedLabel,
        orElse: () => {},
      );
      if (selectedOption.isNotEmpty) {
        durationValues.add(selectedOption['value']);
      }
    }

    Navigator.pop(context, {
      'query': _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      'location': _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      'company': _companyController.text.trim().isEmpty ? null : _companyController.text.trim(),
      'workModes': _selectedWorkModes.isEmpty ? null : _selectedWorkModes,
      'fields': _selectedFields.isEmpty ? null : _selectedFields,
      'durations': durationValues.isEmpty ? null : durationValues,
      'skills': _selectedSkills.isEmpty ? null : _selectedSkills,
    });
  }

  Widget _buildDurationCard(Map<String, dynamic> duration, AppLocalizations localizations) {
    final bool isSelected = _selectedDurations.contains(duration['label']);
    final Color selectedColor = Color(0xFFFFDE15);
    
    return GestureDetector(
      onTap: () => _toggleDuration(duration['label']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withAlpha(38) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
            ? [
                BoxShadow(
                  color: selectedColor.withAlpha(51),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected 
                  ? selectedColor 
                  : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                duration['iconPath'], // Use your custom PNG
                width: 24,
                height: 24,
                color: isSelected ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                duration['label'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.black87 : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  localizations.jobFiltersSelected,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          localizations.jobFiltersTitle,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              localizations.jobFiltersResetAll,
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
                  Text(
                    localizations.jobFiltersSearch,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: localizations.jobFiltersSearchPlaceholder,
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
                  Text(
                    localizations.jobFiltersCompany,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      hintText: localizations.jobFiltersCompanyPlaceholder,
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
                  Text(
                    localizations.jobFiltersLocation,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: localizations.jobFiltersLocationPlaceholder,
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
                  
                  // Duration filter with custom PNG icons
                  Text(
                    localizations.jobFiltersDuration,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _getDurationOptions().length,
                    itemBuilder: (context, index) {
                      return _buildDurationCard(_getDurationOptions()[index], localizations);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Field filter
                  Text(
                    localizations.jobFiltersField,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getFieldOptions().map((field) {
                      final bool isSelected = _selectedFields.contains(field);
                      return FilterChip(
                        label: Text(field),
                        selected: isSelected,
                        onSelected: (selected) => _toggleField(field),
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Color(0xFFFFDE15).withAlpha(51),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black87 : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        showCheckmark: true,
                        checkmarkColor: Colors.black87,
                        side: BorderSide(
                          color: isSelected ? Color(0xFFFFDE15) : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Work mode filter
                  Text(
                    localizations.jobFiltersWorkMode,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getWorkModeOptions().map((mode) {
                      final bool isSelected = _selectedWorkModes.contains(mode);
                      return FilterChip(
                        label: Text(mode),
                        selected: isSelected,
                        onSelected: (selected) => _toggleWorkMode(mode),
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Color(0xFFFFDE15).withAlpha(51),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black87 : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        showCheckmark: true,
                        checkmarkColor: Colors.black87,
                        side: BorderSide(
                          color: isSelected ? Color(0xFFFFDE15) : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SkillsFilterWidget(
                    selectedSkills: _selectedSkills,
                    onSkillsChanged: (skills) {
                      setState(() {
                        _selectedSkills = skills;
                      });
                    },
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
                child: Text(
                  localizations.jobFiltersApplyFilters,
                  style: const TextStyle(
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