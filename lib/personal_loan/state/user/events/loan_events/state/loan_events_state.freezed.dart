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
mixin _$PersonalLoanEventState {
  PersonalLoanEvent get latestEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PersonalLoanEventStateCopyWith<PersonalLoanEventState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalLoanEventStateCopyWith<$Res> {
  factory $PersonalLoanEventStateCopyWith(PersonalLoanEventState value,
          $Res Function(PersonalLoanEventState) then) =
      _$PersonalLoanEventStateCopyWithImpl<$Res, PersonalLoanEventState>;
  @useResult
  $Res call({PersonalLoanEvent latestEvent});
}

/// @nodoc
class _$PersonalLoanEventStateCopyWithImpl<$Res,
        $Val extends PersonalLoanEventState>
    implements $PersonalLoanEventStateCopyWith<$Res> {
  _$PersonalLoanEventStateCopyWithImpl(this._value, this._then);

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
              as PersonalLoanEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonalLoanEventStateImplCopyWith<$Res>
    implements $PersonalLoanEventStateCopyWith<$Res> {
  factory _$$PersonalLoanEventStateImplCopyWith(
          _$PersonalLoanEventStateImpl value,
          $Res Function(_$PersonalLoanEventStateImpl) then) =
      __$$PersonalLoanEventStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PersonalLoanEvent latestEvent});
}

/// @nodoc
class __$$PersonalLoanEventStateImplCopyWithImpl<$Res>
    extends _$PersonalLoanEventStateCopyWithImpl<$Res,
        _$PersonalLoanEventStateImpl>
    implements _$$PersonalLoanEventStateImplCopyWith<$Res> {
  __$$PersonalLoanEventStateImplCopyWithImpl(
      _$PersonalLoanEventStateImpl _value,
      $Res Function(_$PersonalLoanEventStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestEvent = null,
  }) {
    return _then(_$PersonalLoanEventStateImpl(
      latestEvent: null == latestEvent
          ? _value.latestEvent
          : latestEvent // ignore: cast_nullable_to_non_nullable
              as PersonalLoanEvent,
    ));
  }
}

/// @nodoc

class _$PersonalLoanEventStateImpl implements _PersonalLoanEventState {
  const _$PersonalLoanEventStateImpl({required this.latestEvent});

  @override
  final PersonalLoanEvent latestEvent;

  @override
  String toString() {
    return 'PersonalLoanEventState(latestEvent: $latestEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalLoanEventStateImpl &&
            (identical(other.latestEvent, latestEvent) ||
                other.latestEvent == latestEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, latestEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalLoanEventStateImplCopyWith<_$PersonalLoanEventStateImpl>
      get copyWith => __$$PersonalLoanEventStateImplCopyWithImpl<
          _$PersonalLoanEventStateImpl>(this, _$identity);
}

abstract class _PersonalLoanEventState implements PersonalLoanEventState {
  const factory _PersonalLoanEventState(
          {required final PersonalLoanEvent latestEvent}) =
      _$PersonalLoanEventStateImpl;

  @override
  PersonalLoanEvent get latestEvent;
  @override
  @JsonKey(ignore: true)
  _$$PersonalLoanEventStateImplCopyWith<_$PersonalLoanEventStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
