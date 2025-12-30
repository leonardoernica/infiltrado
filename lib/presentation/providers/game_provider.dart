import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/word_pair.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/game_phase.dart';
import '../../domain/entities/game_state.dart';
import '../../data/repositories/game_repository_impl.dart';

part 'game_provider.g.dart';

@Riverpod(keepAlive: true)
class Game extends _$Game {
  @override
  GameState build() {
    ref.onDispose(() => _timer?.cancel());
    return const GameState();
  }

  Timer? _timer;

  // Helper getters for backward compatibility if needed, 
  // but better to access via state in widgets
  List<Player> get playersInGame => state.players;
  List<Player> get alivePlayers => state.players.where((p) => p.status == PlayerStatus.alive).toList();
  WordPair? get currentWordPair => state.currentWordPair;
  Player? get currentPlayer => 
      state.players.isNotEmpty && state.currentTurnIndex < state.players.length 
          ? state.players[state.currentTurnIndex] 
          : null;
  bool get isDistributionComplete => state.currentTurnIndex >= state.players.length;
  GamePhase get currentPhase => state.phase;
  int get secondsRemaining => state.secondsRemaining;
  bool get isTimerPaused => state.isTimerPaused;
  Player? get infiltrator => state.players.firstWhere(
    (p) => p.role == PlayerRole.infiltrator,
    orElse: () => state.players.first,
  );

  void setPlayers(List<Player> players) {
    state = state.copyWith(players: List.from(players));
    print('[GameProvider] setPlayers called with ${players.length} players');
  }

  void setGameSettings({required int discussionDuration, required int infiltratorCount}) {
    state = state.copyWith(
      discussionDuration: discussionDuration,
      infiltratorCount: infiltratorCount,
    );
  }

  void distributeRoles() {
    if (state.players.isEmpty) return;
    
    final players = state.players.map((p) => p.copyWith(role: PlayerRole.civilian, status: PlayerStatus.alive, votedFor: null)).toList();
    final infiltratorCount = state.infiltratorCount.clamp(1, (players.length / 3).floor());
    
    // Select random infiltrators
    final random = DateTime.now().millisecondsSinceEpoch;
    final selectedIndices = <int>{};
    for (int i = 0; i < infiltratorCount; i++) {
      int index;
      do {
        index = (random + i * 1000) % players.length;
      } while (selectedIndices.contains(index));
      selectedIndices.add(index);
      players[index] = players[index].copyWith(role: PlayerRole.infiltrator);
    }
    
    state = state.copyWith(
      players: players,
      currentTurnIndex: 0,
      phase: GamePhase.discussion,
    );
  }
  
  void nextTurn() {
    // During voting, skip eliminated players
    if (state.phase == GamePhase.voting) {
      final alivePlayers = state.players.where((p) => p.status == PlayerStatus.alive).toList();
      if (alivePlayers.isEmpty) return;
      
      // Find current player index in full list
      final currentPlayer = this.currentPlayer;
      if (currentPlayer == null) {
        // Start with first alive player
        final firstAlive = alivePlayers.first;
        final firstAliveIndex = state.players.indexWhere((p) => p.id == firstAlive.id);
        if (firstAliveIndex != -1) {
          state = state.copyWith(currentTurnIndex: firstAliveIndex);
        }
        return;
      }
      
      // Find next alive player
      final currentIndex = state.players.indexWhere((p) => p.id == currentPlayer.id);
      if (currentIndex == -1) return;
      
      // Look for next alive player after current
      for (int i = currentIndex + 1; i < state.players.length; i++) {
        if (state.players[i].status == PlayerStatus.alive) {
          state = state.copyWith(currentTurnIndex: i);
          return;
        }
      }
      
      // If no alive player found after current, wrap around to first alive
      final firstAlive = alivePlayers.first;
      final firstAliveIndex = state.players.indexWhere((p) => p.id == firstAlive.id);
      if (firstAliveIndex != -1 && firstAliveIndex != currentIndex) {
        state = state.copyWith(currentTurnIndex: firstAliveIndex);
      }
    } else {
      // Normal turn progression
      if (state.currentTurnIndex < state.players.length) {
        state = state.copyWith(currentTurnIndex: state.currentTurnIndex + 1);
      }
    }
  }

  Future<void> startGame(String category, {String? customDescription}) async {
    state = state.copyWith(status: GameStatus.loading, selectedCategory: category);
    try {
      final repository = ref.read(gameRepositoryImplProvider);
      final wordPair = await repository.getWordPair(category, state.history, customDescription: customDescription);
      
      distributeRoles();
      
      state = state.copyWith(
        status: GameStatus.success,
        currentWordPair: wordPair,
        history: [...state.history, wordPair],
      );
    } catch (e) {
      state = state.copyWith(status: GameStatus.error, errorMessage: e.toString());
    }
  }
  
  void newRound() {
    if (state.selectedCategory != null) {
      startGame(state.selectedCategory!);
    }
  }

