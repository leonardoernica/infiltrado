import 'package:freezed_annotation/freezed_annotation.dart';
import 'word_pair.dart';
import 'player.dart';
import 'game_phase.dart';

part 'game_state.freezed.dart';

enum GameStatus { initial, loading, success, error }

@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default(GameStatus.initial) GameStatus status,
    @Default(GamePhase.discussion) GamePhase phase,
    WordPair? currentWordPair,
    String? selectedCategory,
    @Default([]) List<WordPair> history,
    @Default([]) List<Player> players,
    @Default(0) int currentTurnIndex,
    @Default(180) int secondsRemaining,
    @Default(180) int discussionDuration, // Duration in seconds for discussion
    @Default(false) bool isTimerPaused,
    @Default(1) int infiltratorCount, // Number of infiltrators
    String? lastEliminatedId,
    String? errorMessage,
  }) = _GameState;
}
