import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/http_controller/account.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/http_controller/confirm.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/http_controller/init.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/http_controller/search.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/http_controller/select.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/riverpod.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loan_request.g.dart';

@riverpod
class InvoiceNewLoanRequest extends _$InvoiceNewLoanRequest {
  @override
  LoanRequestStateData build() {
    ref.cacheFor(const Duration(seconds: 30), (){});
    return LoanRequestStateData.initial;
  }

  void reset() {
    ref.invalidateSelf();
  }

  void updateState(LoanRequestProgress progress) {
    state = state.copyWith(currentState: progress);
  }

  void setDownloadingGSTData(bool downloading) {
    state = state.copyWith(downloadingGSTData: downloading);
  }

  void setAADetails(AccountAggregatorInfo details) {
    state = state.copyWith(selectedAA: details);
  }

  void setSubmittingInvoicesForOffers(bool submittingData) {
    state = state.copyWith(submittingInvoicesForOffers: submittingData);
  }

  void setSelectedInvoice(LoanDetails invoice) {
    state = state.copyWith(selectedInvoice: invoice);
  }

  void setOfferSelected(OfferDetails offer) {
    state = state.copyWith(selectedOffer: offer);
  }

  void setUpdateMultipleSubmissionsEnabled(bool multiple) {
    state = state.copyWith(multipleSubmissionsForOfferUpdateForm: multiple);
  }

  void setTransactionId(String id) {
    state = state.copyWith(transactionId: id);
  }

  void setSkipAadharKyc(bool skip) {
    state = state.copyWith(skipAadharKyc: skip);
  }

  void setFetchingAadharKYCUrl(bool fetching) {
    state = state.copyWith(fetchingAadharKYCURl: fetching);
  }

  void setVerifyingAadharKYC(bool verifying) {
    state = state.copyWith(verifyingAadharKYC: verifying);
  }

  void setAadharKYCFailure(bool failure) {
    state = state.copyWith(aadharKYCFailure: failure);
  }

  void setSkipEntityKyc(bool skip) {
    state = state.copyWith(skipEntityKyc: skip);
  }

  void setFetchingEntityKYCUrl(bool fetching) {
    state = state.copyWith(fetchingEntityKYCURl: fetching);
  }

  void setVerifyingEntityKYC(bool verifying) {
    state = state.copyWith(verifyingEntityKYC: verifying);
  }

  void setEntityKYCFailure(bool failure) {
    state = state.copyWith(entityKYCFailure: failure);
  }

  void updateBankAccountNumber(String bankAccountNumber) {
    state = state.copyWith(bankAccountNumber: bankAccountNumber);
  }

  void updateBankIFSC(String bankIFSC) {
    state = state.copyWith(bankIFSC: bankIFSC);
  }

  void setSubmittingBankAccountDetails(bool submitting) {
    state = state.copyWith(submittingBankAccountDetails: submitting);
  }

  void setCheckingRepaymentSetupSuccess(bool checking) {
    state = state.copyWith(checkingRepaymentSetupSuccess: checking);
  }

  void setRepaymentSetupFailure(bool failure) {
    state = state.copyWith(repaymentSetupFailure: failure);
  }

  void setFetchingLoanAgreementForm(bool fetching) {
    state = state.copyWith(fetchingLoanAgreementForm: fetching);
  }

  void setLoanAgreementFailure(bool failure) {
    state = state.copyWith(loanAgreementFailure: failure);
  }

  void setVerifyingLoanAgreementSuccess(bool verifying) {
    state = state.copyWith(verifyingLoanAgreementSuccess: verifying);
  }

  void setGeneratingMonitoringConsent(bool generating) {
    state = state.copyWith(generatingMonitoringConsent: generating);
  }

  void setGenerateMonitoringConsentErr(bool err) {
    state = state.copyWith(generateMonitoringConsentErr: err);
  }

  void setValidatingMonitoringConsentSuccess(bool validating) {
    state = state.copyWith(validatingMonitoringConsentSuccess: validating);
  }

  void setMonitoringConsentError(bool error) {
    state = state.copyWith(monitoringConsentError: error);
  }

  double getProgressFillRatio() {
    return (state.currentState.index + 1) / LoanRequestProgress.values.length;
  }

  String getProgressUpdateText() {
    int totalSteps = LoanRequestProgress.values.length;
    int currentProgress = state.currentState.index + 1;

    return "Step $currentProgress of $totalSteps";
  }

  // Http Methods