  void resetForNewCategory() {
    _timer?.cancel();
    state = state.copyWith(
      status: GameStatus.initial,
      phase: GamePhase.discussion,
      currentWordPair: null,
      currentTurnIndex: 0,
      secondsRemaining: 180,
      isTimerPaused: false,
    );
  }

  void resetForPlayerEdit() {
    _timer?.cancel();
    state = state.copyWith(
      status: GameStatus.initial,
      phase: GamePhase.discussion,
      currentWordPair: null,
      currentTurnIndex: 0,
      selectedCategory: null,
    );
  }

  void startDiscussion({int? seconds}) {
    final duration = seconds ?? state.discussionDuration;
    state = state.copyWith(
      phase: GamePhase.discussion,
      secondsRemaining: duration,
      isTimerPaused: false,
    );
    _startTimer();
  }
  
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isTimerPaused && state.secondsRemaining > 0) {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
        
        if (state.secondsRemaining == 0) {
          timer.cancel();
          goToVoting();
        }
      }
    });
  }
  
  void pauseTimer() {
    state = state.copyWith(isTimerPaused: true);
  }
  
  void resumeTimer() {
    state = state.copyWith(isTimerPaused: false);
  }
  
  void resumeDiscussion() {
    // If timer was at 0, start a new round with the full duration
    // Otherwise, resume from where it was
    int newSeconds = state.secondsRemaining;
    if (newSeconds <= 0) {
      newSeconds = state.discussionDuration;
    }

    state = state.copyWith(
      phase: GamePhase.discussion,
      secondsRemaining: newSeconds,
      isTimerPaused: false,
    );
    _startTimer();
  }
  
  void goToVoting() {
    _timer?.cancel();
    // Pause the timer to preserve secondsRemaining
    state = state.copyWith(isTimerPaused: true);
    
    // Find first alive player for voting
    final alivePlayers = state.players.where((p) => p.status == PlayerStatus.alive).toList();
    int firstAliveIndex = 0;
    if (alivePlayers.isNotEmpty) {
      final firstAlive = alivePlayers.first;
      firstAliveIndex = state.players.indexWhere((p) => p.id == firstAlive.id);
      if (firstAliveIndex == -1) firstAliveIndex = 0;
    }
    
    state = state.copyWith(
      phase: GamePhase.voting,
      players: state.players.map((p) => p.copyWith(votedFor: null)).toList(),
      currentTurnIndex: firstAliveIndex, 
    );
  }
  
  void castVote(String voterId, String targetId) {
    state = state.copyWith(
      players: state.players.map((p) {
        if (p.id == voterId) return p.copyWith(votedFor: targetId);
        return p;
      }).toList(),
    );
  }
  
  bool get allVotesCast {
    final alive = state.players.where((p) => p.status == PlayerStatus.alive).toList();
    return alive.every((p) => p.votedFor != null);
  }
  
  String? processVotes() {
    final alive = state.players.where((p) => p.status == PlayerStatus.alive).toList();
    final votes = <String, int>{};
    
    for (final player in alive) {
      if (player.votedFor != null) {
        votes[player.votedFor!] = (votes[player.votedFor!] ?? 0) + 1;
      }
    }
    
    if (votes.isEmpty) return null;
    
    final maxVotes = votes.values.reduce((a, b) => a > b ? a : b);
    final topVoted = votes.entries.where((e) => e.value == maxVotes).toList();
    
    // Tie Breaker Logic: Currently just show result, maybe trigger re-vote or discussion
    if (topVoted.length > 1) {
      state = state.copyWith(phase: GamePhase.voteResult, lastEliminatedId: null);
      return null;
    }
    
    final eliminatedId = topVoted.first.key;
    state = state.copyWith(
      phase: GamePhase.voteResult,
      lastEliminatedId: eliminatedId,
      players: state.players.map((p) {
        if (p.id == eliminatedId) return p.copyWith(status: PlayerStatus.eliminated);
        return p;
      }).toList(),
    );
    
    return eliminatedId;
  }
  
  String? getWinner() {
    final alive = state.players.where((p) => p.status == PlayerStatus.alive).toList();
    final infiltrators = alive.where((p) => p.role == PlayerRole.infiltrator).toList();
    final infiltratorsAlive = infiltrators.length;
    final civiliansAlive = alive.length - infiltratorsAlive;
    
    // 1. If NO infiltrators are left, Civilians win immediately.
    if (infiltratorsAlive == 0) {
      return 'civilians';
    }
    
    // 2. If Infiltrators equal or outnumber civilians, Infiltrators win.
    // (e.g. 1v1, 2v2, 2v1)
    if (infiltratorsAlive >= civiliansAlive) {
      return 'infiltrator';
    }
    
    return null;
  }
  
  void applyGameOver() {
    if (getWinner() != null) {
      state = state.copyWith(phase: GamePhase.gameOver);
    }
  }

  void reset() {
    _timer?.cancel();
    state = const GameState();
  }
}

@riverpod
GameRepositoryImpl gameRepositoryImpl(GameRepositoryImplRef ref) {
   throw UnimplementedError('Override this in main.dart');
}
