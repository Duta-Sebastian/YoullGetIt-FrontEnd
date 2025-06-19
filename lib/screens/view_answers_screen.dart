import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/widgets/answers_review_widget.dart';

class ViewAnswersScreen extends StatelessWidget {
  final List<MapEntry<String, dynamic>> entries;

  const ViewAnswersScreen({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Review Answers'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AnswersReviewWidget(entries: entries),
        ),
      ),
    );
  }
}
