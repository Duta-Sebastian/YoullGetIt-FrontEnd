import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:youllgetit_flutter/models/question_model.dart';

class GenericQuestionWidget extends StatefulWidget {
  final Question question;
  final List<String> selectedChoices;
  final Function(List<String>) onChoicesUpdated;
  final Function(String) onTextUpdated;

  const GenericQuestionWidget({
    super.key,
    required this.question,
    required this.selectedChoices,
    required this.onChoicesUpdated,
    required this.onTextUpdated,
  });

  @override
  GenericQuestionWidgetState createState() => GenericQuestionWidgetState();
}

class GenericQuestionWidgetState extends State<GenericQuestionWidget> {
  late TextEditingController _otherController;
  late TextEditingController _searchController;
  String? otherText;
  bool _isDropdownOpen = false;
  List<String> _filteredOptions = [];
  
  void _addCustomChip(String value) {
    if (value.isEmpty || widget.selectedChoices.contains(value)) {
      return;
    }
    
    final List<String> updatedChoices = List.from(widget.selectedChoices);
    updatedChoices.add(value);
    widget.onChoicesUpdated(updatedChoices);
    
    _searchController.clear();
    
    setState(() {
      _isDropdownOpen = false;
      _updateFilteredOptions('');
    });
  }

  @override
  void initState() {
    super.initState();
    _otherController = TextEditingController();
    _searchController = TextEditingController();
    _initializeController();
    _updateFilteredOptions('');
    _isDropdownOpen = false;
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

  void _initializeController() {
    if (widget.question.answerType == AnswerType.text && widget.selectedChoices.isNotEmpty) {
      _otherController.text = widget.selectedChoices.first;
      otherText = widget.selectedChoices.first;
      return;
    }
    
    if (widget.question.options != null && widget.question.options!.isNotEmpty) {
      final otherAnswers = widget.selectedChoices
          .where((choice) => !widget.question.options!.contains(choice))
          .toList();

      if (otherAnswers.isNotEmpty) {
        _otherController.text = otherAnswers.last;
        otherText = otherAnswers.last;
      }
    }
  }

  @override
  void didUpdateWidget(covariant GenericQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.question.text != oldWidget.question.text) {
      _otherController.clear();
      _searchController.clear();
      otherText = null;
      _initializeController();
      _updateFilteredOptions('');
    }

    else if (!_areListsEqual(widget.selectedChoices, oldWidget.selectedChoices)) {
      _initializeController();
    }
  }

