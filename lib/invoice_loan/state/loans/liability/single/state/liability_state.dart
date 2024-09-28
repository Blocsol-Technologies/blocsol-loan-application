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
    required InvoiceLoanInitiatedActionType initiatedActionType,
    // Foreclosure
    required bool initiatingForeclosure,
    required bool verifyingForeclosure,
    required bool loanForeclosureFailed,

    // Prepayment
    required String prepaymentId,
    required bool initiatingPrepayment,
    required bool verifyingPrepaymentSuccess,
    required bool prepaymentFailed,

    // Missed EMI Payment
    required String missedEmiPaymentId,
    required bool initiatingMissedEmiPayment,
    required bool verifyingMissedEmiPaymentSuccess,
    required bool missedEmiPaymentFailed,
  }) = _LiabilityState;

  static var initial = LiabilityState(
    selectedLiability: LoanDetails.demo(),
    fetchingLiabilitiess: false,
    liabilitiessFetchTime: 0,
    fetchingSingleLiabilityDetails: false,
    // Actions

    initiatedActionType: InvoiceLoanInitiatedActionType.none,

    // Foreclosure
    initiatingForeclosure: false,
    verifyingForeclosure: false,
    loanForeclosureFailed: false,

    // Prepayment
    prepaymentId: "",
    initiatingPrepayment: false,
    verifyingPrepaymentSuccess: false,
    prepaymentFailed: false,

    // Missed EMI Payment

    missedEmiPaymentFailed: false,
    initiatingMissedEmiPayment: false,
    verifyingMissedEmiPaymentSuccess: false,
    missedEmiPaymentId: "",
  );
}
