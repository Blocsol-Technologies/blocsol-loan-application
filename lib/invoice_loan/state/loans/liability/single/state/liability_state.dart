import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'liability_state.freezed.dart';

@freezed
class LiabilityState with _$LiabilityState {
  const factory LiabilityState({
    required LoanDetails selectedLiability,
    required bool fetchingLiabilitiess,
    required int liabilitiessFetchTime,
    required bool fetchingSingleLiabilityDetails,
    // Actions
    required bool loanForeclosureFailed,
    required bool initiatingForeclosure,
    required bool prepaymentFailed,
    required bool initiatingPrepayment,
    required String prepaymentId,
    required bool missedEmiPaymentFailed,
    required bool initiatingMissedEmiPayment,
    required String missedEmiPaymentId,
  }) = _LiabilityState;

  static var initial = LiabilityState(
    selectedLiability: LoanDetails.demo(),
    fetchingLiabilitiess: false,
    liabilitiessFetchTime: 0,
    fetchingSingleLiabilityDetails: false,
    // Actions
    loanForeclosureFailed: false,
    initiatingForeclosure: false,
    prepaymentFailed: false,
    initiatingPrepayment: false,
    prepaymentId: "",
    missedEmiPaymentFailed: false,
    initiatingMissedEmiPayment: false,
    missedEmiPaymentId: "",
  );
}
