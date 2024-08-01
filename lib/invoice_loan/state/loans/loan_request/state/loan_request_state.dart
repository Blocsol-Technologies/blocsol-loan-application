import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_request_state.freezed.dart';

enum LoanRequestProgress {
  started,
  invoiceSelect,
  bankConsent,
  loanOfferSelect,
  aadharKYC,
  udyamKYC,
  bankAccountDetails,
  repaymentSetup,
  loanAgreement,
  monitoringConsent,
  disbursed,
}

@freezed
class LoanRequestStateData with _$LoanRequestStateData {
  const factory LoanRequestStateData({
    required LoanRequestProgress currentState,
    required String transactionId,
    required String gstDataDownloadTime,
    required bool downloadingGSTData,
    required int gstInvoicesFetchedTime,
    //
    required AccountAggregatorInfo selectedAA,
    required bool aaConsentSuccess,
    required List<Invoice> invoices,
    required bool loadingInvoices,
    required bool submittingInvoicesForOffers,
    required bool multipleSubmissionsForOfferUpdateForm,
    //
    required LoanDetails selectedInvoice,
    required OfferDetails selectedOffer,
    required bool fetchingInvoiceWithOffers,
    required bool offerSelected,
    required bool loanOfferUpdated,
    required List<LoanDetails> invoicesWithOffers,
    required int invoiceWithOffersFetchTime,
    //
    required bool fetchingAadharKYCURl,
    required bool verifyingAadharKYC,
    required bool aadharKYCFailure,
    required bool fetchingUdyamKYCURl,
    required bool verifyingUdyamKYC,
    required bool udyamKYCFailure,
    //
    required String bankName,
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
  }) = _LoanRequestStateData;

  static var initial = LoanRequestStateData(
    currentState: LoanRequestProgress.started,
    transactionId: '',
    gstDataDownloadTime: '',
    downloadingGSTData: false,
    gstInvoicesFetchedTime: 0,
    //
    selectedAA: AccountAggregatorInfo.demo(),
    aaConsentSuccess: false,
    invoices: [],
    loadingInvoices: false,
    submittingInvoicesForOffers: false,
    //
    selectedInvoice: LoanDetails.demo(),
    selectedOffer: OfferDetails.demo(),
    offerSelected: false,
    loanOfferUpdated: false,
    fetchingInvoiceWithOffers: false,
    invoicesWithOffers: [],
    invoiceWithOffersFetchTime: 0,
    multipleSubmissionsForOfferUpdateForm: false,
    //
    fetchingAadharKYCURl: false,
    verifyingAadharKYC: false,
    aadharKYCFailure: false,
    fetchingUdyamKYCURl: false,
    verifyingUdyamKYC: false,
    udyamKYCFailure: false,
    //
    bankName: '',
    bankAccountNumber: '',
    bankIFSC: '',
    submittingBankAccountDetails: false,
    //
    disbursedCancellationFee: '',
    sanctionedCancellationFee: '',
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
    loanId: '',
  );
}
