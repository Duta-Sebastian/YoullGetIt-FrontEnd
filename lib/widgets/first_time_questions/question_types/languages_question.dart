import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
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
  void _showLanguageSelectionBottomSheet() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _LanguageSelectionBottomSheet(
          question: widget.question,
          selectedChoices: widget.selectedChoices,
          onChoicesUpdated: widget.onChoicesUpdated,
          onDismiss: () {},
        );
      },
    );
  }

  void _addLanguage(String language, String level) {
    List<String> updatedChoices = List.from(widget.selectedChoices);
    
    // Remove any existing entry for this language
    updatedChoices.removeWhere((choice) => choice.startsWith("$language:"));
    
    // Add the new language with level
    updatedChoices.add("$language:$level");
    widget.onChoicesUpdated(updatedChoices);
    HapticFeedback.selectionClick();
  }
  
  void _removeLanguage(String language) {
    List<String> updatedChoices = List.from(widget.selectedChoices);
    updatedChoices.removeWhere((choice) => choice.startsWith("$language:"));
    widget.onChoicesUpdated(updatedChoices);
    HapticFeedback.lightImpact();
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
    if (!mounted) return originalLanguage;
    
    AppLocalizations? l10n;
    try {
      l10n = AppLocalizations.of(context);
    } catch (e) {
      return originalLanguage;
    }
    
    if (l10n == null) return originalLanguage;
    
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
    final l10n = AppLocalizations.of(context);
    final hintText = l10n != null 
        ? QuestionTranslationService.getTranslatedHintText(widget.question.id, l10n)
        : l10n?.hintSearchAndSelect ?? 'Search and select languages';
    
    List<String> selectedLanguages = _getSelectedLanguages();
    List<String> languageLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected languages display
          if (selectedLanguages.isNotEmpty) ...[
            Text(
              l10n?.selectedCount(selectedLanguages.length) ?? '${selectedLanguages.length} selected',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12),
            ...selectedLanguages.map((language) {
              String level = _getLanguageLevel(language) ?? 'A1';
              String displayLanguage = _getTranslatedLanguage(language);
              
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFFFDE15), width: 2),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Language name and remove button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              displayLanguage,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _removeLanguage(language),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      
                      // Level selection chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: languageLevels.map((levelOption) {
                            bool isSelected = level == levelOption;
                            return Container(
                              margin: EdgeInsets.only(right: 8), // Add margin between chips
                              child: GestureDetector(
                                onTap: () => _addLanguage(language, levelOption),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? Color(0xFFFFDE15)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected 
                                          ? Color(0xFFFFDE15)
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    levelOption,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 16),
          ],

          // Search field button (opens bottom sheet)
          GestureDetector(
            onTap: _showLanguageSelectionBottomSheet,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Color(0xFFFFDE15)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      hintText,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (selectedLanguages.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFDE15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${selectedLanguages.length}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                ],
              ),
            ),
          ),

          // Empty state
          if (selectedLanguages.isEmpty)
            Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  l10n?.hintChipsEmptyList ?? 'Tap above to search and select languages',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Clear all button
          if (selectedLanguages.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                child: TextButton(
                  onPressed: () => widget.onChoicesUpdated([]),
                  child: Text(
                    l10n?.clearAllSelections ?? 'Clear All',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.w600,
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

class _LanguageSelectionBottomSheet extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;
  final VoidCallback onDismiss;

  const _LanguageSelectionBottomSheet({
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
    required this.onDismiss,
  });

  @override
  _LanguageSelectionBottomSheetState createState() => _LanguageSelectionBottomSheetState();
}

class _LanguageSelectionBottomSheetState extends State<_LanguageSelectionBottomSheet> {
  late TextEditingController _searchController;
  List<String> _filteredOptions = [];
  List<String> _filteredTranslations = [];
  late List<String> _currentSelections;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _currentSelections = List.from(widget.selectedChoices);
    _filteredOptions = widget.question.options ?? [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFilteredOptions('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredOptions(String query) {
    if (widget.question.options == null || !mounted) return;
    
    AppLocalizations? l10n;
    try {
      l10n = AppLocalizations.of(context);
    } catch (e) {
      setState(() {
        _filteredOptions = List.from(widget.question.options!);
        _filteredTranslations = List.from(widget.question.options!);
      });
      return;
    }
    
    if (l10n == null) return;
    
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

  void _addLanguage(String language) {
    setState(() {
      // Remove any existing entry for this language
      _currentSelections.removeWhere((choice) => choice.startsWith("$language:"));
      // Add with default A1 level
      _currentSelections.add("$language:A1");
    });
    HapticFeedback.selectionClick();
  }

  void _removeLanguage(String language) {
    setState(() {
      _currentSelections.removeWhere((choice) => choice.startsWith("$language:"));
    });
    HapticFeedback.lightImpact();
  }

  List<String> _getSelectedLanguages() {
    List<String> languages = [];
    for (String choice in _currentSelections) {
      if (choice.contains(":")) {
        languages.add(choice.split(":")[0]);
      }
    }
    return languages;
  }

  void _applyChanges() {
    widget.onChoicesUpdated(_currentSelections);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hintText = l10n != null 
        ? QuestionTranslationService.getTranslatedHintText(widget.question.id, l10n)
        : l10n?.hintSearchAndSelect ?? 'Search languages...';

    final selectedLanguages = _getSelectedLanguages();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    l10n?.hintSearchAndSelect ?? 'Select Languages',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: _applyChanges,
                  child: Text(
                    l10n?.questionsFinish ?? 'Done',
                    style: TextStyle(
                      color: Color(0xFFFFDE15),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: Icon(Icons.search, color: Color(0xFFFFDE15)),
                suffixIcon: selectedLanguages.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFDE15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${selectedLanguages.length}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFFFDE15), width: 2),
                ),
              ),
              onChanged: _updateFilteredOptions,
            ),
          ),

          SizedBox(height: 16),

          // Selected count
          if (selectedLanguages.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFFDE15).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Color(0xFFFFDE15), size: 16),
                  SizedBox(width: 8),
                  Text(
                    l10n?.selectedCount(selectedLanguages.length) ?? '${selectedLanguages.length} selected',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

          SizedBox(height: 16),

          // Languages list
          Expanded(
            child: _filteredOptions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                        SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty 
                              ? (l10n?.restrictedChipsNoMatches ?? 'No matches found')
                              : (l10n?.restrictedChipsStartTyping ?? 'Start typing to search'),
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredOptions.length,
                    itemBuilder: (context, index) {
                      final language = _filteredOptions[index];
                      final translatedLanguage = _filteredTranslations[index];
                      final isSelected = selectedLanguages.contains(language);
                      
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFFFFDE15).withValues(alpha: 0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Color(0xFFFFDE15) : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            translatedLanguage,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          trailing: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isSelected ? Color(0xFFFFDE15) : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? Color(0xFFFFDE15) : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.black,
                                  )
                                : null,
                          ),
                          onTap: () {
                            if (isSelected) {
                              _removeLanguage(language);
                            } else {
                              _addLanguage(language);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),

          // Bottom actions
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                if (selectedLanguages.isNotEmpty)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _currentSelections.clear();
                        });
                      },
                      child: Text(
                        l10n?.clearAllSelections ?? 'Clear All',
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    ),
                  ),
                if (selectedLanguages.isNotEmpty) SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFDE15),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n?.questionsFinish ?? 'Apply Selection',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}