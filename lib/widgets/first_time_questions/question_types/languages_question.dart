import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';

class LanguagesWidget extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;

  const LanguagesWidget({
    super.key,
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
  });

  @override
  LanguagesWidgetState createState() => LanguagesWidgetState();
}

class LanguagesWidgetState extends State<LanguagesWidget> {
  late TextEditingController _searchController;
  bool _isDropdownOpen = false;
  List<String> _filteredOptions = [];
  List<String> _filteredTranslations = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredOptions = widget.question.options ?? [];
    _isDropdownOpen = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize filtered options with translations after context is available
    _updateFilteredOptions('');
  }

  @override
  void didUpdateWidget(covariant LanguagesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.question.text != oldWidget.question.text) {
      _searchController.clear();
      _updateFilteredOptions('');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredOptions(String query) {
    if (widget.question.options == null) {
      _filteredOptions = [];
      _filteredTranslations = [];
      return;
    }
    
    final l10n = AppLocalizations.of(context)!;
    final translatedOptions = QuestionTranslationService.getTranslatedOptions(
      widget.question.id, 
      widget.question.options!, 
      l10n
    );
    
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = List.from(widget.question.options!);
        _filteredTranslations = List.from(translatedOptions);
      } else {
        final filteredIndices = <int>[];
        for (int i = 0; i < translatedOptions.length; i++) {
          if (translatedOptions[i].toLowerCase().contains(query.toLowerCase()) ||
              widget.question.options![i].toLowerCase().contains(query.toLowerCase())) {
            filteredIndices.add(i);
          }
        }
        
        _filteredOptions = filteredIndices.map((i) => widget.question.options![i]).toList();
        _filteredTranslations = filteredIndices.map((i) => translatedOptions[i]).toList();
      }
    });
  }

  void _addLanguage(String language, String level) {
    List<String> updatedChoices = List.from(widget.selectedChoices);
    
    // Remove any existing entry for this language
    updatedChoices.removeWhere((choice) => choice.startsWith("$language:"));
    
    // Add the new language with level
    updatedChoices.add("$language:$level");
    widget.onChoicesUpdated(updatedChoices);
  }
  
  void _removeLanguage(String language) {
    List<String> updatedChoices = List.from(widget.selectedChoices);
    updatedChoices.removeWhere((choice) => choice.startsWith("$language:"));
    widget.onChoicesUpdated(updatedChoices);
  }
  
  String? _getLanguageLevel(String language) {
    for (String choice in widget.selectedChoices) {
      if (choice.startsWith("$language:")) {
        return choice.split(":")[1];
      }
    }
    return null;
  }
  
  List<String> _getSelectedLanguages() {
    List<String> languages = [];
    for (String choice in widget.selectedChoices) {
      if (choice.contains(":")) {
        languages.add(choice.split(":")[0]);
      }
    }
    return languages;
  }

  String _getTranslatedLanguage(String originalLanguage) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.question.options?.contains(originalLanguage) == true) {
      final index = widget.question.options!.indexOf(originalLanguage);
      final translatedOptions = QuestionTranslationService.getTranslatedOptions(
        widget.question.id, 
        widget.question.options!, 
        l10n
      );
      return translatedOptions[index];
    }
    return originalLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hintText = QuestionTranslationService.getTranslatedHintText(widget.question.id, l10n);
    List<String> selectedLanguages = _getSelectedLanguages();
    List<String> languageLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selected languages section
        Container(
          constraints: const BoxConstraints(minHeight: 100),
          child: SingleChildScrollView(
            child: selectedLanguages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No languages selected',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: selectedLanguages.map((language) {
                        String level = _getLanguageLevel(language) ?? '';
                        String displayLanguage = _getTranslatedLanguage(language);
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              depth: 3,
                              intensity: 0.5,
                              color: Colors.white,
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          displayLanguage,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => _removeLanguage(language),
                                        child: const Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: languageLevels.map((levelOption) {
                                      bool isSelected = level == levelOption;
                                      return InkWell(
                                        onTap: () {
                                          _addLanguage(language, levelOption);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 6.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected 
                                                ? const Color(0xFFFFDE15)
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isSelected 
                                                  ? const Color(0xFFFFDE15)
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Text(
                                            levelOption,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ),
        
        // Search and dropdown section
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Column(
              children: [
                // Search field
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: 5,
                    intensity: 0.5,
                    color: Colors.white,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: hintText,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            onChanged: (value) {
                              _updateFilteredOptions(value);
                              if (!_isDropdownOpen) {
                                setState(() {
                                  _isDropdownOpen = true;
                                });
                              }
                            },
                            onTap: () {
                              setState(() {
                                _isDropdownOpen = true;
                                _updateFilteredOptions(_searchController.text);
                              });
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isDropdownOpen = !_isDropdownOpen;
                              if (_isDropdownOpen) {
                                _updateFilteredOptions(_searchController.text);
                              }
                            });
                            if (!_isDropdownOpen) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Dropdown list
                if (_isDropdownOpen)
                  Container(
                    margin: const EdgeInsets.only(top: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: _filteredOptions.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _searchController.text.isNotEmpty 
                                  ? 'No matches found'
                                  : 'Start typing to search...',
                              style: TextStyle(color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _filteredOptions.length,
                            itemBuilder: (context, index) {
                              final originalLanguage = _filteredOptions[index];
                              final translatedLanguage = _filteredTranslations[index];
                              final isSelected = selectedLanguages.contains(originalLanguage);
                              
                              return InkWell(
                                onTap: () {
                                  if (!isSelected) {
                                    _addLanguage(originalLanguage, 'A1');
                                  }
                                  _searchController.clear();
                                  _updateFilteredOptions('');
                                  setState(() {
                                    _isDropdownOpen = false;
                                  });
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? const Color(0xFFFFDE15).withOpacity(0.3) 
                                        : Colors.transparent,
                                    border: index < _filteredOptions.length - 1
                                        ? Border(bottom: BorderSide(color: Colors.grey.shade200))
                                        : null,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          translatedLanguage,
                                          style: TextStyle(
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check,
                                          color: Color(0xFFFFDE15),
                                          size: 20,
                                        ),
                                    ],
                                  ),
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
    );
  }
}