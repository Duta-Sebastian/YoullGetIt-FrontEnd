import 'package:youllgetit_flutter/data/skills_repository.dart';
import 'package:youllgetit_flutter/models/question_model.dart';
import 'package:youllgetit_flutter/utils/question_id_parts.dart';

class QuestionRepository {
  static List<Question> _questions = [];
  static int _questionsCount = 0;
  static Map<String, Question>? _textToQuestionCache;
  static Map<String, Question>? _idToQuestionCache;

    static const Set<String> _shortPathSkips = {
    'q2_yes_1',
    'q2_yes_2',
    'q3',
    'q4_eng',
    'q4_it',
    'q5',
    'q7',
    'q15',
  };

  static bool shouldIncludeInPath(String questionId, bool isShortQuestionnaire) {
    if (!isShortQuestionnaire) return true;
    return !_shortPathSkips.contains(questionId);
  }

  static String? getNextQuestionId(Question question, bool isShortQuestionnaire) {
    String? nextId = question.nextQuestionId;
    
    while (nextId != null && !shouldIncludeInPath(nextId, isShortQuestionnaire)) {
      final nextQuestion = getQuestionById(nextId);
      nextId = nextQuestion?.nextQuestionId;
    }
    
    return nextId;
  }

  static int getQuestionsCount(bool isShortQuestionnaire) {
    if (!isShortQuestionnaire) return _questionsCount;
    
    return _questions.where((q) => shouldIncludeInPath(q.id, isShortQuestionnaire)).length;
  }

