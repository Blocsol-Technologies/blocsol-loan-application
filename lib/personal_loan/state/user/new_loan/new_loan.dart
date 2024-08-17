import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/http_controllers/confirm_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/http_controllers/init_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/http_controllers/search_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/http_controllers/select_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/utils/loan/loan_details.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_loan.g.dart';

@riverpod
class PersonalNewLoanRequest extends _$PersonalNewLoanRequest {
  @override
  NewLoanStateData build() {
    ref.keepAlive();
    return NewLoanStateData(
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
      selectedOffer: PersonalLoanDetails.newOffer(),
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

  void updateState(PersonalLoanRequestProgress progress) {
    state = state.copyWith(currentState: progress);
  }

  void updateEmploymentType(String item) {
    state = state.copyWith(selectedEmploymentType: item);
  }

  void updateEndUse(String item) {
    state = state.copyWith(selectedEndUse: item);
  }

  void updateAnnualIncome(String income) {
    state = state.copyWith(annualIncome: income);
  }

  void updateAccountAggregatorInfoList(List<AccountAggregatorInfo> list) {
    state = state.copyWith(accountAggregatorInfoList: list);
  }

  void setSelectedAA(AccountAggregatorInfo aa) {
    state = state.copyWith(selectedAA: aa);
  }

  void setSelectedOffer(PersonalLoanDetails offer) {
    state = state.copyWith(selectedOffer: offer);
  }

  void setFetchingOffers(bool value) {
    state = state.copyWith(fetchingOffers: value);
  }

  void setLoanOfferUpdated(bool value) {
    state = state.copyWith(loanOfferUpdated: value);
  }

  void setOfferSelected(bool value) {
    state = state.copyWith(offerSelected: value);
  }

  void setVerifyingAadharKYC(bool value) {
    state = state.copyWith(verifyingAadharKYC: value);
  }

  void setAadharKYCFailure(bool value) {
    state = state.copyWith(aadharKYCFailure: value);
  }

  void updateBankAccountNumber(String number) {
    state = state.copyWith(bankAccountNumber: number);
  }

  void updateBankIFSC(String ifsc) {
    state = state.copyWith(bankIFSC: ifsc);
  }

  void updateBankType(String type) {
    state = state.copyWith(bankType: type);
  }

  void updateCheckingRepaymentSetupSuccess(bool value) {
    state = state.copyWith(checkingRepaymentSetupSuccess: value);
  }

  void updateRepaymentSetupFailure(bool value) {
    state = state.copyWith(repaymentSetupFailure: value);
  }

  void updateLoanAgreementFailure(bool value) {
    state = state.copyWith(loanAgreementFailure: value);
  }

  void reset() {
    state = NewLoanStateData(
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
      selectedOffer: PersonalLoanDetails.newOffer(),
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

  // ONDC Methdos

  // Search
  Future<ServerResponse> performGeneralSearch(
      bool foreceNew, CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    reset();

    var response = await PersonalLoanRequestSearchHttpController()
        .performGeneralSearch(foreceNew, authToken, cancelToken);

    if (response.success) {
      state =
          state.copyWith(transactionId: response.data['transaction_id'] ?? '');

      bool redirection = response.data['alreadyExts'] ?? false;

      // This will only be true if redirection is true
      if (redirection && response.data['offer'] != null) {
        PersonalLoanDetails offer =
            PersonalLoanDetails.fromJson(response.data['offer']);
        state = state.copyWith(
          selectedOffer: offer,
        );
      }

      return response;
    } else {
      return ServerResponse(
          success: false, message: response.data['message'], data: null);
    }
  }

  Future<ServerResponse> provideDataConsent(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    return await PersonalLoanRequestSearchHttpController()
        .provideDataConsent(authToken, cancelToken);
  }

  Future<ServerResponse> submitFormsAndGenerateAAURL(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanRequestSearchHttpController()
        .submitFormsAndGenerateAAURL(
            state.selectedEmploymentType,
            state.annualIncome,
            state.selectedEndUse,
            state.selectedAA,
            state.transactionId,
            authToken,
            cancelToken);

    return response;
  }

  Future<ServerResponse> checkConsentSuccess(
      String ecres, String resdate, CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    return await PersonalLoanRequestSearchHttpController().checkConsentSuccess(
        ecres,
        resdate,
        state.transactionId,
        state.selectedAA.key,
        authToken,
        cancelToken);
  }

  // Select
  Future<ServerResponse> fetchOffers(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    if (state.offers.isEmpty) {
      state = state.copyWith(fetchingOffers: true);
    }

    var response = await PersonalLoanRequestSelectHttpController()
        .fetchOffers(state.transactionId, authToken, cancelToken);

    state = state.copyWith(fetchingOffers: false);

    if (response.success) {
      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
              state.offersFetchTime >
          900) {
        state = state.copyWith(
            offers: response.data,
            offersFetchTime: DateTime.now().millisecondsSinceEpoch ~/ 1000);
      } else {
        state = state.copyWith(
          offers: response.data,
        );
      }
    }

    return response;
  }

  Future<ServerResponse> performSelect2(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanRequestSelectHttpController()
        .performSelect2(state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    return response;
  }

  Future<ServerResponse> performNextActionsAfterOfferSelection(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = state.transactionId;
    var providerId = state.selectedOffer.offerProviderId;

    if (transactionId.isEmpty || providerId.isEmpty) {
      return ServerResponse(
          success: false,
          message: "Transaction ID or Provider ID empty. Restart the process!",
          data: null);
    }

    var response = await PersonalLoanRequestSelectHttpController()
        .performNextActionsAfterOfferSelection(
            transactionId, providerId, authToken, cancelToken);

    return response;
  }

  Future<ServerResponse> submitLoanOfferChangeForm(
      String requestedAmount, CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    if (int.parse(requestedAmount) >
        double.parse(state.selectedOffer.deposit)) {
      return ServerResponse(
          success: false,
          message: "Requested amount cannot be greater than the loan amount",
          data: null);
    }

    if (int.parse(requestedAmount) < 5000) {
      requestedAmount = state.selectedOffer.deposit;
    }

    var response = await PersonalLoanRequestSelectHttpController()
        .submitLoanOfferChangeForm(requestedAmount, state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    return response;
  }

  Future<ServerResponse> fetchUpdatedLoanOffer(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    if (state.offers.isEmpty) {
      state = state.copyWith(fetchingOffers: true);
    }

    var response = await PersonalLoanRequestSelectHttpController()
        .fetchUpdatedLoanOffer(state.selectedOffer.offerId, state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    state = state.copyWith(fetchingOffers: false);

    if (response.success) {
      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
              state.offersFetchTime >
          900) {
        state = state.copyWith(
            selectedOffer: response.data,
            offersFetchTime: DateTime.now().millisecondsSinceEpoch ~/ 1000);
      } else {
        state = state.copyWith(
          offerSelected: true,
          selectedOffer: response.data,
        );
      }
    }

    return response;
  }

  // Init
  Future<ServerResponse> fetchAadharKYCURL(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(fetchingAadharKYCURl: true);

    var response = await PersonalLoanRequestInitController().fetchAadharKYCURL(
        state.transactionId,
        state.selectedOffer.offerProviderId,
        authToken,
        cancelToken);

    state = state.copyWith(fetchingAadharKYCURl: false);

    return response;
  }

  Future<ServerResponse> checkAadharKYCSuccess(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(verifyingAadharKYC: true);

    var response = await PersonalLoanRequestInitController()
        .checkAadharKYCSuccess(state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    state = state.copyWith(verifyingAadharKYC: false);

    return response;
  }

  Future<ServerResponse> refetchAadharKYCURL(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(fetchingAadharKYCURl: true, aadharKYCFailure: false);

    var response = await PersonalLoanRequestInitController()
        .refetchAadharKYCURL(state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);
    state =
        state.copyWith(fetchingAadharKYCURl: false, aadharKYCFailure: false);

    return response;
  }

  Future<ServerResponse> verifyBankAccountDetails(
      CancelToken cancelToken) async {
    if (state.bankType.isEmpty ||
        state.bankAccountNumber.isEmpty ||
        state.bankIFSC.isEmpty) {
      return ServerResponse(
          success: false, message: "Please fill all the details", data: null);
    }

    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanRequestInitController()
        .verifyBankAccountDetails(
            state.bankType,
            state.bankAccountNumber,
            state.bankIFSC,
            state.transactionId,
            state.selectedOffer.offerProviderId,
            authToken,
            cancelToken);

    return response;
  }

  Future<ServerResponse> fetchRepaymentURL(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanRequestInitController().fetchRepaymentURL(
        state.transactionId,
        state.selectedOffer.offerProviderId,
        authToken,
        cancelToken);

    return response;
  }

  Future<ServerResponse> checkRepaymentSuccess(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(checkingRepaymentSetupSuccess: true);

    var response = await PersonalLoanRequestInitController()
        .checkRepaymentSuccess(state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    state = state.copyWith(checkingRepaymentSetupSuccess: false);

    return response;
  }

  Future<ServerResponse> refetchRepaymentSetupURL(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(repaymentSetupFailure: false);

    return await PersonalLoanRequestInitController().refetchRepaymentSetupURL(
        state.transactionId,
        state.selectedOffer.offerProviderId,
        authToken,
        cancelToken);
  }

  Future<ServerResponse> fetchLoanAgreementURL(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(fetchingLoanAgreementForm: true);

    var response = await PersonalLoanRequestInitController()
        .fetchLoanAgreementURL(state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    state = state.copyWith(fetchingLoanAgreementForm: false);

    return response;
  }

  Future<ServerResponse> checkLoanAgreementSuccess(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(verifyingLoanAgreementSuccess: true);

    var response = await PersonalLoanRequestInitController()
        .checkLoanAgreementSuccess(state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    state = state.copyWith(verifyingLoanAgreementSuccess: false);

    return response;
  }

  Future<ServerResponse> submitLoanAgreementAndCheckSuccess(
      String otp, CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(verifyingLoanAgreementSuccess: true);

    var response = await PersonalLoanRequestInitController()
        .submitLoanAgreementAndCheckSuccess(otp, state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    state = state.copyWith(verifyingLoanAgreementSuccess: false);

    return response;
  }

  Future<ServerResponse> refetchLoanAgreementURL(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(
        fetchingLoanAgreementForm: true, loanAgreementFailure: false);

    var response = await PersonalLoanRequestInitController()
        .refetchLoanAgreementURL(state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    state = state.copyWith(fetchingLoanAgreementForm: false);

    return response;
  }

  // Confirm
  Future<ServerResponse> checkMonitoringConsentRequirement(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanRequestConfirmHttpController()
        .checkMonitoringConsentRequirement(state.transactionId,
            state.selectedOffer.offerProviderId, authToken, cancelToken);

    return response;
  }

  Future<ServerResponse> fetchLoanMonitoringAAURL(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

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
          data: null);
    }

    var response = await PersonalLoanRequestConfirmHttpController()
        .fetchLoanMonitoringAAURL(aaId, aaURL, state.selectedAA.key,
            transactionId, providerId, authToken, cancelToken);

    return response;
  }

  Future<ServerResponse> checkLoanMonitoringConsentSuccess(
      String ecres, String resdate, CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    var response = await PersonalLoanRequestConfirmHttpController()
        .checkLoanMonitoringConsentSuccess(
            ecres,
            resdate,
            state.selectedAA.key,
            state.transactionId,
            state.selectedOffer.offerProviderId,
            authToken,
            cancelToken);

    return response;
  }
}
