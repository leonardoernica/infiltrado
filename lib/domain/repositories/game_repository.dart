import '../entities/word_pair.dart';

abstract class GameRepository {
  Future<WordPair> getWordPair(String category, List<WordPair> history);
}
