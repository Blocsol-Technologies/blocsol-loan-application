import 'package:blocsol_loan_application/personal_loan/state/user/utils/loan/loan_details.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'new_loan_state.freezed.dart';

enum PersonalLoanRequestProgress {
  started,
  formGenerated,
  bankConsent,
  loanOfferSelect,
  aadharKYC,
  bankAccountDetails,
  repaymentSetup,
  loanAgreement,
  monitoringConsent,
  sanctioned,
}

@freezed
class NewLoanStateData with _$NewLoanStateData {
  const factory NewLoanStateData({
    required PersonalLoanRequestProgress currentState,
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

  static NewLoanStateData initial = NewLoanStateData(
    currentState: PersonalLoanRequestProgress.started,
    transactionId: "",
    //
    annualIncome: "",
    selectedEmploymentType: "salaried",
    selectedEndUse: "consumerDurablePurchase",
    accountAggregatorInfoList: [],
    selectedAA: AccountAggregatorInfo.demo(),
    aaConsentSuccess: false,
    //
    fetchingOffers: false,
    offers: [],
    offersFetchTime: 0,
    offerSelected: false,
    selectedOffer: PersonalLoanDetails.demoOffer(),
    loanOfferUpdated: false,
    //
    fetchingAadharKYCURl: false,
    verifyingAadharKYC: false,
    aadharKYCFailure: false,
    //
    bankAccountNumber: "",
    bankIFSC: "",
    bankType: "",
    submittingBankAccountDetails: false,
    //
    disbursedCancellationFee: "-",
    sanctionedCancellationFee: "-",
    checkingRepaymentSetupSuccess: false,
    repaymentSetupFailure: false,
    //
    fetchingLoanAgreementForm: false,
    verifyingLoanAgreementSuccess: false,
    loanAgreementFailure: false,
    generatingMonitoringConsent: false,
    generateMonitoringConsentErr: false,
    validatingMonitoringConsentSuccess: false,
    monitoringConsentError: false,
    loanId: "",
    //
  );
}
