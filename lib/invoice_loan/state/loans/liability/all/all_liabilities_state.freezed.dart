// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'all_liabilities_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AllLiabilitiesState {
  List<LoanDetails> get liabilities => throw _privateConstructorUsedError;
  bool get fetchingLiabilitiess => throw _privateConstructorUsedError;
  int get liabilitiessFetchTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AllLiabilitiesStateCopyWith<AllLiabilitiesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllLiabilitiesStateCopyWith<$Res> {
  factory $AllLiabilitiesStateCopyWith(
          AllLiabilitiesState value, $Res Function(AllLiabilitiesState) then) =
      _$AllLiabilitiesStateCopyWithImpl<$Res, AllLiabilitiesState>;
  @useResult
  $Res call(
      {List<LoanDetails> liabilities,
      bool fetchingLiabilitiess,
      int liabilitiessFetchTime});
}

/// @nodoc
class _$AllLiabilitiesStateCopyWithImpl<$Res, $Val extends AllLiabilitiesState>
    implements $AllLiabilitiesStateCopyWith<$Res> {
  _$AllLiabilitiesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? liabilities = null,
    Object? fetchingLiabilitiess = null,
    Object? liabilitiessFetchTime = null,
  }) {
    return _then(_value.copyWith(
      liabilities: null == liabilities
          ? _value.liabilities
          : liabilities // ignore: cast_nullable_to_non_nullable
              as List<LoanDetails>,
      fetchingLiabilitiess: null == fetchingLiabilitiess
          ? _value.fetchingLiabilitiess
          : fetchingLiabilitiess // ignore: cast_nullable_to_non_nullable
              as bool,
      liabilitiessFetchTime: null == liabilitiessFetchTime
          ? _value.liabilitiessFetchTime
          : liabilitiessFetchTime // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AllLiabilitiesStateImplCopyWith<$Res>
    implements $AllLiabilitiesStateCopyWith<$Res> {
  factory _$$AllLiabilitiesStateImplCopyWith(_$AllLiabilitiesStateImpl value,
          $Res Function(_$AllLiabilitiesStateImpl) then) =
      __$$AllLiabilitiesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LoanDetails> liabilities,
      bool fetchingLiabilitiess,
      int liabilitiessFetchTime});
}

/// @nodoc
class __$$AllLiabilitiesStateImplCopyWithImpl<$Res>
    extends _$AllLiabilitiesStateCopyWithImpl<$Res, _$AllLiabilitiesStateImpl>
    implements _$$AllLiabilitiesStateImplCopyWith<$Res> {
  __$$AllLiabilitiesStateImplCopyWithImpl(_$AllLiabilitiesStateImpl _value,
      $Res Function(_$AllLiabilitiesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? liabilities = null,
    Object? fetchingLiabilitiess = null,
    Object? liabilitiessFetchTime = null,
  }) {
    return _then(_$AllLiabilitiesStateImpl(
      liabilities: null == liabilities
          ? _value._liabilities
          : liabilities // ignore: cast_nullable_to_non_nullable
              as List<LoanDetails>,
      fetchingLiabilitiess: null == fetchingLiabilitiess
          ? _value.fetchingLiabilitiess
          : fetchingLiabilitiess // ignore: cast_nullable_to_non_nullable
              as bool,
      liabilitiessFetchTime: null == liabilitiessFetchTime
          ? _value.liabilitiessFetchTime
          : liabilitiessFetchTime // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AllLiabilitiesStateImpl implements _AllLiabilitiesState {
  const _$AllLiabilitiesStateImpl(
      {required final List<LoanDetails> liabilities,
      required this.fetchingLiabilitiess,
      required this.liabilitiessFetchTime})
      : _liabilities = liabilities;

  final List<LoanDetails> _liabilities;
  @override
  List<LoanDetails> get liabilities {
    if (_liabilities is EqualUnmodifiableListView) return _liabilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_liabilities);
  }

  @override
  final bool fetchingLiabilitiess;
  @override
  final int liabilitiessFetchTime;

  @override
  String toString() {
    return 'AllLiabilitiesState(liabilities: $liabilities, fetchingLiabilitiess: $fetchingLiabilitiess, liabilitiessFetchTime: $liabilitiessFetchTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllLiabilitiesStateImpl &&
            const DeepCollectionEquality()
                .equals(other._liabilities, _liabilities) &&
            (identical(other.fetchingLiabilitiess, fetchingLiabilitiess) ||
                other.fetchingLiabilitiess == fetchingLiabilitiess) &&
            (identical(other.liabilitiessFetchTime, liabilitiessFetchTime) ||
                other.liabilitiessFetchTime == liabilitiessFetchTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_liabilities),
      fetchingLiabilitiess,
      liabilitiessFetchTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AllLiabilitiesStateImplCopyWith<_$AllLiabilitiesStateImpl> get copyWith =>
      __$$AllLiabilitiesStateImplCopyWithImpl<_$AllLiabilitiesStateImpl>(
          this, _$identity);
}

abstract class _AllLiabilitiesState implements AllLiabilitiesState {
  const factory _AllLiabilitiesState(
      {required final List<LoanDetails> liabilities,
      required final bool fetchingLiabilitiess,
      required final int liabilitiessFetchTime}) = _$AllLiabilitiesStateImpl;

  @override
  List<LoanDetails> get liabilities;
  @override
  bool get fetchingLiabilitiess;
  @override
  int get liabilitiessFetchTime;
  @override
  @JsonKey(ignore: true)
  _$$AllLiabilitiesStateImplCopyWith<_$AllLiabilitiesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}