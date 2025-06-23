import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:youllgetit_flutter/data/question_repository.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/screens/entry_upload_cv_screen.dart';
import 'package:youllgetit_flutter/widgets/answers_review_widget.dart';

class ReviewAnswersScreen extends StatefulWidget {
  final Map<String, List<String>> answers;

  static const Color primaryColor = Colors.amber;

  const ReviewAnswersScreen({
    super.key,
    required this.answers,
  });

  @override
  State<ReviewAnswersScreen> createState() => _ReviewAnswersScreenState();
}

class _ReviewAnswersScreenState extends State<ReviewAnswersScreen> {
  late Map<String, List<String>> _currentAnswers;

  @override
  void initState() {
    super.initState();
    _currentAnswers = Map<String, List<String>>.from(widget.answers);
  }

  List<MapEntry<String, List<String>>> _getOrderedAnswers() {
    return QuestionRepository.sortAnswerEntries(_currentAnswers.entries.toList());
  }

  void _onAnswersUpdated(Map<String, List<String>> updatedAnswers) {
    if (!const DeepCollectionEquality().equals(_currentAnswers, updatedAnswers)) {
      setState(() {
        _currentAnswers = updatedAnswers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    debugPrint('Current answers: $_currentAnswers');
    debugPrint('What comes: ${widget.answers}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(localizations.reviewAnswersTitle),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                child: AnswersReviewWidget(
                  entries: _getOrderedAnswers(),
                  onAnswersUpdated: _onAnswersUpdated,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> serializedAnswers = {
                    for (var entry in _currentAnswers.entries)
                      entry.key: entry.value
                  };
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EntryUploadCvScreen(answers: serializedAnswers),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ReviewAnswersScreen.primaryColor,
                  foregroundColor: Colors.black,
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  localizations.reviewAnswersLetsFind,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}