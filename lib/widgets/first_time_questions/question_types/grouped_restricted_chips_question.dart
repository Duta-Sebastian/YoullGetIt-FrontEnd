// widgets/grouped_restricted_chips_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';
import 'package:youllgetit_flutter/data/soft_skills_data.dart';
import 'package:youllgetit_flutter/data/hard_skills_data.dart';

class GroupedRestrictedChipsWidget extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;

  const GroupedRestrictedChipsWidget({
    super.key,
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
  });

  @override
  GroupedRestrictedChipsWidgetState createState() => GroupedRestrictedChipsWidgetState();
}

class GroupedRestrictedChipsWidgetState extends State<GroupedRestrictedChipsWidget> {
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
      if (index >= 0 && index < translatedOptions.length) {
        return translatedOptions[index];
      }
    }
    return originalChoice;
  }

  void _showGroupedSelectionBottomSheet() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _GroupedSelectionBottomSheet(
          question: widget.question,
          selectedChoices: widget.selectedChoices,
          onChoicesUpdated: widget.onChoicesUpdated,
          initialSearchText: _persistentSearchText,
          onSearchTextChanged: (text) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _persistentSearchText = text;
                });
              }
            });
          },
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
                    maxWidth: MediaQuery.of(context).size.width - 64,
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
            onTap: _showGroupedSelectionBottomSheet,
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

class _GroupedSelectionBottomSheet extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;
  final String initialSearchText;
  final Function(String) onSearchTextChanged;

  const _GroupedSelectionBottomSheet({
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
    required this.initialSearchText,
    required this.onSearchTextChanged,
  });

  @override
  _GroupedSelectionBottomSheetState createState() => _GroupedSelectionBottomSheetState();
}

