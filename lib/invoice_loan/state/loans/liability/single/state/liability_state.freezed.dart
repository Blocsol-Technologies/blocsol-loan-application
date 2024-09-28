// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'liability_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LiabilityState {
  LoanDetails get selectedLiability => throw _privateConstructorUsedError;
  bool get fetchingLiabilitiess => throw _privateConstructorUsedError;
  int get liabilitiessFetchTime => throw _privateConstructorUsedError;
  bool get fetchingSingleLiabilityDetails =>
      throw _privateConstructorUsedError; // Actions
  InvoiceLoanInitiatedActionType get initiatedActionType =>
      throw _privateConstructorUsedError; // Foreclosure
  bool get initiatingForeclosure => throw _privateConstructorUsedError;
  bool get verifyingForeclosure => throw _privateConstructorUsedError;
  bool get loanForeclosureFailed =>
      throw _privateConstructorUsedError; // Prepayment
  String get prepaymentId => throw _privateConstructorUsedError;
  bool get initiatingPrepayment => throw _privateConstructorUsedError;
  bool get verifyingPrepaymentSuccess => throw _privateConstructorUsedError;
  bool get prepaymentFailed =>
      throw _privateConstructorUsedError; // Missed EMI Payment
  String get missedEmiPaymentId => throw _privateConstructorUsedError;
  bool get initiatingMissedEmiPayment => throw _privateConstructorUsedError;
  bool get verifyingMissedEmiPaymentSuccess =>
      throw _privateConstructorUsedError;
  bool get missedEmiPaymentFailed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LiabilityStateCopyWith<LiabilityState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiabilityStateCopyWith<$Res> {
  factory $LiabilityStateCopyWith(
          LiabilityState value, $Res Function(LiabilityState) then) =
      _$LiabilityStateCopyWithImpl<$Res, LiabilityState>;
  @useResult
  $Res call(
      {LoanDetails selectedLiability,
      bool fetchingLiabilitiess,
      int liabilitiessFetchTime,
      bool fetchingSingleLiabilityDetails,
      InvoiceLoanInitiatedActionType initiatedActionType,
      bool initiatingForeclosure,
      bool verifyingForeclosure,
      bool loanForeclosureFailed,
      String prepaymentId,
      bool initiatingPrepayment,
      bool verifyingPrepaymentSuccess,
      bool prepaymentFailed,
      String missedEmiPaymentId,
      bool initiatingMissedEmiPayment,
      bool verifyingMissedEmiPaymentSuccess,
      bool missedEmiPaymentFailed});
}

