
import 'category_model.dart';

class GameSession {
  final CategoryModel category;
  int score;
  int skipped;
  List<WordResult> results;
  
  GameSession({required this.category}) 
      : score = 0,
        skipped = 0,
        results = [];

  void addResult(String word, bool isCorrect) {
    results.add(WordResult(word: word, isCorrect: isCorrect));
    if (isCorrect) {
      score++;
    } else {
      skipped++;
    }
  }
}

class WordResult {
  final String word;
  final bool isCorrect;

  WordResult({required this.word, required this.isCorrect});
}
