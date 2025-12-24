// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_pair.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WordPair {
  String get civilian => throw _privateConstructorUsedError;
  String get infiltrator => throw _privateConstructorUsedError;

  /// Create a copy of WordPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordPairCopyWith<WordPair> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordPairCopyWith<$Res> {
  factory $WordPairCopyWith(WordPair value, $Res Function(WordPair) then) =
      _$WordPairCopyWithImpl<$Res, WordPair>;
  @useResult
  $Res call({String civilian, String infiltrator});
}

/// @nodoc
class _$WordPairCopyWithImpl<$Res, $Val extends WordPair>
    implements $WordPairCopyWith<$Res> {
  _$WordPairCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? civilian = null,
    Object? infiltrator = null,
  }) {
    return _then(_value.copyWith(
      civilian: null == civilian
          ? _value.civilian
          : civilian // ignore: cast_nullable_to_non_nullable
              as String,
      infiltrator: null == infiltrator
          ? _value.infiltrator
          : infiltrator // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WordPairImplCopyWith<$Res>
    implements $WordPairCopyWith<$Res> {
  factory _$$WordPairImplCopyWith(
          _$WordPairImpl value, $Res Function(_$WordPairImpl) then) =
      __$$WordPairImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String civilian, String infiltrator});
}

/// @nodoc
class __$$WordPairImplCopyWithImpl<$Res>
    extends _$WordPairCopyWithImpl<$Res, _$WordPairImpl>
    implements _$$WordPairImplCopyWith<$Res> {
  __$$WordPairImplCopyWithImpl(
      _$WordPairImpl _value, $Res Function(_$WordPairImpl) _then)
      : super(_value, _then);

  /// Create a copy of WordPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? civilian = null,
    Object? infiltrator = null,
  }) {
    return _then(_$WordPairImpl(
      civilian: null == civilian
          ? _value.civilian
          : civilian // ignore: cast_nullable_to_non_nullable
              as String,
      infiltrator: null == infiltrator
          ? _value.infiltrator
          : infiltrator // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$WordPairImpl implements _WordPair {
  const _$WordPairImpl({required this.civilian, required this.infiltrator});

  @override
  final String civilian;
  @override
  final String infiltrator;

  @override
  String toString() {
    return 'WordPair(civilian: $civilian, infiltrator: $infiltrator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordPairImpl &&
            (identical(other.civilian, civilian) ||
                other.civilian == civilian) &&
            (identical(other.infiltrator, infiltrator) ||
                other.infiltrator == infiltrator));
  }

  @override
  int get hashCode => Object.hash(runtimeType, civilian, infiltrator);

  /// Create a copy of WordPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordPairImplCopyWith<_$WordPairImpl> get copyWith =>
      __$$WordPairImplCopyWithImpl<_$WordPairImpl>(this, _$identity);
}

abstract class _WordPair implements WordPair {
  const factory _WordPair(
      {required final String civilian,
      required final String infiltrator}) = _$WordPairImpl;

  @override
  String get civilian;
  @override
  String get infiltrator;

  /// Create a copy of WordPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordPairImplCopyWith<_$WordPairImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
