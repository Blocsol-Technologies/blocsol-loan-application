// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_events_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LoanEventsState {
  LoanEvent get latestEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LoanEventsStateCopyWith<LoanEventsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanEventsStateCopyWith<$Res> {
  factory $LoanEventsStateCopyWith(
          LoanEventsState value, $Res Function(LoanEventsState) then) =
      _$LoanEventsStateCopyWithImpl<$Res, LoanEventsState>;
  @useResult
  $Res call({LoanEvent latestEvent});
}

/// @nodoc
class _$LoanEventsStateCopyWithImpl<$Res, $Val extends LoanEventsState>
    implements $LoanEventsStateCopyWith<$Res> {
  _$LoanEventsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestEvent = null,
  }) {
    return _then(_value.copyWith(
      latestEvent: null == latestEvent
          ? _value.latestEvent
          : latestEvent // ignore: cast_nullable_to_non_nullable
              as LoanEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanEventsStateImplCopyWith<$Res>
    implements $LoanEventsStateCopyWith<$Res> {
  factory _$$LoanEventsStateImplCopyWith(_$LoanEventsStateImpl value,
          $Res Function(_$LoanEventsStateImpl) then) =
      __$$LoanEventsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LoanEvent latestEvent});
}

/// @nodoc
class __$$LoanEventsStateImplCopyWithImpl<$Res>
    extends _$LoanEventsStateCopyWithImpl<$Res, _$LoanEventsStateImpl>
    implements _$$LoanEventsStateImplCopyWith<$Res> {
  __$$LoanEventsStateImplCopyWithImpl(
      _$LoanEventsStateImpl _value, $Res Function(_$LoanEventsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestEvent = null,
  }) {
    return _then(_$LoanEventsStateImpl(
      latestEvent: null == latestEvent
          ? _value.latestEvent
          : latestEvent // ignore: cast_nullable_to_non_nullable
              as LoanEvent,
    ));
  }
}

/// @nodoc

class _$LoanEventsStateImpl implements _LoanEventsState {
  const _$LoanEventsStateImpl({required this.latestEvent});

  @override
  final LoanEvent latestEvent;

  @override
  String toString() {
    return 'LoanEventsState(latestEvent: $latestEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanEventsStateImpl &&
            (identical(other.latestEvent, latestEvent) ||
                other.latestEvent == latestEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, latestEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanEventsStateImplCopyWith<_$LoanEventsStateImpl> get copyWith =>
      __$$LoanEventsStateImplCopyWithImpl<_$LoanEventsStateImpl>(
          this, _$identity);
}

abstract class _LoanEventsState implements LoanEventsState {
  const factory _LoanEventsState({required final LoanEvent latestEvent}) =
      _$LoanEventsStateImpl;

  @override
  LoanEvent get latestEvent;
  @override
  @JsonKey(ignore: true)
  _$$LoanEventsStateImplCopyWith<_$LoanEventsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
