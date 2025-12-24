import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/word_pair.dart';

part 'word_pair_model.freezed.dart';
part 'word_pair_model.g.dart';

@freezed
class WordPairModel with _$WordPairModel {
  const factory WordPairModel({
    @JsonKey(name: 'civilian') required String civilian,
    @JsonKey(name: 'infiltrator') required String infiltrator,
  }) = _WordPairModel;

  factory WordPairModel.fromJson(Map<String, dynamic> json) =>
      _$WordPairModelFromJson(json);
}

extension WordPairModelMapper on WordPairModel {
  WordPair toEntity() {
    return WordPair(
      civilian: civilian,
      infiltrator: infiltrator,
    );
  }
}
