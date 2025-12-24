import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';

enum PlayerRole { civilian, infiltrator }
enum PlayerStatus { alive, eliminated }

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    @Default(PlayerRole.civilian) PlayerRole role,
    @Default(PlayerStatus.alive) PlayerStatus status,
    String? votedFor, // ID of player this person voted for
  }) = _Player;
}
