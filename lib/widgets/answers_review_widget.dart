import 'package:flutter/material.dart';

class AnswersReviewWidget extends StatelessWidget {
  final List<MapEntry<String, dynamic>> entries;
  static const Color primaryColor = Colors.amber;

  const AnswersReviewWidget({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: entries.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: const [
              SizedBox(height: 16),
              Text(
                'Thank you for answering!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
            ],
          );
        }
        final entry = entries[index - 1];
        return _buildAnswerCard(entry);
      },
    );
  }

  Widget _buildAnswerCard(MapEntry<String, dynamic> entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final answer = entry.value[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 18,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatAnswer(answer),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAnswer(String answer) {
    if (answer.contains(':')) {
      final parts = answer.split(':');
      if (parts.length == 2) {
        return '${parts[0]} - Level ${parts[1]}';
      }
    }
    return answer;
  }
}
