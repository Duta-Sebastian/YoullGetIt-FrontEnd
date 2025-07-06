class SoftSkillsData {
  static const Map<String, List<String>> softSkillsGroups = {
    'Leadership & Management': [
      'Leadership',
      'Decision-Making',
      'Mentoring',
      'Accountability',
    ],
    'Communication & Interpersonal': [
      'Communication Skills',
      'Public Speaking',
      'Interpersonal Skills',
      'Networking',
    ],
    'Teamwork & Collaboration': [
      'Collaboration',
      'Teamwork',
      'Relationship Management',
      'Customer Service',
    ],
    'Cognitive & Analytical': [
      'Critical Thinking',
      'Problem-Solving Skills',
      'Innovation',
      'Commercial Understanding',
    ],
    'Personal Effectiveness': [
      'Time Management',
      'Organizational Skills',
      'Attention to Detail',
      'Detail Oriented',
    ],
    'Adaptability & Growth': [
      'Flexibility',
      'Adaptability',
      'Learning',
      'Continuous Learning',
      'Enthusiasm for Learning',
    ],
    'Independence & Specialized': [
      'Independence',
      'Self-Reliance',
      'Enthusiasm for Politics',
      'Enthusiasm for Public Service',
    ],
  };

  static List<String> getAllSoftSkills() {
    return softSkillsGroups.values.expand((skills) => skills).toList();
  }

  static String? getGroupForSkill(String skill) {
    for (final entry in softSkillsGroups.entries) {
      if (entry.value.contains(skill)) {
        return entry.key;
      }
    }
    return null;
  }
}