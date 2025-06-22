class QuestionIdParts {
  final int mainNumber;
  final String? branchPart;
  final int subNumber;
  
  QuestionIdParts(this.mainNumber, this.branchPart, this.subNumber);
}

QuestionIdParts parseQuestionId(String id) {
  final mainMatch = RegExp(r'^q(\d+)').firstMatch(id);
  if (mainMatch == null) return QuestionIdParts(0, null, 0);
  
  final mainNumber = int.parse(mainMatch.group(1)!);
  
  final branchMatch = RegExp(r'_([a-zA-Z]+)_(\d+)$').firstMatch(id);
  if (branchMatch != null) {
    return QuestionIdParts(
      mainNumber, 
      branchMatch.group(1)!, 
      int.parse(branchMatch.group(2)!)
    );
  }
  
  return QuestionIdParts(mainNumber, null, 0);
}