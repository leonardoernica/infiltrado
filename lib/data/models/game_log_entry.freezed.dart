// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameLogEntry _$GameLogEntryFromJson(Map<String, dynamic> json) {
  return _GameLogEntry.fromJson(json);
}

/// @nodoc
mixin _$GameLogEntry {
  String get id => throw _privateConstructorUsedError;
  String get promptVersion =>
      throw _privateConstructorUsedError; // e.g., "1.0", "1.1", "1.2"
  String get category => throw _privateConstructorUsedError;
  String get categoryDescription => throw _privateConstructorUsedError;
  String get civilian => throw _privateConstructorUsedError;
  String get infiltrator => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool? get civilianFeedback =>
      throw _privateConstructorUsedError; // true = fez sentido, false = não fez sentido, null = não avaliado
  bool? get infiltratorFeedback =>
      throw _privateConstructorUsedError; // true = fez sentido, false = não fez sentido, null = não avaliado
  String? get notes =>
      throw _privateConstructorUsedError; // Observações adicionais
  String? get thoughtProcess => throw _privateConstructorUsedError;

  /// Serializes this GameLogEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameLogEntryCopyWith<GameLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameLogEntryCopyWith<$Res> {
  factory $GameLogEntryCopyWith(
          GameLogEntry value, $Res Function(GameLogEntry) then) =
      _$GameLogEntryCopyWithImpl<$Res, GameLogEntry>;
  @useResult
  $Res call(
      {String id,
      String promptVersion,
      String category,
      String categoryDescription,
      String civilian,
      String infiltrator,
      DateTime timestamp,
      bool? civilianFeedback,
      bool? infiltratorFeedback,
      String? notes,
      String? thoughtProcess});
}

/// @nodoc
class _$GameLogEntryCopyWithImpl<$Res, $Val extends GameLogEntry>
    implements $GameLogEntryCopyWith<$Res> {
  _$GameLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? promptVersion = null,
    Object? category = null,
    Object? categoryDescription = null,
    Object? civilian = null,
    Object? infiltrator = null,
    Object? timestamp = null,
    Object? civilianFeedback = freezed,
    Object? infiltratorFeedback = freezed,
    Object? notes = freezed,
    Object? thoughtProcess = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      promptVersion: null == promptVersion
          ? _value.promptVersion
          : promptVersion // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      categoryDescription: null == categoryDescription
          ? _value.categoryDescription
          : categoryDescription // ignore: cast_nullable_to_non_nullable
              as String,
      civilian: null == civilian
          ? _value.civilian
          : civilian // ignore: cast_nullable_to_non_nullable
              as String,
      infiltrator: null == infiltrator
          ? _value.infiltrator
          : infiltrator // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      civilianFeedback: freezed == civilianFeedback
          ? _value.civilianFeedback
          : civilianFeedback // ignore: cast_nullable_to_non_nullable
              as bool?,
      infiltratorFeedback: freezed == infiltratorFeedback
          ? _value.infiltratorFeedback
          : infiltratorFeedback // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      thoughtProcess: freezed == thoughtProcess
          ? _value.thoughtProcess
          : thoughtProcess // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameLogEntryImplCopyWith<$Res>
    implements $GameLogEntryCopyWith<$Res> {
  factory _$$GameLogEntryImplCopyWith(
          _$GameLogEntryImpl value, $Res Function(_$GameLogEntryImpl) then) =
      __$$GameLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String promptVersion,
      String category,
      String categoryDescription,
      String civilian,
      String infiltrator,
      DateTime timestamp,
      bool? civilianFeedback,
      bool? infiltratorFeedback,
      String? notes,
      String? thoughtProcess});
}