/// @nodoc
class _$LiabilityStateCopyWithImpl<$Res, $Val extends LiabilityState>
    implements $LiabilityStateCopyWith<$Res> {
  _$LiabilityStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedLiability = null,
    Object? fetchingLiabilitiess = null,
    Object? liabilitiessFetchTime = null,
    Object? fetchingSingleLiabilityDetails = null,
    Object? initiatedActionType = null,
    Object? initiatingForeclosure = null,
    Object? verifyingForeclosure = null,
    Object? loanForeclosureFailed = null,
    Object? prepaymentId = null,
    Object? initiatingPrepayment = null,
    Object? verifyingPrepaymentSuccess = null,
    Object? prepaymentFailed = null,
    Object? missedEmiPaymentId = null,
    Object? initiatingMissedEmiPayment = null,
    Object? verifyingMissedEmiPaymentSuccess = null,
    Object? missedEmiPaymentFailed = null,
  }) {
    return _then(_value.copyWith(
      selectedLiability: null == selectedLiability
          ? _value.selectedLiability
          : selectedLiability // ignore: cast_nullable_to_non_nullable
              as LoanDetails,
      fetchingLiabilitiess: null == fetchingLiabilitiess
          ? _value.fetchingLiabilitiess
          : fetchingLiabilitiess // ignore: cast_nullable_to_non_nullable
              as bool,
      liabilitiessFetchTime: null == liabilitiessFetchTime
          ? _value.liabilitiessFetchTime
          : liabilitiessFetchTime // ignore: cast_nullable_to_non_nullable
              as int,
      fetchingSingleLiabilityDetails: null == fetchingSingleLiabilityDetails
          ? _value.fetchingSingleLiabilityDetails
          : fetchingSingleLiabilityDetails // ignore: cast_nullable_to_non_nullable
              as bool,
      initiatedActionType: null == initiatedActionType
          ? _value.initiatedActionType
          : initiatedActionType // ignore: cast_nullable_to_non_nullable
              as InvoiceLoanInitiatedActionType,
      initiatingForeclosure: null == initiatingForeclosure
          ? _value.initiatingForeclosure
          : initiatingForeclosure // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingForeclosure: null == verifyingForeclosure
          ? _value.verifyingForeclosure
          : verifyingForeclosure // ignore: cast_nullable_to_non_nullable
              as bool,
      loanForeclosureFailed: null == loanForeclosureFailed
          ? _value.loanForeclosureFailed
          : loanForeclosureFailed // ignore: cast_nullable_to_non_nullable
              as bool,
      prepaymentId: null == prepaymentId
          ? _value.prepaymentId
          : prepaymentId // ignore: cast_nullable_to_non_nullable
              as String,
      initiatingPrepayment: null == initiatingPrepayment
          ? _value.initiatingPrepayment
          : initiatingPrepayment // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingPrepaymentSuccess: null == verifyingPrepaymentSuccess
          ? _value.verifyingPrepaymentSuccess
          : verifyingPrepaymentSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      prepaymentFailed: null == prepaymentFailed
          ? _value.prepaymentFailed
          : prepaymentFailed // ignore: cast_nullable_to_non_nullable
              as bool,
      missedEmiPaymentId: null == missedEmiPaymentId
          ? _value.missedEmiPaymentId
          : missedEmiPaymentId // ignore: cast_nullable_to_non_nullable
              as String,
      initiatingMissedEmiPayment: null == initiatingMissedEmiPayment
          ? _value.initiatingMissedEmiPayment
          : initiatingMissedEmiPayment // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingMissedEmiPaymentSuccess: null == verifyingMissedEmiPaymentSuccess
          ? _value.verifyingMissedEmiPaymentSuccess
          : verifyingMissedEmiPaymentSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      missedEmiPaymentFailed: null == missedEmiPaymentFailed
          ? _value.missedEmiPaymentFailed
          : missedEmiPaymentFailed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LiabilityStateImplCopyWith<$Res>
    implements $LiabilityStateCopyWith<$Res> {
  factory _$$LiabilityStateImplCopyWith(_$LiabilityStateImpl value,
          $Res Function(_$LiabilityStateImpl) then) =
      __$$LiabilityStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LoanDetails selectedLiability,
      bool fetchingLiabilitiess,
      int liabilitiessFetchTime,
      bool fetchingSingleLiabilityDetails,
      InvoiceLoanInitiatedActionType initiatedActionType,
      bool initiatingForeclosure,
      bool verifyingForeclosure,
      bool loanForeclosureFailed,
      String prepaymentId,
      bool initiatingPrepayment,
      bool verifyingPrepaymentSuccess,
      bool prepaymentFailed,
      String missedEmiPaymentId,
      bool initiatingMissedEmiPayment,
      bool verifyingMissedEmiPaymentSuccess,
      bool missedEmiPaymentFailed});
}

/// @nodoc
class __$$LiabilityStateImplCopyWithImpl<$Res>
    extends _$LiabilityStateCopyWithImpl<$Res, _$LiabilityStateImpl>
    implements _$$LiabilityStateImplCopyWith<$Res> {
  __$$LiabilityStateImplCopyWithImpl(
      _$LiabilityStateImpl _value, $Res Function(_$LiabilityStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedLiability = null,
    Object? fetchingLiabilitiess = null,
    Object? liabilitiessFetchTime = null,
    Object? fetchingSingleLiabilityDetails = null,
    Object? initiatedActionType = null,
    Object? initiatingForeclosure = null,
    Object? verifyingForeclosure = null,
    Object? loanForeclosureFailed = null,
    Object? prepaymentId = null,
    Object? initiatingPrepayment = null,
    Object? verifyingPrepaymentSuccess = null,
    Object? prepaymentFailed = null,
    Object? missedEmiPaymentId = null,
    Object? initiatingMissedEmiPayment = null,
    Object? verifyingMissedEmiPaymentSuccess = null,
    Object? missedEmiPaymentFailed = null,
  }) {
    return _then(_$LiabilityStateImpl(
      selectedLiability: null == selectedLiability
          ? _value.selectedLiability
          : selectedLiability // ignore: cast_nullable_to_non_nullable
              as LoanDetails,
      fetchingLiabilitiess: null == fetchingLiabilitiess
          ? _value.fetchingLiabilitiess
          : fetchingLiabilitiess // ignore: cast_nullable_to_non_nullable
              as bool,
      liabilitiessFetchTime: null == liabilitiessFetchTime
          ? _value.liabilitiessFetchTime
          : liabilitiessFetchTime // ignore: cast_nullable_to_non_nullable
              as int,
      fetchingSingleLiabilityDetails: null == fetchingSingleLiabilityDetails
          ? _value.fetchingSingleLiabilityDetails
          : fetchingSingleLiabilityDetails // ignore: cast_nullable_to_non_nullable
              as bool,
      initiatedActionType: null == initiatedActionType
          ? _value.initiatedActionType
          : initiatedActionType // ignore: cast_nullable_to_non_nullable
              as InvoiceLoanInitiatedActionType,
      initiatingForeclosure: null == initiatingForeclosure
          ? _value.initiatingForeclosure
          : initiatingForeclosure // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingForeclosure: null == verifyingForeclosure
          ? _value.verifyingForeclosure
          : verifyingForeclosure // ignore: cast_nullable_to_non_nullable
              as bool,
      loanForeclosureFailed: null == loanForeclosureFailed
          ? _value.loanForeclosureFailed
          : loanForeclosureFailed // ignore: cast_nullable_to_non_nullable
              as bool,
      prepaymentId: null == prepaymentId
          ? _value.prepaymentId
          : prepaymentId // ignore: cast_nullable_to_non_nullable
              as String,
      initiatingPrepayment: null == initiatingPrepayment
          ? _value.initiatingPrepayment
          : initiatingPrepayment // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingPrepaymentSuccess: null == verifyingPrepaymentSuccess
          ? _value.verifyingPrepaymentSuccess
          : verifyingPrepaymentSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      prepaymentFailed: null == prepaymentFailed
          ? _value.prepaymentFailed
          : prepaymentFailed // ignore: cast_nullable_to_non_nullable
              as bool,
      missedEmiPaymentId: null == missedEmiPaymentId
          ? _value.missedEmiPaymentId
          : missedEmiPaymentId // ignore: cast_nullable_to_non_nullable
              as String,
      initiatingMissedEmiPayment: null == initiatingMissedEmiPayment
          ? _value.initiatingMissedEmiPayment
          : initiatingMissedEmiPayment // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingMissedEmiPaymentSuccess: null == verifyingMissedEmiPaymentSuccess
          ? _value.verifyingMissedEmiPaymentSuccess
          : verifyingMissedEmiPaymentSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      missedEmiPaymentFailed: null == missedEmiPaymentFailed
          ? _value.missedEmiPaymentFailed
          : missedEmiPaymentFailed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LiabilityStateImpl implements _LiabilityState {
  const _$LiabilityStateImpl(
      {required this.selectedLiability,
      required this.fetchingLiabilitiess,
      required this.liabilitiessFetchTime,
      required this.fetchingSingleLiabilityDetails,
      required this.initiatedActionType,
      required this.initiatingForeclosure,
      required this.verifyingForeclosure,
      required this.loanForeclosureFailed,
      required this.prepaymentId,
      required this.initiatingPrepayment,
      required this.verifyingPrepaymentSuccess,
      required this.prepaymentFailed,
      required this.missedEmiPaymentId,
      required this.initiatingMissedEmiPayment,
      required this.verifyingMissedEmiPaymentSuccess,
      required this.missedEmiPaymentFailed});

  @override
  final LoanDetails selectedLiability;
  @override
  final bool fetchingLiabilitiess;
  @override
  final int liabilitiessFetchTime;
  @override
  final bool fetchingSingleLiabilityDetails;
// Actions
  @override
  final InvoiceLoanInitiatedActionType initiatedActionType;
// Foreclosure
  @override
  final bool initiatingForeclosure;
  @override
  final bool verifyingForeclosure;
  @override
  final bool loanForeclosureFailed;
// Prepayment
  @override
  final String prepaymentId;
  @override
  final bool initiatingPrepayment;
  @override
  final bool verifyingPrepaymentSuccess;
  @override
  final bool prepaymentFailed;
// Missed EMI Payment
  @override
  final String missedEmiPaymentId;
  @override
  final bool initiatingMissedEmiPayment;
  @override
  final bool verifyingMissedEmiPaymentSuccess;
  @override
  final bool missedEmiPaymentFailed;

  @override
  String toString() {
    return 'LiabilityState(selectedLiability: $selectedLiability, fetchingLiabilitiess: $fetchingLiabilitiess, liabilitiessFetchTime: $liabilitiessFetchTime, fetchingSingleLiabilityDetails: $fetchingSingleLiabilityDetails, initiatedActionType: $initiatedActionType, initiatingForeclosure: $initiatingForeclosure, verifyingForeclosure: $verifyingForeclosure, loanForeclosureFailed: $loanForeclosureFailed, prepaymentId: $prepaymentId, initiatingPrepayment: $initiatingPrepayment, verifyingPrepaymentSuccess: $verifyingPrepaymentSuccess, prepaymentFailed: $prepaymentFailed, missedEmiPaymentId: $missedEmiPaymentId, initiatingMissedEmiPayment: $initiatingMissedEmiPayment, verifyingMissedEmiPaymentSuccess: $verifyingMissedEmiPaymentSuccess, missedEmiPaymentFailed: $missedEmiPaymentFailed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiabilityStateImpl &&
            (identical(other.selectedLiability, selectedLiability) ||
                other.selectedLiability == selectedLiability) &&
            (identical(other.fetchingLiabilitiess, fetchingLiabilitiess) ||
                other.fetchingLiabilitiess == fetchingLiabilitiess) &&
            (identical(other.liabilitiessFetchTime, liabilitiessFetchTime) ||
                other.liabilitiessFetchTime == liabilitiessFetchTime) &&
            (identical(other.fetchingSingleLiabilityDetails,
                    fetchingSingleLiabilityDetails) ||
                other.fetchingSingleLiabilityDetails ==
                    fetchingSingleLiabilityDetails) &&
            (identical(other.initiatedActionType, initiatedActionType) ||
                other.initiatedActionType == initiatedActionType) &&
            (identical(other.initiatingForeclosure, initiatingForeclosure) ||
                other.initiatingForeclosure == initiatingForeclosure) &&
            (identical(other.verifyingForeclosure, verifyingForeclosure) ||
                other.verifyingForeclosure == verifyingForeclosure) &&
            (identical(other.loanForeclosureFailed, loanForeclosureFailed) ||
                other.loanForeclosureFailed == loanForeclosureFailed) &&
            (identical(other.prepaymentId, prepaymentId) ||
                other.prepaymentId == prepaymentId) &&
            (identical(other.initiatingPrepayment, initiatingPrepayment) ||
                other.initiatingPrepayment == initiatingPrepayment) &&
            (identical(other.verifyingPrepaymentSuccess,
                    verifyingPrepaymentSuccess) ||
                other.verifyingPrepaymentSuccess ==
                    verifyingPrepaymentSuccess) &&
            (identical(other.prepaymentFailed, prepaymentFailed) ||
                other.prepaymentFailed == prepaymentFailed) &&
            (identical(other.missedEmiPaymentId, missedEmiPaymentId) ||
                other.missedEmiPaymentId == missedEmiPaymentId) &&
            (identical(other.initiatingMissedEmiPayment,
                    initiatingMissedEmiPayment) ||
                other.initiatingMissedEmiPayment ==
                    initiatingMissedEmiPayment) &&
            (identical(other.verifyingMissedEmiPaymentSuccess,
                    verifyingMissedEmiPaymentSuccess) ||
                other.verifyingMissedEmiPaymentSuccess ==
                    verifyingMissedEmiPaymentSuccess) &&
            (identical(other.missedEmiPaymentFailed, missedEmiPaymentFailed) ||
                other.missedEmiPaymentFailed == missedEmiPaymentFailed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedLiability,
      fetchingLiabilitiess,
      liabilitiessFetchTime,
      fetchingSingleLiabilityDetails,
      initiatedActionType,
      initiatingForeclosure,
      verifyingForeclosure,
      loanForeclosureFailed,
      prepaymentId,
      initiatingPrepayment,
      verifyingPrepaymentSuccess,
      prepaymentFailed,
      missedEmiPaymentId,
      initiatingMissedEmiPayment,
      verifyingMissedEmiPaymentSuccess,
      missedEmiPaymentFailed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LiabilityStateImplCopyWith<_$LiabilityStateImpl> get copyWith =>
      __$$LiabilityStateImplCopyWithImpl<_$LiabilityStateImpl>(
          this, _$identity);
}

abstract class _LiabilityState implements LiabilityState {
  const factory _LiabilityState(
      {required final LoanDetails selectedLiability,
      required final bool fetchingLiabilitiess,
      required final int liabilitiessFetchTime,
      required final bool fetchingSingleLiabilityDetails,
      required final InvoiceLoanInitiatedActionType initiatedActionType,
      required final bool initiatingForeclosure,
      required final bool verifyingForeclosure,
      required final bool loanForeclosureFailed,
      required final String prepaymentId,
      required final bool initiatingPrepayment,
      required final bool verifyingPrepaymentSuccess,
      required final bool prepaymentFailed,
      required final String missedEmiPaymentId,
      required final bool initiatingMissedEmiPayment,
      required final bool verifyingMissedEmiPaymentSuccess,
      required final bool missedEmiPaymentFailed}) = _$LiabilityStateImpl;

  @override
  LoanDetails get selectedLiability;
  @override
  bool get fetchingLiabilitiess;
  @override
  int get liabilitiessFetchTime;
  @override
  bool get fetchingSingleLiabilityDetails;
  @override // Actions
  InvoiceLoanInitiatedActionType get initiatedActionType;
  @override // Foreclosure
  bool get initiatingForeclosure;
  @override
  bool get verifyingForeclosure;
  @override
  bool get loanForeclosureFailed;
  @override // Prepayment
  String get prepaymentId;
  @override
  bool get initiatingPrepayment;
  @override
  bool get verifyingPrepaymentSuccess;
  @override
  bool get prepaymentFailed;
  @override // Missed EMI Payment
  String get missedEmiPaymentId;
  @override
  bool get initiatingMissedEmiPayment;
  @override
  bool get verifyingMissedEmiPaymentSuccess;
  @override
  bool get missedEmiPaymentFailed;
  @override
  @JsonKey(ignore: true)
  _$$LiabilityStateImplCopyWith<_$LiabilityStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