  /* Provide GST Consent */
  Future<ServerResponse> provideGstConsent(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await LoanRequestAccountHttpController()
        .provideGstConsent(authToken, cancelToken);

    if (response.success) {
      state = state.copyWith(
          gstDataDownloadTime: response.data['dataDownloadTime'] ?? "");
    }

    return response;
  }

  /* Send GST OTP */
  Future<ServerResponse> sendGstOtp(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await LoanRequestAccountHttpController()
        .sendGstOtp(authToken, cancelToken);

    return response;
  }

  /* Verify GST OTP */
  Future<ServerResponse> verifyGstOtp(
      String otp, CancelToken cancelToken) async {
    if (!RegexProvider.otpRegex.hasMatch(otp)) {
      return ServerResponse(
        success: false,
        message: "Invalid OTP",
      );
    }

    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await LoanRequestAccountHttpController()
        .verifyGstOtp(otp, authToken, cancelToken);

    if (response.success) {
      state = state.copyWith(gstDataDownloadTime: response.data);
    }

    return response;
  }

  /* Download GST Data */
  Future<ServerResponse> downloadGstData(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(downloadingGSTData: true);

    var response = await LoanRequestAccountHttpController()
        .downloadGstData(authToken, cancelToken);

    state = state.copyWith(downloadingGSTData: false);

    if (response.success) {
      state = state.copyWith(gstDataDownloadTime: response.data);
    }

    return response;
  }

  /* Fetch Invoices */
  Future<ServerResponse> fetchGstInvoices(CancelToken cancelToken) async {
    state = state.copyWith(loadingInvoices: true);

    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await LoanRequestAccountHttpController()
        .fetchGstInvoices(authToken, cancelToken);

    state = state.copyWith(loadingInvoices: false);

    if (response.success) {
      state = state.copyWith(invoices: response.data['formattedInvoices']);
    }

    return response;
  }

  // ONDC Methods --------------------------------------------------------------------

  // Search --------------
  Future<ServerResponse> performGeneralSearch(
      bool foreceNew, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    reset();

    state = state.copyWith(requestingNewLoan: true);

    var response = await LoanRequestSearchHttpController()
        .performGeneralSearch(foreceNew, authToken, cancelToken);

    if (response.success) {
      state =
          state.copyWith(transactionId: response.data?['transactionId'] ?? '');

      if (response.data['redirection']) {
        var invoiceWithOffer = response.data['invoiceWithOffer'] as LoanDetails;

        String currentState = invoiceWithOffer.offerDetails.state.isEmpty
            ? invoiceWithOffer.offerDetailsList.isNotEmpty
                ? invoiceWithOffer.offerDetailsList[0].state
                : ""
            : invoiceWithOffer.offerDetails.state;

        var updatedState = getState(currentState);

        state = state.copyWith(
          selectedInvoice: invoiceWithOffer,
          selectedOffer: invoiceWithOffer.offerDetails,
          currentState: updatedState,
        );
      }
    }

    state = state.copyWith(requestingNewLoan: false);

    return response;
  }

  // Submit Forms
  Future<ServerResponse> submitForms(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(submittingInvoicesForOffers: true);

    var response = await LoanRequestSearchHttpController()
        .submitForms(state.transactionId, authToken, cancelToken);

    var accountAggregatorId =
        ref.read(invoiceLoanUserProfileDetailsProvider).accountAggregatorId;

    var accountAggregatorName = accountAggregatorId.split("@").elementAt(1);

    var selectedAA = getAccountAggregatorInfo(accountAggregatorName);

    selectedAA.setId(ref.read(invoiceLoanUserProfileDetailsProvider).phone);

    if (response.success) {
      state = state.copyWith(
          submittingInvoicesForOffers: false,
          selectedAA: selectedAA,
          currentState: LoanRequestProgress.customerDetailsProvided);
    }

    return response;
  }

  Future<ServerResponse> generateAAURL(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;

    var aaId = state.selectedAA.aaId;
    var aaURL = state.selectedAA.url;
    var key = state.selectedAA.key;

    if (transactionId.isEmpty || aaId.isEmpty || aaURL.isEmpty || key.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction Id or Account Aggregator Id not set. Restart the Journey or Contact Support!",
      );
    }

