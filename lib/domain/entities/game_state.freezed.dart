// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameState {
  GameStatus get status => throw _privateConstructorUsedError;
  GamePhase get phase => throw _privateConstructorUsedError;
  WordPair? get currentWordPair => throw _privateConstructorUsedError;
  String? get selectedCategory => throw _privateConstructorUsedError;
  List<WordPair> get history => throw _privateConstructorUsedError;
  List<Player> get players => throw _privateConstructorUsedError;
  int get currentTurnIndex => throw _privateConstructorUsedError;
  int get secondsRemaining => throw _privateConstructorUsedError;
  int get discussionDuration =>
      throw _privateConstructorUsedError; // Duration in seconds for discussion
  bool get isTimerPaused => throw _privateConstructorUsedError;
  int get infiltratorCount =>
      throw _privateConstructorUsedError; // Number of infiltrators
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call(
      {GameStatus status,
      GamePhase phase,
      WordPair? currentWordPair,
      String? selectedCategory,
      List<WordPair> history,
      List<Player> players,
      int currentTurnIndex,
      int secondsRemaining,
      int discussionDuration,
      bool isTimerPaused,
      int infiltratorCount,
      String? errorMessage});

  $WordPairCopyWith<$Res>? get currentWordPair;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? phase = null,
    Object? currentWordPair = freezed,
    Object? selectedCategory = freezed,
    Object? history = null,
    Object? players = null,
    Object? currentTurnIndex = null,
    Object? secondsRemaining = null,
    Object? discussionDuration = null,
    Object? isTimerPaused = null,
    Object? infiltratorCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as GamePhase,
      currentWordPair: freezed == currentWordPair
          ? _value.currentWordPair
          : currentWordPair // ignore: cast_nullable_to_non_nullable
              as WordPair?,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<WordPair>,
      players: null == players
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      currentTurnIndex: null == currentTurnIndex
          ? _value.currentTurnIndex
          : currentTurnIndex // ignore: cast_nullable_to_non_nullable
              as int,
      secondsRemaining: null == secondsRemaining
          ? _value.secondsRemaining
          : secondsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      discussionDuration: null == discussionDuration
          ? _value.discussionDuration
          : discussionDuration // ignore: cast_nullable_to_non_nullable
              as int,
      isTimerPaused: null == isTimerPaused
          ? _value.isTimerPaused
          : isTimerPaused // ignore: cast_nullable_to_non_nullable
              as bool,
      infiltratorCount: null == infiltratorCount
          ? _value.infiltratorCount
          : infiltratorCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WordPairCopyWith<$Res>? get currentWordPair {
    if (_value.currentWordPair == null) {
      return null;
    }

    return $WordPairCopyWith<$Res>(_value.currentWordPair!, (value) {
      return _then(_value.copyWith(currentWordPair: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GameStatus status,
      GamePhase phase,
      WordPair? currentWordPair,
      String? selectedCategory,
      List<WordPair> history,
      List<Player> players,
      int currentTurnIndex,
      int secondsRemaining,
      int discussionDuration,
      bool isTimerPaused,
      int infiltratorCount,
      String? errorMessage});

  @override
  $WordPairCopyWith<$Res>? get currentWordPair;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? phase = null,
    Object? currentWordPair = freezed,
    Object? selectedCategory = freezed,
    Object? history = null,
    Object? players = null,
    Object? currentTurnIndex = null,
    Object? secondsRemaining = null,
    Object? discussionDuration = null,
    Object? isTimerPaused = null,
    Object? infiltratorCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$GameStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as GamePhase,
      currentWordPair: freezed == currentWordPair
          ? _value.currentWordPair
          : currentWordPair // ignore: cast_nullable_to_non_nullable
              as WordPair?,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<WordPair>,
      players: null == players
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      currentTurnIndex: null == currentTurnIndex
          ? _value.currentTurnIndex
          : currentTurnIndex // ignore: cast_nullable_to_non_nullable
              as int,
      secondsRemaining: null == secondsRemaining
          ? _value.secondsRemaining
          : secondsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      discussionDuration: null == discussionDuration
          ? _value.discussionDuration
          : discussionDuration // ignore: cast_nullable_to_non_nullable
              as int,
      isTimerPaused: null == isTimerPaused
          ? _value.isTimerPaused
          : isTimerPaused // ignore: cast_nullable_to_non_nullable
              as bool,
      infiltratorCount: null == infiltratorCount
          ? _value.infiltratorCount
          : infiltratorCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GameStateImpl implements _GameState {
  const _$GameStateImpl(
      {this.status = GameStatus.initial,
      this.phase = GamePhase.discussion,
      this.currentWordPair,
      this.selectedCategory,
      final List<WordPair> history = const [],
      final List<Player> players = const [],
      this.currentTurnIndex = 0,
      this.secondsRemaining = 180,
      this.discussionDuration = 180,
      this.isTimerPaused = false,
      this.infiltratorCount = 1,
      this.errorMessage})
      : _history = history,
        _players = players;

  @override
  @JsonKey()
  final GameStatus status;
  @override
  @JsonKey()
  final GamePhase phase;
  @override
  final WordPair? currentWordPair;
  @override
  final String? selectedCategory;
  final List<WordPair> _history;
  @override
  @JsonKey()
  List<WordPair> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  final List<Player> _players;
  @override
  @JsonKey()
  List<Player> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  @JsonKey()
  final int currentTurnIndex;
  @override
  @JsonKey()
  final int secondsRemaining;
  @override
  @JsonKey()
  final int discussionDuration;
// Duration in seconds for discussion
  @override
  @JsonKey()
  final bool isTimerPaused;
  @override
  @JsonKey()
  final int infiltratorCount;
// Number of infiltrators
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'GameState(status: $status, phase: $phase, currentWordPair: $currentWordPair, selectedCategory: $selectedCategory, history: $history, players: $players, currentTurnIndex: $currentTurnIndex, secondsRemaining: $secondsRemaining, discussionDuration: $discussionDuration, isTimerPaused: $isTimerPaused, infiltratorCount: $infiltratorCount, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.currentWordPair, currentWordPair) ||
                other.currentWordPair == currentWordPair) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            const DeepCollectionEquality().equals(other._history, _history) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.currentTurnIndex, currentTurnIndex) ||
                other.currentTurnIndex == currentTurnIndex) &&
            (identical(other.secondsRemaining, secondsRemaining) ||
                other.secondsRemaining == secondsRemaining) &&
            (identical(other.discussionDuration, discussionDuration) ||
                other.discussionDuration == discussionDuration) &&
            (identical(other.isTimerPaused, isTimerPaused) ||
                other.isTimerPaused == isTimerPaused) &&
            (identical(other.infiltratorCount, infiltratorCount) ||
                other.infiltratorCount == infiltratorCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      phase,
      currentWordPair,
      selectedCategory,
      const DeepCollectionEquality().hash(_history),
      const DeepCollectionEquality().hash(_players),
      currentTurnIndex,
      secondsRemaining,
      discussionDuration,
      isTimerPaused,
      infiltratorCount,
      errorMessage);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState implements GameState {
  const factory _GameState(
      {final GameStatus status,
      final GamePhase phase,
      final WordPair? currentWordPair,
      final String? selectedCategory,
      final List<WordPair> history,
      final List<Player> players,
      final int currentTurnIndex,
      final int secondsRemaining,
      final int discussionDuration,
      final bool isTimerPaused,
      final int infiltratorCount,
      final String? errorMessage}) = _$GameStateImpl;

  @override
  GameStatus get status;
  @override
  GamePhase get phase;
  @override
  WordPair? get currentWordPair;
  @override
  String? get selectedCategory;
  @override
  List<WordPair> get history;
  @override
  List<Player> get players;
  @override
  int get currentTurnIndex;
  @override
  int get secondsRemaining;
  @override
  int get discussionDuration; // Duration in seconds for discussion
  @override
  bool get isTimerPaused;
  @override
  int get infiltratorCount; // Number of infiltrators
  @override
  String? get errorMessage;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
