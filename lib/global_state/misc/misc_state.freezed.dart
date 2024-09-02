// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misc_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MiscState {
  ActiveState get currentState => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MiscStateCopyWith<MiscState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MiscStateCopyWith<$Res> {
  factory $MiscStateCopyWith(MiscState value, $Res Function(MiscState) then) =
      _$MiscStateCopyWithImpl<$Res, MiscState>;
  @useResult
  $Res call({ActiveState currentState});
}

/// @nodoc
class _$MiscStateCopyWithImpl<$Res, $Val extends MiscState>
    implements $MiscStateCopyWith<$Res> {
  _$MiscStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentState = null,
  }) {
    return _then(_value.copyWith(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as ActiveState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MiscStateImplCopyWith<$Res>
    implements $MiscStateCopyWith<$Res> {
  factory _$$MiscStateImplCopyWith(
          _$MiscStateImpl value, $Res Function(_$MiscStateImpl) then) =
      __$$MiscStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ActiveState currentState});
}

/// @nodoc
class __$$MiscStateImplCopyWithImpl<$Res>
    extends _$MiscStateCopyWithImpl<$Res, _$MiscStateImpl>
    implements _$$MiscStateImplCopyWith<$Res> {
  __$$MiscStateImplCopyWithImpl(
      _$MiscStateImpl _value, $Res Function(_$MiscStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentState = null,
  }) {
    return _then(_$MiscStateImpl(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as ActiveState,
    ));
  }
}

/// @nodoc

class _$MiscStateImpl implements _MiscState {
  const _$MiscStateImpl({required this.currentState});

  @override
  final ActiveState currentState;

  @override
  String toString() {
    return 'MiscState(currentState: $currentState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MiscStateImpl &&
            (identical(other.currentState, currentState) ||
                other.currentState == currentState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MiscStateImplCopyWith<_$MiscStateImpl> get copyWith =>
      __$$MiscStateImplCopyWithImpl<_$MiscStateImpl>(this, _$identity);
}

abstract class _MiscState implements MiscState {
  const factory _MiscState({required final ActiveState currentState}) =
      _$MiscStateImpl;

  @override
  ActiveState get currentState;
  @override
  @JsonKey(ignore: true)
  _$$MiscStateImplCopyWith<_$MiscStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
