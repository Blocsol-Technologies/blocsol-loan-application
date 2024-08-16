
import 'package:blocsol_loan_application/personal_loan/state/user/utils/loan/loan_details.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'new_loan_state.freezed.dart';

enum NewLoanProgress {
  started,
  formGenerated,
  bankConsent,
  loanOfferSelect,
  aadharKYC,
  bankAccountDetails,
  repaymentSetup,
  loanAgreement,
  monitoringConsent,
  disbursed,
}

@freezed
class NewLoanStateData with _$NewLoanStateData {
  const factory NewLoanStateData({
    required NewLoanProgress currentState,
    required String transactionId,
    //
    required String annualIncome,
    required String selectedEmploymentType,
    required String selectedEndUse,
    required List<AccountAggregatorInfo> accountAggregatorInfoList,
    required AccountAggregatorInfo selectedAA,
    required bool aaConsentSuccess,

    //
    required bool offerSelected,
    required PersonalLoanDetails selectedOffer,
    required bool fetchingOffers,
    required List<PersonalLoanDetails> offers,
    required int offersFetchTime,
    required bool loanOfferUpdated,
    //
    required bool fetchingAadharKYCURl,
    required bool verifyingAadharKYC,
    required bool aadharKYCFailure,
    //
    required String bankType,
    required String bankAccountNumber,
    required String bankIFSC,
    required bool submittingBankAccountDetails,
    //
    required String disbursedCancellationFee,
    required String sanctionedCancellationFee,
    required bool checkingRepaymentSetupSuccess,
    required bool repaymentSetupFailure,
    //
    required bool fetchingLoanAgreementForm,
    required bool verifyingLoanAgreementSuccess,
    required bool loanAgreementFailure,
    required bool generatingMonitoringConsent,
    required bool generateMonitoringConsentErr,
    required bool validatingMonitoringConsentSuccess,
    required bool monitoringConsentError,
    required String loanId,
  }) = _NewLoanStateData;
}