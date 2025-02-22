import 'package:flutter/material.dart';

class QuestionOne extends StatefulWidget {
  final List<String> selectedChoices;
  final String otherText;
  final Function(List<String>) onChoicesUpdated;
  final Function(String) onOtherTextUpdated;
  final Function(String) onQuestionTextUpdated;

  const QuestionOne({
    super.key,
    required this.selectedChoices,
    required this.otherText,
    required this.onChoicesUpdated,
    required this.onOtherTextUpdated,
    required this.onQuestionTextUpdated,
  });

  @override
  _QuestionOneState createState() => _QuestionOneState();
}

class _QuestionOneState extends State<QuestionOne> {
  final TextEditingController _otherController = TextEditingController();
  final String questionText = "What fields would you like to find your internship in?";
  
  final List<String> options = ["Management", "Business", "IT", "Engineering", "Economics"];

  @override
  void initState() {
    super.initState();
    _otherController.text = widget.otherText;
    Future.microtask(() {
      widget.onQuestionTextUpdated(questionText);
    });
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...options.map((option) => _buildCheckbox(option)),
        _buildOtherField(),
      ],
    );
  }

  Widget _buildCheckbox(String text) {
    bool isSelected = widget.selectedChoices.contains(text);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isSelected) {
                    widget.selectedChoices.remove(text);
                  } else {
                    widget.selectedChoices.add(text);
                  }
                  widget.onChoicesUpdated(widget.selectedChoices);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.green : Colors.white,
                foregroundColor: isSelected ? Colors.white : Colors.black,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10),
        ]
      )
    );
  }

  Widget _buildOtherField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: TextField(
          controller: _otherController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: "Other, specify",
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          onChanged: (value) {
            setState(() {
              widget.selectedChoices.removeWhere((choice) => choice.startsWith("Other: "));
              if (value.isNotEmpty && value != "Other, specify") {
                widget.selectedChoices.add("Other: $value");
              }
              widget.onChoicesUpdated(widget.selectedChoices);
              widget.onOtherTextUpdated(value);
            });
          },
          onTap: () {
            if (_otherController.text == "Other, specify") {
              setState(() {
                _otherController.clear();
              });
            }
          },
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
