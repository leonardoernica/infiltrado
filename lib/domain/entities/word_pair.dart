import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_pair.freezed.dart';

@freezed
class WordPair with _$WordPair {
  const factory WordPair({
    required String civilian,
    required String infiltrator,
  }) = _WordPair;
}
