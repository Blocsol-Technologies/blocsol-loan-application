import 'package:blocsol_loan_application/personal_loan/state/user/utils/loan/loan_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'liability_state.freezed.dart';

@freezed
class LiabilityStateData with _$LiabilityStateData {
  const factory LiabilityStateData({
    required List<PersonalLoanDetails> oldLoans,
    required PersonalLoanDetails selectedOldOffer,
    required bool fetchingOldOffers,
    required int oldOffersFetchTime,
    // Actions
    required bool loanForeclosureFailed,
    required bool initiatingForeclosure,
    required bool prepaymentFailed,
    required bool initiatingPrepayment,
    required String prepaymentId,
    required bool missedEmiPaymentFailed,
    required bool initiatingMissedEmiPayment,
    required String missedEmiPaymentId,
  }) = _LiabilityStateData;

  static LiabilityStateData initial = LiabilityStateData(
      oldLoans: [],
      selectedOldOffer: PersonalLoanDetails.demoOffer(),
      fetchingOldOffers: false,
      oldOffersFetchTime: 0,
      loanForeclosureFailed: false,
      initiatingForeclosure: false,
      prepaymentFailed: false,
      initiatingPrepayment: false,
      prepaymentId: "",
      missedEmiPaymentFailed: false,
      initiatingMissedEmiPayment: false,
      missedEmiPaymentId: "");
}
