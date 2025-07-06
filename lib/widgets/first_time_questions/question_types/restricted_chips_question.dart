import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';

class RestrictedChipsWidget extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;

  const RestrictedChipsWidget({
    super.key,
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
  });

  @override
  RestrictedChipsWidgetState createState() => RestrictedChipsWidgetState();
}

class RestrictedChipsWidgetState extends State<RestrictedChipsWidget> {
  // Persistent search state
  String _persistentSearchText = '';

  String _getDisplayText(String originalChoice) {
    if (!mounted) return originalChoice;
    
    AppLocalizations? l10n;
    try {
      l10n = AppLocalizations.of(context);
    } catch (e) {
      return originalChoice;
    }
    
    if (l10n == null) return originalChoice;
    
    if (widget.question.options?.contains(originalChoice) == true) {
      final index = widget.question.options!.indexOf(originalChoice);
      final translatedOptions = QuestionTranslationService.getTranslatedOptions(
        widget.question.id, 
        widget.question.options!, 
        l10n
      );
      // Safety check for index bounds
      if (index >= 0 && index < translatedOptions.length) {
        return translatedOptions[index];
      }
    }
    return originalChoice;
  }

  void _showSelectionBottomSheet() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _SelectionBottomSheet(
          question: widget.question,
          selectedChoices: widget.selectedChoices,
          onChoicesUpdated: widget.onChoicesUpdated,
          initialSearchText: _persistentSearchText,
          onSearchTextChanged: (text) {
            // Defer setState to avoid calling it during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _persistentSearchText = text;
                });
              }
            });
          },
          onDismiss: () {},
        );
      },
    );
  }

  void _removeChip(String option) {
    List<String> updatedChoices = List.from(widget.selectedChoices);
    updatedChoices.remove(option);
    widget.onChoicesUpdated(updatedChoices);
    HapticFeedback.lightImpact();
  }

  void _clearSearch() {
    // Defer setState to avoid calling it during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _persistentSearchText = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hintText = l10n != null 
        ? QuestionTranslationService.getTranslatedHintText(widget.question.id, l10n)
        : l10n?.hintSearchAndSelect ?? 'Search and select';

    // Show current search text if exists
    final displayHint = _persistentSearchText.isNotEmpty 
        ? 'Searching: "$_persistentSearchText"'
        : hintText;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected chips display
          if (widget.selectedChoices.isNotEmpty) ...[
            Text(
              l10n?.selectedCount(widget.selectedChoices.length) ?? '${widget.selectedChoices.length} selected',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selectedChoices.map((choice) {
                final displayText = _getDisplayText(choice);
                return Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 64, // Account for padding
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFDE15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          displayText,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _removeChip(choice),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
          ],

          // Search field button (opens bottom sheet)
          GestureDetector(
            onTap: _showSelectionBottomSheet,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _persistentSearchText.isNotEmpty 
                      ? Color(0xFFFFDE15) 
                      : Colors.grey.shade300,
                  width: _persistentSearchText.isNotEmpty ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: _persistentSearchText.isNotEmpty 
                    ? Color(0xFFFFDE15).withValues(alpha: 0.1)
                    : Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search, 
                    color: Color(0xFFFFDE15),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      displayHint,
                      style: TextStyle(
                        color: _persistentSearchText.isNotEmpty 
                            ? Colors.black87 
                            : Colors.grey[600],
                        fontSize: 16,
                        fontWeight: _persistentSearchText.isNotEmpty 
                            ? FontWeight.w500 
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (_persistentSearchText.isNotEmpty) ...[
                    GestureDetector(
                      onTap: _clearSearch,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.clear,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                  if (widget.selectedChoices.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFDE15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.selectedChoices.length}',
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
          if (widget.selectedChoices.isEmpty)
            Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  l10n?.hintChipsEmptyList ?? 'Tap above to search and select options',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Clear all button
          if (widget.selectedChoices.isNotEmpty)
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

class _SelectionBottomSheet extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;
  final String initialSearchText;
  final Function(String) onSearchTextChanged;
  final VoidCallback onDismiss;

  const _SelectionBottomSheet({
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
    required this.initialSearchText,
    required this.onSearchTextChanged,
    required this.onDismiss,
  });

  @override
  _SelectionBottomSheetState createState() => _SelectionBottomSheetState();
}

class _SelectionBottomSheetState extends State<_SelectionBottomSheet> {
  late TextEditingController _searchController;
  List<String> _filteredOptions = [];
  List<String> _filteredTranslations = [];
  late List<String> _currentSelections;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchText);
    _currentSelections = List.from(widget.selectedChoices);
    _filteredOptions = widget.question.options ?? [];
    _filteredTranslations = widget.question.options ?? []; // Initialize with same data
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateFilteredOptions(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    // Save search text before disposing
    widget.onSearchTextChanged(_searchController.text);
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredOptions(String query) {
    if (widget.question.options == null || !mounted) {
      setState(() {
        _filteredOptions = [];
        _filteredTranslations = [];
      });
      return;
    }
    
    AppLocalizations? l10n;
    List<String> translatedOptions;
    
    try {
      l10n = AppLocalizations.of(context);
      if (l10n != null) {
        translatedOptions = QuestionTranslationService.getTranslatedOptions(
          widget.question.id, 
          widget.question.options!, 
          l10n
        );
      } else {
        translatedOptions = List.from(widget.question.options!);
      }
    } catch (e) {
      // Fallback to original options if translation fails
      translatedOptions = List.from(widget.question.options!);
    }
    
    // Ensure both lists have the same length
    if (translatedOptions.length != widget.question.options!.length) {
      translatedOptions = List.from(widget.question.options!);
    }
    
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = List.from(widget.question.options!);
        _filteredTranslations = List.from(translatedOptions);
      } else {
        final filteredData = <int, MapEntry<String, String>>{};
        
        for (int i = 0; i < widget.question.options!.length; i++) {
          final original = widget.question.options![i];
          final translated = i < translatedOptions.length ? translatedOptions[i] : original;
          
          if (translated.toLowerCase().contains(query.toLowerCase()) ||
              original.toLowerCase().contains(query.toLowerCase())) {
            filteredData[i] = MapEntry(original, translated);
          }
        }
        
        _filteredOptions = filteredData.values.map((entry) => entry.key).toList();
        _filteredTranslations = filteredData.values.map((entry) => entry.value).toList();
      }
    });
    
    // Update persistent search text
    widget.onSearchTextChanged(query);
  }

  void _toggleChoice(String option) {
    setState(() {
      if (_currentSelections.contains(option)) {
        _currentSelections.remove(option);
      } else {
        _currentSelections.add(option);
      }
    });
    HapticFeedback.selectionClick();
  }

  void _clearSearch() {
    _searchController.clear();
    _updateFilteredOptions('');
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
        : l10n?.hintSearchAndSelect ?? 'Search options...';

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
                    l10n?.hintSearchAndSelect ?? 'Select Options',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Search field with clear button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: Icon(Icons.search, color: Color(0xFFFFDE15)),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: _clearSearch,
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        tooltip: 'Clear search',
                      ),
                    if (_currentSelections.isNotEmpty)
                      Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFDE15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_currentSelections.length}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
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
          if (_currentSelections.isNotEmpty)
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
                    l10n?.selectedCount(_currentSelections.length) ?? '${_currentSelections.length} selected',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

          SizedBox(height: 16),

          // Options list
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
                      // Safety check for index bounds
                      if (index >= _filteredOptions.length || index >= _filteredTranslations.length) {
                        return SizedBox.shrink();
                      }
                      
                      final option = _filteredOptions[index];
                      final translatedOption = _filteredTranslations[index];
                      final isSelected = _currentSelections.contains(option);
                      
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
                            translatedOption,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
                          onTap: () => _toggleChoice(option),
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
                if (_currentSelections.isNotEmpty)
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
                if (_currentSelections.isNotEmpty) SizedBox(width: 16),
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