  static Future<void> initialize() async {
    final softSkills = await SkillsRepository.getSoftSkills();
    final hardSkills = await SkillsRepository.getHardSkills();

    _questions = [
      Question(
        id: 'q1',
        text: 'What is your current level of study?',
        answerType: AnswerType.radio,
        options: ['Highschool', 'Bachelor', 'Master', 'PhD'],
        hasOtherField: false,
        nextQuestionId: 'q2',
        rootQuestionId: 'q1',
      ),

      Question(
        id: 'q2',
        text: 'Are you still a student?',
        answerType: AnswerType.radio,
        options: ['Yes', 'No'],
        nextQuestionId: 'q3',
        previousQuestionId: 'q1',
        rootQuestionId: 'q2',
        nextQuestionMap: {
          'Yes': 'q2_yes_1',
          'No': 'q2_no',
        }
      ),

      Question(
        id: 'q2_yes_1',
        text: 'What year are you in?',
        answerType: AnswerType.radio,
        options: ['1st Year', '2nd Year', '3rd Year', '4th Year'],
        nextQuestionId: 'q2_yes_2',
        previousQuestionId: 'q2',
        rootQuestionId: 'q2',
      ),

      Question(
        id: 'q2_yes_2',
        text: 'When will you be done with your studies?',
        answerType: AnswerType.radio,
        options: ['2026', '2027', '2028', '2029', '2030'],
        nextQuestionId: 'q3',
        previousQuestionId: 'q2_yes_1',
        rootQuestionId: 'q2',
      ),

      Question(
        id: 'q3',
        text: 'What kind of university do/did you attend in?',
        answerType: AnswerType.radio,
        options: ['Research', 'Applied'],
        hasOtherField: false,
        nextQuestionId: 'q4',
        previousQuestionId: 'q2',
        rootQuestionId: 'q3',
      ),

      Question(
        id: 'q4',
        text: 'What is the field of your study?',
        answerType: AnswerType.checkbox,
        options: ['Engineering', 'IT & Data Science', 'Marketing & Communication', 'Finance & Economics', 
                  'Political Science & Public Administration', 'Sales & Business Administration', 
                  'Arts & Culture', 'Biology, Chemistry, & Life Sciences'],
        hasOtherField: false,
        nextQuestionId: 'q5',
        rootQuestionId: 'q4',
        nextQuestionMap: {
          'Engineering': 'q4_eng', 
          'IT & Data Science': 'q4_it',
        },
      ),
      
      Question(
        id: 'q4_eng',
        text: 'What type of engineering?',
        answerType: AnswerType.checkbox,
        options: ['Mechanical', 'Electrical', 'Aerospace', 'Civil', 'Chemical'],
        hasOtherField: true,
        nextQuestionId: 'q5',
        previousQuestionId: 'q4',
        rootQuestionId: 'q4',
      ),
      
      Question(
        id: 'q4_it',
        text: 'What area of IT & Data Science?',
        answerType: AnswerType.restrictedChips,
        options: ['Software Development & Debugging', 'Full-stack Development', 
                  'Cloud Computing (AWS, Azure, GCP)', 'DevOps & CI/CD',
                  'IT Support & System Administration', 'Product Management',
                  'Machine Learning & AI', 'Data Analysis'],
        hasOtherField: false,
        nextQuestionId: 'q5',
        previousQuestionId: 'q4',
        rootQuestionId: 'q4',
      ),
      
      Question(
        id: 'q5',
        text: 'Do you have other specializations/minor?',
        answerType: AnswerType.checkbox,
        options: ['Engineering', 'IT & Data Science', 'Marketing & Communication', 'Finance & Economics', 
            'Political Science & Public Administration', 'Sales & Business Administration', 
            'Arts & Culture', 'Biology, Chemistry, & Life Sciences', 'None'],
        hasOtherField: false,
        nextQuestionId: 'q6',
        previousQuestionId: 'q4',
        rootQuestionId: 'q5',
      ),

      Question(
        id: 'q6',
        text: 'Do you have any prior experience in these fields?',
        answerType: AnswerType.checkbox,
        options: ['Yes, internship', 'Yes, part-time job', 'Yes, personal projects', 'No'],
        hasOtherField: false,
        nextQuestionId: 'q7',
        previousQuestionId: 'q5',
        rootQuestionId: 'q6',
      ),
      
      Question(
        id: 'q7',
        text: 'What other fields have you worked in before?',
        answerType: AnswerType.checkbox,
        options: ['Engineering', 'IT & Data Science', 'Marketing & Communication', 'Finance & Economics', 
            'Political Science & Public Administration', 'Sales & Business Administration', 
            'Arts & Culture', 'Biology, Chemistry, & Life Sciences', 'None'],
        hasOtherField: false,
        nextQuestionId: 'q8',
        previousQuestionId: 'q6',
        rootQuestionId: 'q7',
      ),

      Question(
        id: 'q8',
        text: 'What soft skills do you master?',
        answerType: AnswerType.groupedRestrictedChips,
        options: softSkills,
        hasOtherField: false,
        nextQuestionId: 'q9',
        previousQuestionId: 'q7',
        rootQuestionId: 'q8',
      ),
      
      Question(
        id: 'q9',
        text: 'What hard skills do you master?',
        answerType: AnswerType.groupedRestrictedChips,
        options: hardSkills,
        hasOtherField: false,
        nextQuestionId: 'q10',
        previousQuestionId: 'q8',
        rootQuestionId: 'q9',
      ),
      
      Question(
        id: 'q10',
        text: 'What languages are you comfortable doing the internship in?',
        answerType: AnswerType.languages,
        options: ['Albanian', 'Bosnian', 'Bulgarian', 'Catalan', 'Croatian',
                  'Czech', 'Danish', 'Dutch', 'English', 'Estonian', 'Finnish',
                  'French', 'German', 'Greek', 'Hungarian', 'Icelandic', 'Irish',
                  'Italian', 'Latvian', 'Lithuanian', 'Luxembourgish', 'Macedonian',
                  'Maltese', 'Montenegrin', 'Norwegian', 'Polish', 'Portuguese',
                  'Romanian', 'Russian', 'Serbian', 'Slovak', 'Slovenian',
                  'Spanish', 'Swedish', 'Turkish', 'Ukrainian'],
        hasOtherField: false,
        nextQuestionId: 'q11',
        previousQuestionId: 'q9',
        rootQuestionId: 'q10',
      ),
      
      Question(
        id: 'q11',
        text: 'What countries are you searching an internship in?',
        answerType: AnswerType.restrictedChips,
        options: ['Any', 'Albania', 'Andorra', 'Austria', 'Belgium', 'Bosnia and Herzegovina',
                  'Bulgaria', 'Croatia', 'Cyprus', 'Czech Republic', 'Denmark',
                  'Estonia', 'Finland', 'France', 'Germany', 'Greece',
                  'Hungary', 'Iceland', 'Ireland', 'Italy', 'Kosovo',
                  'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Moldova',
                  'Monaco', 'Montenegro', 'Netherlands', 'North Macedonia', 'Norway',
                  'Poland', 'Portugal', 'Romania', 'San Marino', 'Serbia',
                  'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland',
                  'Ukraine', 'United Kingdom', 'Vatican City'],
        hasOtherField: false,
        nextQuestionId: 'q12',
        previousQuestionId: 'q10',
        rootQuestionId: 'q11',
      ),
      
      Question(
        id: 'q12',
        text: 'What is your availability? ( you can select multiple options )',
        answerType: AnswerType.checkbox,
        options: ['Anytime', 'Summer', 'Autumn', 'Winter', 'Spring'],
        hasOtherField: false,
        nextQuestionId: 'q13',
        previousQuestionId: 'q11',
        rootQuestionId: 'q12',
      ),
      
      Question(
        id: 'q13',
        text: 'How long should the internship be? ( you can select multiple options )',
        answerType: AnswerType.checkbox,
        options: ['1-3 months', '3-6 months', '6-12 months', 'More than 12 months'],
        nextQuestionId: 'q14',
        previousQuestionId: 'q12',
        rootQuestionId: 'q13',
      ),
      
      Question(
        id: 'q14',
        text: 'Do you require VISA to work?',
        answerType: AnswerType.radio,
        options: ['Yes, for EU/EEA and UK', 'Yes, for EU/EEA', 'Yes, for UK', 'No'],
        hasOtherField: false,
        nextQuestionId: 'q15',
        previousQuestionId: 'q13',
        rootQuestionId: 'q14',
      ),
      
      Question(
        id: 'q15',
        text: 'Would you also consider traineeships?',
        answerType: AnswerType.radio,
        options: ['Yes', 'No', 'Maybe'],
        nextQuestionId: null,
        previousQuestionId: 'q14',
        rootQuestionId: 'q15',
      ),
    ];
    
    _questionsCount = _questions.length;
    _buildCaches();
  }

