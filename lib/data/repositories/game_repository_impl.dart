import '../../domain/entities/word_pair.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/ai_word_datasource.dart';
import '../models/word_pair_model.dart';

class GameRepositoryImpl implements GameRepository {
  final AiWordDatasource _datasource;

  GameRepositoryImpl(this._datasource);

  @override
  Future<WordPair> getWordPair(String category, List<WordPair> history) async {
    final model = await _datasource.fetchWordPair(category, history);
    return model.toEntity();
  }
}