/// @nodoc
class __$$GameLogEntryImplCopyWithImpl<$Res>
    extends _$GameLogEntryCopyWithImpl<$Res, _$GameLogEntryImpl>
    implements _$$GameLogEntryImplCopyWith<$Res> {
  __$$GameLogEntryImplCopyWithImpl(
      _$GameLogEntryImpl _value, $Res Function(_$GameLogEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? promptVersion = null,
    Object? category = null,
    Object? categoryDescription = null,
    Object? civilian = null,
    Object? infiltrator = null,
    Object? timestamp = null,
    Object? civilianFeedback = freezed,
    Object? infiltratorFeedback = freezed,
    Object? notes = freezed,
    Object? thoughtProcess = freezed,
  }) {
    return _then(_$GameLogEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      promptVersion: null == promptVersion
          ? _value.promptVersion
          : promptVersion // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      categoryDescription: null == categoryDescription
          ? _value.categoryDescription
          : categoryDescription // ignore: cast_nullable_to_non_nullable
              as String,
      civilian: null == civilian
          ? _value.civilian
          : civilian // ignore: cast_nullable_to_non_nullable
              as String,
      infiltrator: null == infiltrator
          ? _value.infiltrator
          : infiltrator // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      civilianFeedback: freezed == civilianFeedback
          ? _value.civilianFeedback
          : civilianFeedback // ignore: cast_nullable_to_non_nullable
              as bool?,
      infiltratorFeedback: freezed == infiltratorFeedback
          ? _value.infiltratorFeedback
          : infiltratorFeedback // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      thoughtProcess: freezed == thoughtProcess
          ? _value.thoughtProcess
          : thoughtProcess // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameLogEntryImpl implements _GameLogEntry {
  const _$GameLogEntryImpl(
      {required this.id,
      required this.promptVersion,
      required this.category,
      required this.categoryDescription,
      required this.civilian,
      required this.infiltrator,
      required this.timestamp,
      this.civilianFeedback,
      this.infiltratorFeedback,
      this.notes,
      this.thoughtProcess});

  factory _$GameLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameLogEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String promptVersion;
// e.g., "1.0", "1.1", "1.2"
  @override
  final String category;
  @override
  final String categoryDescription;
  @override
  final String civilian;
  @override
  final String infiltrator;
  @override
  final DateTime timestamp;
  @override
  final bool? civilianFeedback;
// true = fez sentido, false = não fez sentido, null = não avaliado
  @override
  final bool? infiltratorFeedback;
// true = fez sentido, false = não fez sentido, null = não avaliado
  @override
  final String? notes;
// Observações adicionais
  @override
  final String? thoughtProcess;

  @override
  String toString() {
    return 'GameLogEntry(id: $id, promptVersion: $promptVersion, category: $category, categoryDescription: $categoryDescription, civilian: $civilian, infiltrator: $infiltrator, timestamp: $timestamp, civilianFeedback: $civilianFeedback, infiltratorFeedback: $infiltratorFeedback, notes: $notes, thoughtProcess: $thoughtProcess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameLogEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.promptVersion, promptVersion) ||
                other.promptVersion == promptVersion) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryDescription, categoryDescription) ||
                other.categoryDescription == categoryDescription) &&
            (identical(other.civilian, civilian) ||
                other.civilian == civilian) &&
            (identical(other.infiltrator, infiltrator) ||
                other.infiltrator == infiltrator) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.civilianFeedback, civilianFeedback) ||
                other.civilianFeedback == civilianFeedback) &&
            (identical(other.infiltratorFeedback, infiltratorFeedback) ||
                other.infiltratorFeedback == infiltratorFeedback) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.thoughtProcess, thoughtProcess) ||
                other.thoughtProcess == thoughtProcess));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      promptVersion,
      category,
      categoryDescription,
      civilian,
      infiltrator,
      timestamp,
      civilianFeedback,
      infiltratorFeedback,
      notes,
      thoughtProcess);

  /// Create a copy of GameLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameLogEntryImplCopyWith<_$GameLogEntryImpl> get copyWith =>
      __$$GameLogEntryImplCopyWithImpl<_$GameLogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameLogEntryImplToJson(
      this,
    );
  }
}

abstract class _GameLogEntry implements GameLogEntry {
  const factory _GameLogEntry(
      {required final String id,
      required final String promptVersion,
      required final String category,
      required final String categoryDescription,
      required final String civilian,
      required final String infiltrator,
      required final DateTime timestamp,
      final bool? civilianFeedback,
      final bool? infiltratorFeedback,
      final String? notes,
      final String? thoughtProcess}) = _$GameLogEntryImpl;

  factory _GameLogEntry.fromJson(Map<String, dynamic> json) =
      _$GameLogEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get promptVersion; // e.g., "1.0", "1.1", "1.2"
  @override
  String get category;
  @override
  String get categoryDescription;
  @override
  String get civilian;
  @override
  String get infiltrator;
  @override
  DateTime get timestamp;
  @override
  bool?
      get civilianFeedback; // true = fez sentido, false = não fez sentido, null = não avaliado
  @override
  bool?
      get infiltratorFeedback; // true = fez sentido, false = não fez sentido, null = não avaliado
  @override
  String? get notes; // Observações adicionais
  @override
  String? get thoughtProcess;

  /// Create a copy of GameLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameLogEntryImplCopyWith<_$GameLogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
