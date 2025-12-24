import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/player.dart';

part 'players_provider.g.dart';

@riverpod
class Players extends _$Players {
  @override
  List<Player> build() {
    return [];
  }

  void addPlayer(String name) {
    if (name.trim().isEmpty) return;
    if (state.any((p) => p.name.toLowerCase() == name.toLowerCase())) return;

    final newPlayer = Player(
      id: const Uuid().v4(),
      name: name.trim(),
    );

    state = [...state, newPlayer];
  }

  void removePlayer(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  void reset() {
    state = [];
  }
  
  bool get isValid => state.length >= 4;
}
