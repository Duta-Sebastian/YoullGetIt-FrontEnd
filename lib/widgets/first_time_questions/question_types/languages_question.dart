import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:youllgetit_flutter/models/question_model.dart';

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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _updateFilteredOptions('');
    _isDropdownOpen = false;
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
      return;
    }
    
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = List.from(widget.question.options!);
      } else {
        _filteredOptions = widget.question.options!
            .where((option) => option.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _addLanguage(String language, String level) {
    List<String> updatedChoices = List.from(widget.selectedChoices);
    
    updatedChoices.removeWhere((choice) => choice.startsWith("$language:"));
    
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

  @override
  Widget build(BuildContext context) {
    List<String> selectedLanguages = _getSelectedLanguages();
    List<String> languageLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                                          language,
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
                                                ? Colors.amber
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            levelOption,
                                            style: TextStyle(
                                              color: isSelected ? Colors.black : Colors.black,
                                              fontWeight: FontWeight.bold,
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
        
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Neumorphic(
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      hintText: 'Search languages...',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                                    ),
                                    onChanged: (value) {
                                      _updateFilteredOptions(value);
                                      if (!_isDropdownOpen) {
                                        setState(() {
                                          _isDropdownOpen = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isDropdownOpen = !_isDropdownOpen;
                                  });
                                  FocusManager.instance.primaryFocus?.unfocus();
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
                    ),
                  ],
                ),
                
                if (_isDropdownOpen)
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: 3,
                      intensity: 0.3,
                      boxShape: NeumorphicBoxShape.roundRect(
                        const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      color: Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _filteredOptions.length,
                        itemBuilder: (context, index) {
                          final language = _filteredOptions[index];
                          final isSelected = selectedLanguages.contains(language);
                          
                          return InkWell(
                            onTap: () {
                              if (!isSelected) {
                                _addLanguage(language, 'A1');
                              }
                              _searchController.clear();
                              _updateFilteredOptions('');
                            },
                            child: Container(
                              color: isSelected ? const Color(0x33FFC107) : Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      language,
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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