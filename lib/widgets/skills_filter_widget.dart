import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/data/hard_skills_data.dart';
import 'package:youllgetit_flutter/data/soft_skills_data.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/services/question_translation_service.dart';

class SkillsFilterWidget extends StatefulWidget {
  final List<String> selectedSkills;
  final Function(List<String>) onSkillsChanged;

  const SkillsFilterWidget({
    super.key,
    required this.selectedSkills,
    required this.onSkillsChanged,
  });

  @override
  State<SkillsFilterWidget> createState() => _SkillsFilterWidgetState();
}

class _SkillsFilterWidgetState extends State<SkillsFilterWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  
  String _searchQuery = '';
  
  late Set<String> _selectedSkillsSet;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedSkillsSet = widget.selectedSkills.toSet();
  }

  @override
  void didUpdateWidget(SkillsFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSkills != widget.selectedSkills) {
      _selectedSkillsSet = widget.selectedSkills.toSet();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSkill(String skill) {
    final updatedSkills = List<String>.from(widget.selectedSkills);
    if (updatedSkills.contains(skill)) {
      updatedSkills.remove(skill);
    } else {
      updatedSkills.add(skill);
    }
    widget.onSkillsChanged(updatedSkills);
  }

  void _clearAllSkills() {
    widget.onSkillsChanged([]);
  }



  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final selectedCount = widget.selectedSkills.length;
    final hardSkillsSelected = widget.selectedSkills.where((skill) => 
        HardSkillsData.getAllHardSkills().contains(skill)).length;
    final softSkillsSelected = widget.selectedSkills.where((skill) => 
        SoftSkillsData.getAllSoftSkills().contains(skill)).length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with selected count
        Row(
          children: [
            Expanded(
              child: Text(
                localizations.jobFiltersSkills,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (selectedCount > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDE15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: Colors.black87),
                    const SizedBox(width: 4),
                    Text(
                      '$selectedCount ${localizations.skillsSelected}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _clearAllSkills,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(
                  localizations.clearAll,
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Search bar
        TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: localizations.searchSkills,
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            isDense: true,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Tab bar for Hard/Soft Skills
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            dividerColor: Colors.transparent,
            padding: const EdgeInsets.all(4),
            tabs: [
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.engineering, size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          localizations.hardSkills,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      if (hardSkillsSelected > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDE15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$hardSkillsSelected',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.psychology, size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          localizations.softSkills,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      if (softSkillsSelected > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDE15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$softSkillsSelected',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Tab content
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _SkillsTabView(
                isHardSkill: true,
                searchQuery: _searchQuery,
                selectedSkillsSet: _selectedSkillsSet,
                onToggleSkill: _toggleSkill,
                localizations: localizations,
              ),
              _SkillsTabView(
                isHardSkill: false,
                searchQuery: _searchQuery,
                selectedSkillsSet: _selectedSkillsSet,
                onToggleSkill: _toggleSkill,
                localizations: localizations,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkillsTabView extends StatelessWidget {
  final bool isHardSkill;
  final String searchQuery;
  final Set<String> selectedSkillsSet;
  final Function(String) onToggleSkill;
  final AppLocalizations localizations;

  const _SkillsTabView({
    required this.isHardSkill,
    required this.searchQuery,
    required this.selectedSkillsSet,
    required this.onToggleSkill,
    required this.localizations,
  });

  Map<String, List<String>> _getFilteredGroups() {
    final allGroups = isHardSkill 
        ? HardSkillsData.hardSkillsGroups
        : SoftSkillsData.softSkillsGroups;
        
    if (searchQuery.isEmpty) return allGroups;
    
    Map<String, List<String>> filteredGroups = {};
    for (final entry in allGroups.entries) {
      final filteredSkills = entry.value.where((skill) {
        final translatedSkill = isHardSkill
            ? QuestionTranslationService.translateHardSkill(skill, localizations)
            : QuestionTranslationService.translateSoftSkill(skill, localizations);
        return skill.toLowerCase().contains(searchQuery.toLowerCase()) ||
               translatedSkill.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
      
      if (filteredSkills.isNotEmpty) {
        filteredGroups[entry.key] = filteredSkills;
      }
    }
    return filteredGroups;
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _getFilteredGroups();
    
    if (filteredGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              localizations.noSkillsFound,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    final groupEntries = filteredGroups.entries.toList();

    // KEY OPTIMIZATION: Use ListView.builder for better scroll performance
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      // Add physics for better scroll feel
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: groupEntries.length,
      itemBuilder: (context, index) {
        final entry = groupEntries[index];
        return _SkillsGroupSection(
          groupKey: entry.key,
          skills: entry.value,
          isHardSkill: isHardSkill,
          selectedSkillsSet: selectedSkillsSet,
          onToggleSkill: onToggleSkill,
          localizations: localizations,
        );
      },
    );
  }
}

class _SkillsGroupSection extends StatelessWidget {
  final String groupKey;
  final List<String> skills;
  final bool isHardSkill;
  final Set<String> selectedSkillsSet;
  final Function(String) onToggleSkill;
  final AppLocalizations localizations;

  const _SkillsGroupSection({
    required this.groupKey,
    required this.skills,
    required this.isHardSkill,
    required this.selectedSkillsSet,
    required this.onToggleSkill,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final translatedGroupName = isHardSkill 
        ? QuestionTranslationService.translateHardSkillGroup(groupKey, localizations)
        : QuestionTranslationService.translateSoftSkillGroup(groupKey, localizations);
    
    final selectedInGroup = skills.where((skill) => selectedSkillsSet.contains(skill)).length;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isHardSkill ? Colors.blue.shade50 : Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(
                  color: isHardSkill ? Colors.blue.shade100 : Colors.green.shade100,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isHardSkill ? Icons.engineering : Icons.psychology,
                  color: isHardSkill ? Colors.blue.shade700 : Colors.green.shade700,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    translatedGroupName,
                    style: TextStyle(
                      color: isHardSkill ? Colors.blue.shade700 : Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (selectedInGroup > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDE15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$selectedInGroup/${skills.length}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Skills chips - Use simple Wrap, no complex layouts
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) => _SkillChip(
                skill: skill,
                isSelected: selectedSkillsSet.contains(skill),
                isHardSkill: isHardSkill,
                onTap: () => onToggleSkill(skill),
                localizations: localizations,
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String skill;
  final bool isSelected;
  final bool isHardSkill;
  final VoidCallback onTap;
  final AppLocalizations localizations;

  const _SkillChip({
    required this.skill,
    required this.isSelected,
    required this.isHardSkill,
    required this.onTap,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final translatedSkill = isHardSkill 
        ? QuestionTranslationService.translateHardSkill(skill, localizations)
        : QuestionTranslationService.translateSoftSkill(skill, localizations);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFFFDE15).withAlpha((0.2 * 255).toInt())
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFDE15) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          translatedSkill,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}