class _GroupedSelectionBottomSheetState extends State<_GroupedSelectionBottomSheet> {
  late TextEditingController _searchController;
  Map<String, List<String>> _filteredGroups = {};
  late List<String> _currentSelections;
  late Set<String> _collapsedGroups; // Track which groups are collapsed

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchText);
    _currentSelections = List.from(widget.selectedChoices);
    _collapsedGroups = <String>{}; // Initialize in initState
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateFilteredOptions(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    widget.onSearchTextChanged(_searchController.text);
    _searchController.dispose();
    super.dispose();
  }

  void _toggleGroupCollapse(String groupName) {
    setState(() {
      if (_collapsedGroups.contains(groupName)) {
        _collapsedGroups.remove(groupName);
      } else {
        _collapsedGroups.add(groupName);
      }
    });
  }

  void _updateFilteredOptions(String query) {
    if (widget.question.options == null || !mounted) {
      setState(() {
        _filteredGroups = {};
      });
      return;
    }

    final l10n = AppLocalizations.of(context);
    
    setState(() {
      _filteredGroups = {};
      
      // Determine if this is soft skills or hard skills based on question ID
      Map<String, List<String>> skillsGroups;
      if (widget.question.id == 'q8') {
        skillsGroups = SoftSkillsData.softSkillsGroups;
      } else if (widget.question.id == 'q9') {
        skillsGroups = HardSkillsData.hardSkillsGroups;
      } else {
        // Fallback - shouldn't happen but handle gracefully
        return;
      }
      
      if (query.isEmpty) {
        // Show all groups with all skills
        for (final groupEntry in skillsGroups.entries) {
          final groupName = groupEntry.key;
          final skillsInGroup = groupEntry.value.where((skill) => 
            widget.question.options!.contains(skill)).toList();
          
          if (skillsInGroup.isNotEmpty) {
            _filteredGroups[groupName] = skillsInGroup;
          }
        }
      } else {
        // Filter skills based on search query
        for (final groupEntry in skillsGroups.entries) {
          final groupName = groupEntry.key;
          final matchingSkills = <String>[];
          
          for (final skill in groupEntry.value) {
            if (!widget.question.options!.contains(skill)) continue;
            
            final localizedSkill = l10n != null ? 
              _getLocalizedSkillName(skill, l10n) : skill;
            final localizedGroup = l10n != null ?
              _getLocalizedGroupName(groupName, l10n) : groupName;
            
            if (localizedSkill.toLowerCase().contains(query.toLowerCase()) ||
                skill.toLowerCase().contains(query.toLowerCase()) ||
                localizedGroup.toLowerCase().contains(query.toLowerCase())) {
              matchingSkills.add(skill);
            }
          }
          
          if (matchingSkills.isNotEmpty) {
            _filteredGroups[groupName] = matchingSkills;
          }
        }
      }
    });
    
    widget.onSearchTextChanged(query);
  }

  String _getLocalizedSkillName(String skillName, AppLocalizations l10n) {
    if (widget.question.id == 'q8') {
      return QuestionTranslationService.translateSoftSkill(skillName, l10n);
    } else if (widget.question.id == 'q9') {
      return QuestionTranslationService.translateHardSkill(skillName, l10n);
    }
    return skillName;
  }

  String _getLocalizedGroupName(String groupName, AppLocalizations l10n) {
    if (widget.question.id == 'q8') {
      return QuestionTranslationService.translateSoftSkillGroup(groupName, l10n);
    } else if (widget.question.id == 'q9') {
      return QuestionTranslationService.translateHardSkillGroup(groupName, l10n);
    }
    return groupName;
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
                    widget.question.id == 'q8' 
                        ? (l10n?.questionSoftSkills ?? 'Select Soft Skills')
                        : (l10n?.questionHardSkills ?? 'Select Hard Skills'),
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

          // Search field
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

          // Selected count with expand/collapse all button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFFFDE15).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.category, color: Color(0xFFFFDE15), size: 16),
                    SizedBox(width: 8),
                    Text(
                      _currentSelections.isNotEmpty 
                          ? (l10n?.selectedCount(_currentSelections.length) ?? '${_currentSelections.length} selected')
                          : '${_filteredGroups.length} categories',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                // Expand/Collapse all button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_collapsedGroups.length == _filteredGroups.length) {
                        // If all are collapsed, expand all
                        _collapsedGroups.clear();
                      } else {
                        // Collapse all
                        _collapsedGroups.addAll(_filteredGroups.keys);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFDE15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _collapsedGroups.length == _filteredGroups.length
                              ? Icons.expand_more
                              : Icons.expand_less,
                          size: 16,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _collapsedGroups.length == _filteredGroups.length
                              ? l10n?.expandAll ?? 'Expand All'
                              : l10n?.collapseAll ?? 'Collapse All',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Grouped options list
          Expanded(
            child: _filteredGroups.isEmpty
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
                    itemCount: _filteredGroups.length,
                    itemBuilder: (context, groupIndex) {
                      final groupName = _filteredGroups.keys.elementAt(groupIndex);
                      final skillsInGroup = _filteredGroups[groupName]!;
                      final localizedGroupName = l10n != null ? 
                        _getLocalizedGroupName(groupName, l10n) : groupName;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Group header - Now clickable to collapse/expand
                          GestureDetector(
                            onTap: () => _toggleGroupCollapse(groupName),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFDE15).withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFFFDE15).withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      localizedGroupName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  // Show skill count and collapse/expand icon
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFDE15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${skillsInGroup.length}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  AnimatedRotation(
                                    turns: _collapsedGroups.contains(groupName) ? -0.5 : 0,
                                    duration: Duration(milliseconds: 200),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black87,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Skills in group - Only show if not collapsed
                          if (!_collapsedGroups.contains(groupName)) ...[
                            ...skillsInGroup.map((skill) {
                              final isSelected = _currentSelections.contains(skill);
                              final localizedSkill = l10n != null ?
                                _getLocalizedSkillName(skill, l10n) : skill;
                              
                              return Container(
                                margin: EdgeInsets.only(bottom: 8, left: 16),
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
                                    localizedSkill,
                                    style: TextStyle(
                                      fontSize: 15,
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
                                  onTap: () => _toggleChoice(skill),
                                ),
                              );
                            }),
                          ],
                          
                          SizedBox(height: 16),
                        ],
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