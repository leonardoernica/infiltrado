// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_pair_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WordPairModel _$WordPairModelFromJson(Map<String, dynamic> json) {
  return _WordPairModel.fromJson(json);
}

/// @nodoc
mixin _$WordPairModel {
  @JsonKey(name: 'civilian')
  String get civilian => throw _privateConstructorUsedError;
  @JsonKey(name: 'infiltrator')
  String get infiltrator => throw _privateConstructorUsedError;

  /// Serializes this WordPairModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WordPairModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordPairModelCopyWith<WordPairModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordPairModelCopyWith<$Res> {
  factory $WordPairModelCopyWith(
          WordPairModel value, $Res Function(WordPairModel) then) =
      _$WordPairModelCopyWithImpl<$Res, WordPairModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'civilian') String civilian,
      @JsonKey(name: 'infiltrator') String infiltrator});
}

/// @nodoc
class _$WordPairModelCopyWithImpl<$Res, $Val extends WordPairModel>
    implements $WordPairModelCopyWith<$Res> {
  _$WordPairModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordPairModel
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
abstract class _$$WordPairModelImplCopyWith<$Res>
    implements $WordPairModelCopyWith<$Res> {
  factory _$$WordPairModelImplCopyWith(
          _$WordPairModelImpl value, $Res Function(_$WordPairModelImpl) then) =
      __$$WordPairModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'civilian') String civilian,
      @JsonKey(name: 'infiltrator') String infiltrator});
}

/// @nodoc
class __$$WordPairModelImplCopyWithImpl<$Res>
    extends _$WordPairModelCopyWithImpl<$Res, _$WordPairModelImpl>
    implements _$$WordPairModelImplCopyWith<$Res> {
  __$$WordPairModelImplCopyWithImpl(
      _$WordPairModelImpl _value, $Res Function(_$WordPairModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WordPairModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? civilian = null,
    Object? infiltrator = null,
  }) {
    return _then(_$WordPairModelImpl(
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
@JsonSerializable()
class _$WordPairModelImpl implements _WordPairModel {
  const _$WordPairModelImpl(
      {@JsonKey(name: 'civilian') required this.civilian,
      @JsonKey(name: 'infiltrator') required this.infiltrator});

  factory _$WordPairModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordPairModelImplFromJson(json);

  @override
  @JsonKey(name: 'civilian')
  final String civilian;
  @override
  @JsonKey(name: 'infiltrator')
  final String infiltrator;

  @override
  String toString() {
    return 'WordPairModel(civilian: $civilian, infiltrator: $infiltrator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordPairModelImpl &&
            (identical(other.civilian, civilian) ||
                other.civilian == civilian) &&
            (identical(other.infiltrator, infiltrator) ||
                other.infiltrator == infiltrator));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, civilian, infiltrator);

  /// Create a copy of WordPairModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordPairModelImplCopyWith<_$WordPairModelImpl> get copyWith =>
      __$$WordPairModelImplCopyWithImpl<_$WordPairModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordPairModelImplToJson(
      this,
    );
  }
}

abstract class _WordPairModel implements WordPairModel {
  const factory _WordPairModel(
          {@JsonKey(name: 'civilian') required final String civilian,
          @JsonKey(name: 'infiltrator') required final String infiltrator}) =
      _$WordPairModelImpl;

  factory _WordPairModel.fromJson(Map<String, dynamic> json) =
      _$WordPairModelImpl.fromJson;

  @override
  @JsonKey(name: 'civilian')
  String get civilian;
  @override
  @JsonKey(name: 'infiltrator')
  String get infiltrator;

  /// Create a copy of WordPairModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordPairModelImplCopyWith<_$WordPairModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
