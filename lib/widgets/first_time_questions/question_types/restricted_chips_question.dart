import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  List<String> _filteredOptions = [];
  List<String> _filteredTranslations = [];
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _filteredOptions = widget.question.options ?? [];
    
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _searchController.text.isEmpty) {
        setState(() {
          _showDropdown = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize filtered options with translations after context is available
    _updateFilteredOptions('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateFilteredOptions(String query) {
    if (widget.question.options == null) return;
    
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
      _showDropdown = _filteredOptions.isNotEmpty;
    });
  }

  void _toggleChoice(String option) {
    List<String> updatedChoices = List.from(widget.selectedChoices);
    
    if (updatedChoices.contains(option)) {
      updatedChoices.remove(option);
    } else {
      updatedChoices.add(option);
    }
    
    widget.onChoicesUpdated(updatedChoices);
  }

  void _removeChip(String option) {
    List<String> updatedChoices = List.from(widget.selectedChoices);
    updatedChoices.remove(option);
    widget.onChoicesUpdated(updatedChoices);
  }

  void _toggleDropdown() {
    setState(() {
      _showDropdown = !_showDropdown;
      if (_showDropdown) {
        _updateFilteredOptions(_searchController.text);
      } else {
        _focusNode.unfocus();
      }
    });
  }

  String _getDisplayText(String originalChoice) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.question.options?.contains(originalChoice) == true) {
      final index = widget.question.options!.indexOf(originalChoice);
      final translatedOptions = QuestionTranslationService.getTranslatedOptions(
        widget.question.id, 
        widget.question.options!, 
        l10n
      );
      return translatedOptions[index];
    }
    return originalChoice;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hintText = QuestionTranslationService.getTranslatedHintText(widget.question.id, l10n);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - keyboardHeight - 200;
    final dropdownHeight = keyboardHeight > 0 
        ? (availableHeight * 0.3).clamp(120.0, 200.0)
        : 200.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field with dropdown toggle
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12.0),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showDropdown ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                  onPressed: _toggleDropdown,
                ),
              ),
              onChanged: _updateFilteredOptions,
              onTap: () {
                setState(() {
                  _showDropdown = true;
                  _updateFilteredOptions(_searchController.text);
                });
              },
            ),
          ),
        ),

        // Dropdown options list
        if (_showDropdown)
          Container(
            height: dropdownHeight,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _filteredOptions.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _searchController.text.isNotEmpty 
                            ? 'No matches found'
                            : 'Start typing to search...',
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredOptions.length,
                    itemBuilder: (context, index) {
                      final originalOption = _filteredOptions[index];
                      final translatedOption = _filteredTranslations[index];
                      final isSelected = widget.selectedChoices.contains(originalOption);
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFDE15).withOpacity(0.3) : Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          title: Text(translatedOption),
                          trailing: isSelected 
                              ? const Icon(Icons.check, color: Color(0xFFFFDE15)) 
                              : null,
                          onTap: () => _toggleChoice(originalOption),
                        ),
                      );
                    },
                  ),
          ),

        const SizedBox(height: 8),

        // Selected chips
        if (widget.selectedChoices.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.selectedChoices.map((originalChoice) {
                final displayText = _getDisplayText(originalChoice);
                
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDE15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayText,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _removeChip(originalChoice),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

        if (widget.selectedChoices.isEmpty)
          Container(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'No items selected',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),

        // Add some bottom padding when keyboard is visible
        if (keyboardHeight > 0)
          const SizedBox(height: 20),
      ],
    );
  }
}