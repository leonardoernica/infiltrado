import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_log_entry.freezed.dart';
part 'game_log_entry.g.dart';

@freezed
class GameLogEntry with _$GameLogEntry {
  const factory GameLogEntry({
    required String id,
    required String promptVersion, // e.g., "1.0", "1.1", "1.2"
    required String category,
    required String categoryDescription,
    required String civilian,
    required String infiltrator,
    required DateTime timestamp,
    bool? civilianFeedback, // true = fez sentido, false = não fez sentido, null = não avaliado
    bool? infiltratorFeedback, // true = fez sentido, false = não fez sentido, null = não avaliado
    String? notes, // Observações adicionais
    String? thoughtProcess, // O 'pensamento' da IA antes de gerar a resposta
  }) = _GameLogEntry;

  factory GameLogEntry.fromJson(Map<String, dynamic> json) =>
      _$GameLogEntryFromJson(json);
}