  static void _buildCaches() {
    _textToQuestionCache = {};
    _idToQuestionCache = {};
    for (final question in _questions) {
      _textToQuestionCache![question.text] = question;
      _idToQuestionCache![question.id] = question;
    }
  }

  static List<Question> get questions => _questions;
  static int get questionsCount => _questionsCount;

  static Question? getQuestionByText(String text) {
    _textToQuestionCache ??= _buildTextToQuestionCacheSync();
    return _textToQuestionCache![text];
  }

  static Question? getQuestionById(String id) {
    _idToQuestionCache ??= _buildIdToQuestionCacheSync();
    return _idToQuestionCache![id];
  }

  static Map<String, Question> _buildTextToQuestionCacheSync() {
    final cache = <String, Question>{};
    for (final question in _questions) {
      cache[question.text] = question;
    }
    return cache;
  }

  static Map<String, Question> _buildIdToQuestionCacheSync() {
    final cache = <String, Question>{};
    for (final question in _questions) {
      cache[question.id] = question;
    }
    return cache;
  }

  static List<Question> getQuestionsByTexts(List<String> texts) {
    return texts
        .map((text) => getQuestionByText(text))
        .where((q) => q != null)
        .cast<Question>()
        .toList();
  }

  static int compareQuestionIds(String idA, String idB) {
    final partsA = parseQuestionId(idA);
    final partsB = parseQuestionId(idB);
    
    final mainCompare = partsA.mainNumber.compareTo(partsB.mainNumber);
    if (mainCompare != 0) return mainCompare;
    
    if (partsA.branchPart == null && partsB.branchPart == null) return 0;
    if (partsA.branchPart == null) return -1;
    if (partsB.branchPart == null) return 1;
    
    final branchCompare = partsA.branchPart!.compareTo(partsB.branchPart!);
    if (branchCompare != 0) return branchCompare;
    
    return partsA.subNumber.compareTo(partsB.subNumber);
  }

  static List<Question> getSortedQuestions(List<String> questionTexts) {
    final questions = getQuestionsByTexts(questionTexts);
    questions.sort((a, b) => compareQuestionIds(a.id, b.id));
    return questions;
  }

  static List<String> getSortedQuestionTexts(List<String> questionTexts) {
    return getSortedQuestions(questionTexts).map((q) => q.text).toList();
  }

  static List<MapEntry<String, List<String>>> sortAnswerEntries(
    List<MapEntry<String, List<String>>> entries,
  ) {
    final sortedEntries = List<MapEntry<String, List<String>>>.from(entries);
    
    sortedEntries.sort((a, b) {
      final questionA = getQuestionByText(a.key);
      final questionB = getQuestionByText(b.key);
      
      if (questionA == null || questionB == null) return 0;
      
      return compareQuestionIds(questionA.id, questionB.id);
    });
    
    return sortedEntries;
  }

  static List<MapEntry<String, dynamic>> sortDynamicEntries(
    List<MapEntry<String, dynamic>> entries,
  ) {
    final sortedEntries = List<MapEntry<String, dynamic>>.from(entries);
    
    sortedEntries.sort((a, b) {
      final questionA = getQuestionByText(a.key);
      final questionB = getQuestionByText(b.key);
      
      if (questionA == null || questionB == null) return 0;
      
      return compareQuestionIds(questionA.id, questionB.id);
    });
    
    return sortedEntries;
  }

  static void clearCache() {
    _textToQuestionCache = null;
    _idToQuestionCache = null;
  }
}