    return await LoanRequestSearchHttpController()
        .generateAAUrl(transactionId, aaId, aaURL, key, authToken, cancelToken);
  }

  Future<ServerResponse> checkConsentSuccess(
      String ecres, String resdate, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var key = state.selectedAA.key;

    if (transactionId.isEmpty || key.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction Id or Account Aggregator Id not set. Restart the Journey or Contact Support!",
      );
    }

    return await LoanRequestSearchHttpController().checkConsentSuccess(
        transactionId, ecres, resdate, key, authToken, cancelToken);
  }

  // Fetch Invoices with Offers
  Future<ServerResponse> fetchLoanOffers(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(fetchingInvoiceWithOffers: true);

    var response = await LoanRequestSearchHttpController()
        .fetchLoanOffers(state.transactionId, authToken, cancelToken);

    if (response.success) {
      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
              state.invoiceWithOffersFetchTime >
          900) {
        state = state.copyWith(
            invoicesWithOffers: response.data,
            invoiceWithOffersFetchTime:
                DateTime.now().millisecondsSinceEpoch ~/ 1000);
      } else {
        state = state.copyWith(
          invoicesWithOffers: response.data,
        );
      }
    }

    await Future.delayed(const Duration(seconds: 3));

    state = state.copyWith(fetchingInvoiceWithOffers: false);

    return response;
  }

  Future<ServerResponse> fetchLoanOffersBackground(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await LoanRequestSearchHttpController()
        .fetchLoanOffers(state.transactionId, authToken, cancelToken);

    if (response.success) {
      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
              state.invoiceWithOffersFetchTime >
          900) {
        state = state.copyWith(
            invoicesWithOffers: response.data,
            invoiceWithOffersFetchTime:
                DateTime.now().millisecondsSinceEpoch ~/ 1000);
      } else {
        state = state.copyWith(
          invoicesWithOffers: response.data,
        );
      }
    }

    return response;
  }

  // Select --------------
  Future<ServerResponse> refetchSelectedOfferDetails(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;
    var offerId = state.selectedOffer.offerId;

    if (transactionId.isEmpty || providerId.isEmpty || offerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID or  OfferId is empty. Restart the process!",
      );
    }

    var response = await LoanRequestSelectHttpController()
        .refetchSelectedOfferDetails(
            transactionId, offerId, providerId, authToken, cancelToken);

    if (response.success) {
      state = state.copyWith(selectedOffer: response.data);
    }

    return response;
  }

  Future<ServerResponse> selectOffer(
      String transactionId,
      String providerId,
      String offerId,
      String invoiceId,
      String parentItemId,
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    if (transactionId.isEmpty ||
        providerId.isEmpty ||
        invoiceId.isEmpty ||
        offerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID or InvoiceId or OfferId is empty. Restart the process!",
      );
    }

    var response = await LoanRequestSelectHttpController().selectOffer(
        transactionId,
        offerId,
        invoiceId,
        providerId,
        parentItemId,
        authToken,
        cancelToken);

    if (response.success) {
      state = state.copyWith(
          offerSelected: true,
          loanUpdateFormSubmitted: false,
          currentState: LoanRequestProgress.loanOfferSelected);
    }

    return response;
  }

  // In case aadhar kyc is to be skipped, perform the init request. Otherwise move to aadhar kyc screen

  Future<ServerResponse> submitLoanUpdateForm(
      String amount, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    String loanAmount = amount;
    String loanTerm = state.selectedOffer.tenure;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID  is empty. Restart the process!",
      );
    }

    var response = await LoanRequestSelectHttpController().submitLoanUpdateForm(
        transactionId,
        providerId,
        loanTerm,
        loanAmount,
        authToken,
        cancelToken);

    if (response.success) {
      state = state.copyWith(
        loanUpdateFormSubmitted: true,
      );
    }

    return response;
  }

  Future<ServerResponse> fetchAadharKycUrl(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID  is empty. Restart the process!",
      );
    }

    state = state.copyWith(fetchingAadharKYCURl: true);

    var response = await LoanRequestSelectHttpController()
        .fetchAadharKycUrl(transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(fetchingAadharKYCURl: false);

    return response;
  }

  Future<ServerResponse> refetchAadharKycUrl(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID  is empty. Restart the process!",
      );
    }

    state = state.copyWith(fetchingAadharKYCURl: true, aadharKYCFailure: false);

    var response = await LoanRequestSelectHttpController()
        .refetchAadharKycUrl(transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(fetchingAadharKYCURl: false);

    return response;
  }

  Future<ServerResponse> checkAadharKycSuccess(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID  is empty. Restart the process!",
      );
    }

    state = state.copyWith(verifyingAadharKYC: true);

    var response = await LoanRequestSelectHttpController()
        .checkAadharKycSuccess(
            transactionId, providerId, authToken, cancelToken);
    state = state.copyWith(verifyingAadharKYC: false);

    return response;
  }

  Future<ServerResponse> performInitRequest(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Transaction ID or Provider ID is empty. Restart the process!",
      );
    }

    var response = await LoanRequestInitHttpController()
        .performInitRequest(transactionId, providerId, authToken, cancelToken);
    state = state.copyWith(verifyingAadharKYC: false);

    return response;
  }

  Future<ServerResponse> fetchEntityKycForm(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID  is empty. Restart the process!",
      );
    }

    state = state.copyWith(fetchingEntityKYCURl: true);

    var response = await LoanRequestInitHttpController()
        .fetchEntityKycForm(transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(fetchingEntityKYCURl: false);

    return response;
  }

  Future<ServerResponse> refetchEntityKycForm(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID  is empty. Restart the process!",
      );
    }

    state = state.copyWith(fetchingEntityKYCURl: true, entityKYCFailure: false);

    var response = await LoanRequestInitHttpController().refetchEntityKycForm(
        transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(fetchingEntityKYCURl: false);

    return response;
  }

  Future<ServerResponse> checkEntityKycFormSuccess(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID  is empty. Restart the process!",
      );
    }

    state = state.copyWith(verifyingEntityKYC: true);

    var response = await LoanRequestInitHttpController()
        .checkEntityKycFormSuccess(
            transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(verifyingEntityKYC: false);

    return response;
  }

  Future<ServerResponse> fetchBankAccountFormDetails(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Transaction ID or Provider ID is empty. Restart the process!",
      );
    }

    return await LoanRequestInitHttpController().fetchBankAccountFormDetails(
        transactionId, providerId, authToken, cancelToken);
  }

  Future<ServerResponse> submitBankAccountDetails(
      bool skipBankVerification, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var bankAccountNumber = state.bankAccountNumber;
    var bankIFSC = state.bankIFSC;
    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (bankAccountNumber.isEmpty || bankIFSC.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Bank Account Details are empty",
      );
    }

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Transaction ID or Provider ID is empty. Restart the process!",
      );
    }

    return await LoanRequestInitHttpController().submitBankAccountDetails(
        bankAccountNumber,
        bankIFSC,
        transactionId,
        providerId,
        authToken,
        cancelToken);
  }

  Future<ServerResponse> fetchRepaymentSetupUrl(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Transaction ID or Provider ID is empty. Restart the process!",
      );
    }

    state = state.copyWith(fetchingRepaymentSetupUrl: true);

    var response = await LoanRequestInitHttpController().fetchRepaymentSetupUrl(
        transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(fetchingRepaymentSetupUrl: false);

    if (response.success) {
      state = state.copyWith(
          sanctionedCancellationFee:
              response.data['sanctionedCancellationFee']);
    }

    return response;
  }

  Future<ServerResponse> checkRepaymentSetupSuccess(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Transaction ID or Provider ID is empty. Restart the process!",
      );
    }

    state = state.copyWith(checkingRepaymentSetupSuccess: true);

    var response = await LoanRequestInitHttpController()
        .checkRepaymentSetupSuccess(
            transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(checkingRepaymentSetupSuccess: false);

    return response;
  }

  Future<ServerResponse> refetchRepaymentSetupForm(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID  is empty. Restart the process!",
      );
    }

    return await LoanRequestInitHttpController().refetchRepaymentSetupForm(
        transactionId, providerId, authToken, cancelToken);
  }

  Future<ServerResponse> fetchLoanAgreementUrl(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Transaction ID or Provider ID is empty. Restart the process!",
      );
    }

    return await LoanRequestInitHttpController().fetchLoanAgreementForm(
        transactionId, providerId, authToken, cancelToken);
  }

  Future<ServerResponse> submitLoanAgreementForm(
      String otp, CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Transaction ID or Provider ID is empty. Restart the process!",
      );
    }

    if (!RegexProvider.otpRegex.hasMatch(otp)) {
      return ServerResponse(
        success: false,
        message: "Invalid OTP",
      );
    }

    state = state.copyWith(verifyingLoanAgreementSuccess: true);

    var response = await LoanRequestInitHttpController()
        .submitLoanAgreementForm(
            otp, transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(verifyingLoanAgreementSuccess: false);

    return response;
  }

  Future<ServerResponse> checkLoanAgreementSuccess(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Transaction ID or Provider ID is empty. Restart the process!",
      );
    }

    state = state.copyWith(verifyingLoanAgreementSuccess: true);

    var response = await LoanRequestInitHttpController()
        .checkLoanAgreementSuccess(
            transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(verifyingLoanAgreementSuccess: false);

    return response;
  }

  Future<ServerResponse> refetchLoanAgreementForm(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction ID or Provider ID  is empty. Restart the process!",
      );
    }

    return await LoanRequestInitHttpController().refetchLoanAgreementForm(
        transactionId, providerId, authToken, cancelToken);
  }

  Future<ServerResponse> checkMonitoringConsentRequirement(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Transaction ID or Provider ID is empty. Restart the process!",
      );
    }

    return await LoanRequestConfirmHttpController()
        .checkMonitoringConsentRequirement(
            transactionId, providerId, authToken, cancelToken);
  }

  Future<ServerResponse> generateLoanMonitoringConsentRequest(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;
    var aaId = state.selectedAA.aaId;
    var aaURL = state.selectedAA.url;

    if (transactionId.isEmpty ||
        aaId.isEmpty ||
        aaURL.isEmpty ||
        providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction Id, Provider Id or Account Aggregator Id not set. Restart the Journey or Contact Support!",
      );
    }

    state = state.copyWith(
        generatingMonitoringConsent: true, monitoringConsentError: false);

    var response = await LoanRequestConfirmHttpController()
        .generateMonitoringConsentUrl(aaId, aaURL, state.selectedAA.key,
            transactionId, providerId, authToken, cancelToken);

    state = state.copyWith(
      generatingMonitoringConsent: true,
    );

    return response;
  }

  Future<ServerResponse> checkLoanMonitoringConsentSuccess(
      CancelToken cancelToken, String ecres, String resdate) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var offerProviderId = state.selectedOffer.offerProviderId;

    if (ecres.isEmpty || resdate.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "ECRES or RESDATE not set. Restart the Journey or Contact Support!",
      );
    }

    if (transactionId.isEmpty ||
        offerProviderId.isEmpty ||
        state.selectedAA.key.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction Id or Account Aggregator Id not set. Restart the Journey or Contact Support!",
      );
    }

    state = state.copyWith(
        validatingMonitoringConsentSuccess: true,
        monitoringConsentError: false);

    var response = await LoanRequestConfirmHttpController()
        .checkMonitoringConsentSuccess(ecres, resdate, state.selectedAA.key,
            transactionId, offerProviderId, authToken, cancelToken);

    state = state.copyWith(
        loanId: response.data, validatingMonitoringConsentSuccess: false);

    return response;
  }

  Future<ServerResponse> checkLoanDisbursementSuccess(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
        success: false,
        message:
            "Transaction Id or Provider Id. Restart the Journey or Contact Support!",
      );
    }

    var response = await LoanRequestConfirmHttpController()
        .checkLoanDisbursementSuccess(
            transactionId, providerId, authToken, cancelToken);

    if (response.success) {
      state = state.copyWith(loanId: transactionId);
    }

    return response;
  }
}

LoanRequestProgress getState(String currentState) {
  switch (currentState) {
    case "general_search_pending" || "general_search_complete":
      {
        return LoanRequestProgress.started;
      }
    case "search_01_pending" || "search_01_complete":
      {
        return LoanRequestProgress.invoiceSelect;
      }
    case "search_complete" ||
          "select_01_pending" ||
          "select_02_pending" ||
          "select_02_complete":
      {
        return LoanRequestProgress.customerDetailsProvided;
      }
    case "init_01_pending" || "init_01_complete":
      {
        return LoanRequestProgress.aadharKycCompleted;
      }
    case "init_02_pending" || "init_02_complete":
      {
        return LoanRequestProgress.entityKycCompleted;
      }
    case "init_03_pending" || "init_03_complete":
      {
        LoanRequestProgress.bankAccountDetailsProvided;
      }
    case "init_04_pending" || "init_04_complete":
      {
        LoanRequestProgress.repaymentSetupCompleted;
      }
    case "confirm_01_pending" || "confirm_01_complete":
      {
        LoanRequestProgress.loanAgreementCompleted;
      }
    default:
      {
        return LoanRequestProgress.started;
      }
  }

  return LoanRequestProgress.started;
}