  bool _areListsEqual(List<String>? list1, List<String>? list2) {
    if (list1 == null || list2 == null) return list1 == list2;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _otherController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleChoice(String option) {
    setState(() {
      List<String> updatedChoices = List.from(widget.selectedChoices);
      
      if (widget.question.answerType == AnswerType.radio) {
        updatedChoices.clear();
        updatedChoices.add(option);
      } else {
        if (updatedChoices.contains(option)) {
          updatedChoices.remove(option);
        } else {
          updatedChoices.add(option);
        }
      }
      
      widget.onChoicesUpdated(updatedChoices);
    });
  }

  void _handleOtherTextChange(String text) {
    setState(() {
      otherText = text;
    });

    if (widget.question.answerType == AnswerType.text) {
      widget.onTextUpdated(text);
      return;
    }

    final List<String> updatedChoices = List.from(widget.selectedChoices)
      ..removeWhere((choice) => widget.question.options != null && 
                               !widget.question.options!.contains(choice));

    if (text.isNotEmpty) {
      updatedChoices.add(text);
    }

    widget.onChoicesUpdated(updatedChoices);
  }

  void _removeChip(String option) {
    List<String> updatedChoices = List.from(widget.selectedChoices);
    updatedChoices.remove(option);
    widget.onChoicesUpdated(updatedChoices);
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
  
  Widget _buildLanguageSelectionWidget() {
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
                                                ? const Color.fromRGBO(89, 164, 144, 1)
                                                : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            levelOption,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black,
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
                              color: isSelected ? const Color.fromRGBO(89, 164, 144, 0.2) : Colors.transparent,
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
                                    const Icon(
                                      Icons.check,
                                      color: Color.fromRGBO(89, 164, 144, 1),
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

  @override
  Widget build(BuildContext context) {
    Widget answerWidget;

    switch (widget.question.answerType) {
      case AnswerType.checkbox:
      case AnswerType.radio:
        answerWidget = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...(widget.question.options ?? []).map(
              (option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: NeumorphicButton(
                    onPressed: () {
                      _toggleChoice(option);
                    },
                    style: NeumorphicStyle(
                      color: widget.selectedChoices.contains(option)
                          ? const Color.fromRGBO(89, 164, 144, 1)
                          : Colors.white,
                      depth: 5,
                      intensity: 0.5,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.selectedChoices.contains(option)
                                ? Colors.white
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.question.hasOtherField)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 5,
                      intensity: 0.5,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      controller: _otherController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Other, specify',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 10.0,
                        ),
                      ),
                      onChanged: _handleOtherTextChange,
                    ),
                  ),
                ),
              ),
          ],
        );
        break;
        
      case AnswerType.text:
        answerWidget = FractionallySizedBox(
          widthFactor: 0.9,
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 5,
              intensity: 0.5,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(8),
              ),
            ),
            child: TextField(
              controller: _otherController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Type your answer here',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10.0,
                ),
              ),
              onChanged: _handleOtherTextChange,
              maxLines: 4,
              minLines: 1,
            ),
          ),
        );
        break;
        
      case AnswerType.languages:
        answerWidget = _buildLanguageSelectionWidget();
        break;
        
      case AnswerType.chips:
        answerWidget = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 100),
              child: SingleChildScrollView(
                child: widget.selectedChoices.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No options selected',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: widget.selectedChoices.map((option) {
                            return Neumorphic(
                              style: NeumorphicStyle(
                                color: const Color.fromRGBO(89, 164, 144, 1),
                                depth: 3,
                                intensity: 0.5,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 12.0,
                                ),
                                child: IntrinsicWidth(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.visible,
                                          softWrap: true,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0, left: 2.0),
                                        child: InkWell(
                                          onTap: () => _removeChip(option),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
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
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Focus(
                                      onFocusChange: (hasFocus) {
                                        if (!hasFocus && _searchController.text.isNotEmpty) {
                                          _addCustomChip(_searchController.text);
                                        }
                                      },
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: const InputDecoration(
                                          hintText: 'Search or add custom value...',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                                        ),
                                        onChanged: (value) {
                                          _updateFilteredOptions(value);
                                          if (!_isDropdownOpen && _filteredOptions.isNotEmpty) {
                                            setState(() {
                                              _isDropdownOpen = true;
                                            });
                                          }
                                        },
                                        onSubmitted: (value) {
                                          if (value.isNotEmpty) {
                                            _addCustomChip(value);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  if (_searchController.text.isNotEmpty && (_filteredOptions.isEmpty || 
                                      !_filteredOptions.contains(_searchController.text)))
                                    InkWell(
                                      onTap: () {
                                        _addCustomChip(_searchController.text);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          color: Color.fromRGBO(89, 164, 144, 1),
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
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _filteredOptions.length,
                            itemBuilder: (context, index) {
                              final option = _filteredOptions[index];
                              final isSelected = widget.selectedChoices.contains(option);
                              
                              return InkWell(
                                onTap: () {
                                  _toggleChoice(option);
                                  _searchController.clear();
                                  _updateFilteredOptions('');
                                },
                                child: Container(
                                  color: isSelected ? const Color.fromRGBO(89, 164, 144, 0.2) : Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check,
                                          color: Color.fromRGBO(89, 164, 144, 1),
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
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Center(
            child: SingleChildScrollView(
              child: answerWidget,
            ),
          ),
        ),
      ],
    );
  }
}