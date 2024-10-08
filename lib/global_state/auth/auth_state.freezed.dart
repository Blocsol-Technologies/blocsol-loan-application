// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthState {
  String get invoiceLoanToken => throw _privateConstructorUsedError;
  String get personalLoanToken => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call({String invoiceLoanToken, String personalLoanToken});
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceLoanToken = null,
    Object? personalLoanToken = null,
  }) {
    return _then(_value.copyWith(
      invoiceLoanToken: null == invoiceLoanToken
          ? _value.invoiceLoanToken
          : invoiceLoanToken // ignore: cast_nullable_to_non_nullable
              as String,
      personalLoanToken: null == personalLoanToken
          ? _value.personalLoanToken
          : personalLoanToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
          _$AuthStateImpl value, $Res Function(_$AuthStateImpl) then) =
      __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String invoiceLoanToken, String personalLoanToken});
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
      _$AuthStateImpl _value, $Res Function(_$AuthStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceLoanToken = null,
    Object? personalLoanToken = null,
  }) {
    return _then(_$AuthStateImpl(
      invoiceLoanToken: null == invoiceLoanToken
          ? _value.invoiceLoanToken
          : invoiceLoanToken // ignore: cast_nullable_to_non_nullable
              as String,
      personalLoanToken: null == personalLoanToken
          ? _value.personalLoanToken
          : personalLoanToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl(
      {required this.invoiceLoanToken, required this.personalLoanToken});

  @override
  final String invoiceLoanToken;
  @override
  final String personalLoanToken;

  @override
  String toString() {
    return 'AuthState(invoiceLoanToken: $invoiceLoanToken, personalLoanToken: $personalLoanToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.invoiceLoanToken, invoiceLoanToken) ||
                other.invoiceLoanToken == invoiceLoanToken) &&
            (identical(other.personalLoanToken, personalLoanToken) ||
                other.personalLoanToken == personalLoanToken));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, invoiceLoanToken, personalLoanToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
}

abstract class _AuthState implements AuthState {
  const factory _AuthState(
      {required final String invoiceLoanToken,
      required final String personalLoanToken}) = _$AuthStateImpl;

  @override
  String get invoiceLoanToken;
  @override
  String get personalLoanToken;
  @override
  @JsonKey(ignore: true)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
