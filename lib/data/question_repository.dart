import 'package:youllgetit_flutter/models/question_model.dart';

class QuestionRepository {
  static final List<Question> questions = [
    Question(
      id: 'q1',
      text: 'What fields would you like to find your internship in?',
      answerType: AnswerType.checkbox,
      options: [
        'Management',
        'Business',
        'IT',
        'Engineering',
        'Economics',
        'Education',
        'Healthcare'
      ],
      hasOtherField: true,
    ),
    Question(
      id: 'q2',
      text: 'What type of work environment do you prefer?',
      answerType: AnswerType.checkbox,
      options: [
        'Remote',
        'Hybrid',
        'Office',
        'Flexible',
      ],
      hasOtherField: true,
    ),
    // Add more questions as needed.
  ];
}
