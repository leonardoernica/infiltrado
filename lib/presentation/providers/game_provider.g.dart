// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameRepositoryImplHash() =>
    r'8e084ccb78796203764360fc78e7db963b4d804b';

/// See also [gameRepositoryImpl].
@ProviderFor(gameRepositoryImpl)
final gameRepositoryImplProvider =
    AutoDisposeProvider<GameRepositoryImpl>.internal(
  gameRepositoryImpl,
  name: r'gameRepositoryImplProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameRepositoryImplHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameRepositoryImplRef = AutoDisposeProviderRef<GameRepositoryImpl>;
String _$gameHash() => r'd62ffd9fd76c29cff9818389bf0a373548243b33';

/// See also [Game].
@ProviderFor(Game)
final gameProvider = NotifierProvider<Game, GameState>.internal(
  Game.new,
  name: r'gameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Game = Notifier<GameState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
