import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

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
  late TextEditingController _otherController;
  final String questionText = "What fields would you like to find your internship in?";
  final List<String> options = [
    "Management", "Business", "IT", "Engineering", "Economics", "Education", "Healthcare"
  ];

  @override
  void initState() {
    super.initState();
    _otherController = TextEditingController.fromValue(TextEditingValue(text: widget.otherText));
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...options.map((option) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: _buildCheckbox(option, constraints.maxWidth * 0.8),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: _buildOtherField(constraints.maxWidth * 0.8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(String text, double buttonWidth) {
    bool isSelected = widget.selectedChoices.contains(text);

    return SizedBox(
      width: buttonWidth,
      child: NeumorphicButton(
        onPressed: () {
          setState(() {
            List<String> updatedChoices = List.from(widget.selectedChoices);
            isSelected ? updatedChoices.remove(text) : updatedChoices.add(text);
            widget.onChoicesUpdated(updatedChoices);
          });
        },
        style: NeumorphicStyle(
          color: isSelected ? Colors.green : Colors.white,
          depth: 5,
          intensity: 0.5,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherField(double maxWidth) {
    return SizedBox(
      width: maxWidth,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 5,
          intensity: 0.5,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
        ),
        child: TextField(
          controller: _otherController,
          onChanged: (value) {
            setState(() {
              List<String> updatedChoices = List.from(widget.selectedChoices);
              updatedChoices.removeWhere((choice) => choice.startsWith("Other: "));
              if (value.isNotEmpty && value != "Other, specify") {
                updatedChoices.add("Other: $value");
              }
              widget.onChoicesUpdated(updatedChoices);
              widget.onOtherTextUpdated(value);
            });
          },
          onTap: () {
            if (_otherController.text == "Other, specify") {
              _otherController.clear();
            }
          },
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[200],
            hintText: "Other, specify",
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          ),
        ),
      ),
    );
  }
}
