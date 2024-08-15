// import 'package:blocsol_personal_credit/state/auth/auth_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/utils/loan/loan_details.dart';
// import 'package:blocsol_personal_credit/utils/account_aggregator_utils.dart';
// import 'package:blocsol_personal_credit/utils/errors.dart';
// import 'package:blocsol_personal_credit/utils/http_service.dart';
// import 'package:blocsol_personal_credit/utils/schema.dart';
// import 'package:dio/dio.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'new_loan_state.freezed.dart';
// part 'new_loan_state.g.dart';

// enum NewLoanProgress {
//   started,
//   formGenerated,
//   bankConsent,
//   loanOfferSelect,
//   aadharKYC,
//   bankAccountDetails,
//   repaymentSetup,
//   loanAgreement,
//   monitoringConsent,
//   disbursed,
// }

// @freezed
// class NewLoanStateData with _$NewLoanStateData {
//   const factory NewLoanStateData({
//     required NewLoanProgress currentState,
//     required String transactionId,
//     //
//     required String annualIncome,
//     required String selectedEmploymentType,
//     required String selectedEndUse,
//     required List<AccountAggregatorInfo> accountAggregatorInfoList,
//     required AccountAggregatorInfo selectedAA,
//     required bool aaConsentSuccess,

//     //
//     required bool offerSelected,
//     required LoanDetails selectedOffer,
//     required bool fetchingOffers,
//     required List<LoanDetails> offers,
//     required int offersFetchTime,
//     required bool loanOfferUpdated,
//     //
//     required bool fetchingAadharKYCURl,
//     required bool verifyingAadharKYC,
//     required bool aadharKYCFailure,
//     //
//     required String bankType,
//     required String bankAccountNumber,
//     required String bankIFSC,
//     required bool submittingBankAccountDetails,
//     //
//     required String disbursedCancellationFee,
//     required String sanctionedCancellationFee,
//     required bool checkingRepaymentSetupSuccess,
//     required bool repaymentSetupFailure,
//     //
//     required bool fetchingLoanAgreementForm,
//     required bool verifyingLoanAgreementSuccess,
//     required bool loanAgreementFailure,
//     required bool generatingMonitoringConsent,
//     required bool generateMonitoringConsentErr,
//     required bool validatingMonitoringConsentSuccess,
//     required bool monitoringConsentError,
//     required String loanId,
//   }) = _NewLoanStateData;
// }

// @riverpod
// class NewLoanState extends _$NewLoanState {
//   @override
//   NewLoanStateData build() {
//     ref.keepAlive();
//     return NewLoanStateData(
//       currentState: NewLoanProgress.started,
//       transactionId: "",
//       //
//       annualIncome: "",
//       selectedEmploymentType: "salaried",
//       selectedEndUse: "consumerDurablePurchase",
//       accountAggregatorInfoList: [],
//       selectedAA: AccountAggregatorInfo.newInfo(),
//       aaConsentSuccess: false,
//       //
//       fetchingOffers: false,
//       offers: [],
//       offersFetchTime: 0,
//       offerSelected: false,
//       selectedOffer: LoanDetails.newOffer(),
//       loanOfferUpdated: false,
//       //
//       fetchingAadharKYCURl: false,
//       verifyingAadharKYC: false,
//       aadharKYCFailure: false,
//       //
//       bankAccountNumber: "",
//       bankIFSC: "",
//       bankType: "",
//       submittingBankAccountDetails: false,
//       //
//       disbursedCancellationFee: "-",
//       sanctionedCancellationFee: "-",
//       checkingRepaymentSetupSuccess: false,
//       repaymentSetupFailure: false,
//       //
//       fetchingLoanAgreementForm: false,
//       verifyingLoanAgreementSuccess: false,
//       loanAgreementFailure: false,
//       generatingMonitoringConsent: false,
//       generateMonitoringConsentErr: false,
//       validatingMonitoringConsentSuccess: false,
//       monitoringConsentError: false,
//       loanId: "",
//       //
//     );
//   }

//   void updateState(NewLoanProgress progress) {
//     state = state.copyWith(currentState: progress);
//   }

//   void updateEmploymentType(String item) {
//     state = state.copyWith(selectedEmploymentType: item);
//   }

//   void updateEndUse(String item) {
//     state = state.copyWith(selectedEndUse: item);
//   }

//   void updateAnnualIncome(String income) {
//     state = state.copyWith(annualIncome: income);
//   }

//   void updateAccountAggregatorInfoList(List<AccountAggregatorInfo> list) {
//     state = state.copyWith(accountAggregatorInfoList: list);
//   }

//   void setSelectedAA(AccountAggregatorInfo aa) {
//     state = state.copyWith(selectedAA: aa);
//   }

//   void setSelectedOffer(LoanDetails offer) {
//     state = state.copyWith(selectedOffer: offer);
//   }

//   void setFetchingOffers(bool value) {
//     state = state.copyWith(fetchingOffers: value);
//   }

//   void setLoanOfferUpdated(bool value) {
//     state = state.copyWith(loanOfferUpdated: value);
//   }

//   void setOfferSelected(bool value) {
//     state = state.copyWith(offerSelected: value);
//   }

//   void setVerifyingAadharKYC(bool value) {
//     state = state.copyWith(verifyingAadharKYC: value);
//   }

//   void setAadharKYCFailure(bool value) {
//     state = state.copyWith(aadharKYCFailure: value);
//   }

//   void updateBankAccountNumber(String number) {
//     state = state.copyWith(bankAccountNumber: number);
//   }

//   void updateBankIFSC(String ifsc) {
//     state = state.copyWith(bankIFSC: ifsc);
//   }

//   void updateBankType(String type) {
//     state = state.copyWith(bankType: type);
//   }

//   void updateCheckingRepaymentSetupSuccess(bool value) {
//     state = state.copyWith(checkingRepaymentSetupSuccess: value);
//   }

//   void updateRepaymentSetupFailure(bool value) {
//     state = state.copyWith(repaymentSetupFailure: value);
//   }

//   void updateLoanAgreementFailure(bool value) {
//     state = state.copyWith(loanAgreementFailure: value);
//   }

//   void reset() {
//     state = NewLoanStateData(
//       currentState: NewLoanProgress.started,
//       transactionId: "",
//       //
//       annualIncome: "",
//       selectedEmploymentType: "salaried",
//       selectedEndUse: "consumerDurablePurchase",
//       accountAggregatorInfoList: [],
//       selectedAA: AccountAggregatorInfo.newInfo(),
//       aaConsentSuccess: false,
//       //
//       fetchingOffers: false,
//       offers: [],
//       offersFetchTime: 0,
//       offerSelected: false,
//       selectedOffer: LoanDetails.newOffer(),
//       loanOfferUpdated: false,
//       //
//       fetchingAadharKYCURl: false,
//       verifyingAadharKYC: false,
//       aadharKYCFailure: false,
//       //
//       bankAccountNumber: "",
//       bankIFSC: "",
//       bankType: "",
//       submittingBankAccountDetails: false,
//       //
//       disbursedCancellationFee: "-",
//       sanctionedCancellationFee: "-",
//       checkingRepaymentSetupSuccess: false,
//       repaymentSetupFailure: false,
//       //
//       fetchingLoanAgreementForm: false,
//       verifyingLoanAgreementSuccess: false,
//       loanAgreementFailure: false,
//       generatingMonitoringConsent: false,
//       generateMonitoringConsentErr: false,
//       validatingMonitoringConsentSuccess: false,
//       monitoringConsentError: false,
//       loanId: "",
//       //
//     );
//   }

//   // ONDC Methdos
//   Future<ServerResponse> performGeneralSearch(
//       bool foreceNew, CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       reset();

//       var httpService = HttpService();
//       var response = await httpService.get("/ondc/general-search", authToken,
//           cancelToken, {"force_new": foreceNew ? "y" : "n"});

//       if (response.data['success']) {
//         state = state.copyWith(
//             transactionId: response.data['data']?['transaction_id'] ?? '');

//         bool redirection = response.data['data']?['alreadyExts'] ?? false;
//         String status = response.data['data']?['status'] ?? "search";
//         String stateVal = response.data['data']?['state'] ?? "search_00";

//         // This will only be true if redirection is true
//         if (redirection && response.data['data']?['offer'] != null) {
//           try {
//             LoanDetails offer =
//                 LoanDetails.fromJson(response.data['data']?['offer']);
//             state = state.copyWith(
//               selectedOffer: offer,
//             );
//           } catch (e, stackTrace) {
//             var err = ErrorInstance(
//                 exception: e,
//                 path: "/ondc/general-search",
//                 message: "Error occured when performing search for lenders",
//                 trace: stackTrace);
//             err.reportError();
//           }
//         }

//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               'redirection': redirection,
//               'status': status,
//               'state': stateVal,
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/general-search",
//           message: "Error occured when performing search for lenders",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when performing search for lenders! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // Provide Data Consent
//   Future<ServerResponse> provideDataConsent(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/provide-data-consent", authToken, cancelToken, {});

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/provide-data-consent",
//           message: "Error occured when providing data consent for lenders",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when when providing data consent for lenders! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // Submit forms and generate consent URL
//   Future<ServerResponse> submitFormsAndGenerateAAURL(
//       CancelToken cancelToken) async {
//     try {
//       state = state.copyWith(fetchingOffers: true);

//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         state = state.copyWith(fetchingOffers: false);
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/submit-personal-info-forms", authToken, cancelToken, {
//         "employment_type": state.selectedEmploymentType,
//         "income": state.annualIncome,
//         "end_use": state.selectedEndUse,
//         "aa_id": state.selectedAA.aaId,
//         "transaction_id": state.transactionId,
//       });

//       if (!response.data['success']) {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }

//       response = await httpService
//           .post("/ondc/generate_aa_url", authToken, cancelToken, {
//         "aa_name": state.selectedAA.key,
//         "aa_url": state.selectedAA.url,
//         "aa_id": state.selectedAA.aaId,
//         "transaction_id": state.transactionId,
//       });

//       state = state.copyWith(fetchingOffers: false);

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "url": response.data['data']['aa_url'],
//             });
//       } else {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/submit-personal-info-forms-and-generate-consent",
//           message:
//               "Error occured when submitting form and fetching aa consent for lenders",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when submitting form and fetching aa consent for lenders! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // Check AA Consent Success
//   Future<ServerResponse> checkConsentSuccess(
//       String ecres, String resdate, CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/check_aa_consent_success", authToken, cancelToken, {
//         "ecres": ecres,
//         "resdate": resdate,
//         "transaction_id": state.transactionId,
//         "aa_name": state.selectedAA.key
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/check_aa_consent_success",
//           message: "Error occured when checking consent success",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking consent success! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // Fetch Offers
//   Future<ServerResponse> fetchOffers(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       if (state.offers.isEmpty) {
//         state = state.copyWith(fetchingOffers: true);
//       }

//       var httpService = HttpService();
//       var response = await httpService.get("/ondc/fetch-offers", authToken,
//           cancelToken, {"transaction_id": state.transactionId});

//       state = state.copyWith(fetchingOffers: false);

//       if (response.data['success']) {
//         List<LoanDetails> formattedOffers = [];

//         try {
//           List<dynamic> offers = response.data['data']?['offers'] ?? [];

//           formattedOffers =
//               offers.map((item) => LoanDetails.fromJson(item)).toList();

//           state = state.copyWith(
//             offers: formattedOffers,
//           );
//         } catch (e, stackTrace) {
//           var err = ErrorInstance(
//               exception: e,
//               path: "/ondc/fetch-offers",
//               message: "Error occured when fetching offers from lenders",
//               trace: stackTrace);
//           err.reportError();
//         }

//         if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
//                 state.offersFetchTime >
//             900) {
//           state = state.copyWith(
//               offers: formattedOffers,
//               offersFetchTime: DateTime.now().millisecondsSinceEpoch ~/ 1000);
//         } else {
//           state = state.copyWith(
//             offers: formattedOffers,
//           );
//         }
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/fetch-offers",
//           message: "Error occured when fetching offers from lenders",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when fetching offers from lenders! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // Submit offer change form (Fetch updated form right after)

//   Future<ServerResponse> performSelect2(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/perform-select-02", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/perform-select-02",
//           message: "Error occured when performing select 02 form",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when performing select 02 form! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> performNextActionsAfterOfferSelection(
//       CancelToken cancelToken) async {
//     try {
//       var (authToken, _) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       var httpService = HttpService();

//       var transactionId = state.transactionId;
//       var providerId = state.selectedOffer.offerProviderId;

//       if (transactionId.isEmpty || providerId.isEmpty) {
//         return ServerResponse(
//             success: false,
//             message:
//                 "Transaction ID or Provider ID empty. Restart the process!",
//             data: null);
//       }

//       var response = await httpService.post(
//           "/ondc/perform-next-steps-after-offer-selection",
//           authToken,
//           cancelToken, {
//         "transaction_id": transactionId,
//         "provider_id": providerId,
//       });

//       if (response.data['success']) {
//         bool navigateToAadharKYC =
//             response.data['data']?['navigateToAadharKYC'] ?? false;
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "navigateToAadharKYC": navigateToAadharKYC,
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/perform-next-steps-after-offer-selection",
//           message:
//               "Error occured when checking which action to perform next after offer selection",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking which action to perform next after offer selection! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> submitLoanOfferChangeForm(
//       String requestedAmount, CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       print("Requested Amount: $requestedAmount");
//       print("Selected Offer Deposit: ${state.selectedOffer.deposit}");

//       if (int.parse(requestedAmount) >
//           double.parse(state.selectedOffer.deposit)) {
//         return ServerResponse(
//             success: false,
//             message: "Requested amount cannot be greater than the loan amount",
//             data: null);
//       }

//       if (int.parse(requestedAmount) < 5000) {
//         requestedAmount = state.selectedOffer.deposit;
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/submit-form-02", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//         "requested_loan_amount": requestedAmount,
//       });

//       if (response.data['success']) {
//         state = state.copyWith(
//           loanOfferUpdated: true,
//         );
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/submit-form-02",
//           message: "Error occured when submitting loan amount change form",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when submitting loan amount change form! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> fetchUpdatedLoanOffer(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       if (state.offers.isEmpty) {
//         state = state.copyWith(fetchingOffers: true);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/fetch-updated-offer", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//         "offer_id": state.selectedOffer.offerId
//       });

//       state = state.copyWith(fetchingOffers: false);

//       if (response.data['success']) {
//         LoanDetails offerDetails =
//             LoanDetails.fromJson(response.data['data']?['offer_details']);

//         if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
//                 state.offersFetchTime >
//             900) {
//           state = state.copyWith(
//               selectedOffer: offerDetails,
//               offersFetchTime: DateTime.now().millisecondsSinceEpoch ~/ 1000);
//         } else {
//           state = state.copyWith(
//             offerSelected: true,
//             selectedOffer: offerDetails,
//           );
//         }
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/fetch-offers",
//           message: "Error occured when fetching updated offer from lenders",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when fetching updated offer from lenders! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> fetchAadharKYCURL(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state = state.copyWith(fetchingAadharKYCURl: true);

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/fetch-form-03", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       state = state.copyWith(fetchingAadharKYCURl: false);

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "url": response.data['data']['url'],
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(fetchingAadharKYCURl: false);
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/fetch-form-03",
//           message: "Error occured when fetching KYC form",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when fetching KYC  form! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> checkAadharKYCSuccess(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService.post(
//           "/ondc/check-form-03-submission-success", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/check-form-03-submission-success",
//           message: "Error occured when checking KYC form success",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking KYC form success! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> refetchAadharKYCURL(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state =
//           state.copyWith(fetchingAadharKYCURl: true, aadharKYCFailure: false);

//       var httpService = HttpService();
//       var response = await httpService.post(
//           "/ondc/refetch-form-03-submission-url", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       if (response.data['success']) {
//         state = state.copyWith(
//             fetchingAadharKYCURl: false, aadharKYCFailure: false);
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         state =
//             state.copyWith(fetchingAadharKYCURl: false, aadharKYCFailure: true);
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/refetch-form-03-submission-url",
//           message: "Error occured when fetching KYC form",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when refetching KYC  form! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> verifyBankAccountDetails(
//       CancelToken cancelToken) async {
//     try {
//       if (state.bankType.isEmpty ||
//           state.bankAccountNumber.isEmpty ||
//           state.bankIFSC.isEmpty) {
//         return ServerResponse(
//             success: false, message: "Please fill all the details", data: null);
//       }

//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/validate-bank-details", authToken, cancelToken, {
//         "account_number": state.bankAccountNumber,
//         "ifsc_code": state.bankIFSC,
//       });

//       if (!response.data['success']) {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }

//       var nameAtBank = response.data['data']['name_at_bank'];

//       response = await httpService
//           .post("/ondc/submit-form-04", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//         "account_holder_name": nameAtBank,
//         "bank_account_number": state.bankAccountNumber,
//         "ifsc_code": state.bankIFSC,
//         "bank_account_type": state.bankType,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/validate-bank-details",
//           message: "Error occured when submitting bank details to the lender",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when submitting bank details to the lender! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> fetchRepaymentURL(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state = state.copyWith(fetchingAadharKYCURl: true);

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/fetch-form-05-url", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       state = state.copyWith(fetchingAadharKYCURl: false);

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "url": response.data['data']['url'],
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/fetch-form-05-url",
//           message: "Error occured when fetching Repayment Setup form",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when fetching Repayment Setup form! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> checkRepaymentSuccess(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var httpService = HttpService();

//       var response = await httpService.post(
//           "/ondc/check-form-05-submission-success", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/check-form-05-submission-success",
//           message: "Error occured when checking Repayment Setup form success",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking Repayment Setup form success! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> refetchRepaymentSetupURL(
//       CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state =
//           state.copyWith(fetchingAadharKYCURl: true, aadharKYCFailure: false);

//       var httpService = HttpService();
//       var response = await httpService.post(
//           "/ondc/refetch-form-05-submission-url", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       if (response.data['success']) {
//         state = state.copyWith(repaymentSetupFailure: false);
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         state = state.copyWith(repaymentSetupFailure: false);
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/refetch-form-05-submission-url",
//           message: "Error occured when fetching Repayment Setup form",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when refetching Repayment Setup form! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> fetchLoanAgreementURL(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state = state.copyWith(fetchingLoanAgreementForm: true);

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/fetch-form-06", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       state = state.copyWith(fetchingLoanAgreementForm: false);

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "url": response.data['data']['url'],
//               "redirect_form": (response.data['data']['mimeType'] ?? "") ==
//                   "application/html",
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/fetch-form-06",
//           message: "Error occured when fetching Loan Agreement Setup form",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when fetching Loan Agreement Setup form! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> checkLoanAgreementSuccess(
//       CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state = state.copyWith(verifyingLoanAgreementSuccess: true);

//       var httpService = HttpService();

//       var response = await httpService.post(
//           "/ondc/check-form-06-submission-success", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       state = state.copyWith(verifyingLoanAgreementSuccess: false);

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/check-form-06-submission-success",
//           message: "Error occured when checking Loan Agreement form success",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking Loan Agreement form success! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> submitLoanAgreementAndCheckSuccess(
//       String otp, CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state = state.copyWith(verifyingLoanAgreementSuccess: true);

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/submit-form-06", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//         "otp": otp,
//       });

//       if (!response.data['success']) {
//         state = state.copyWith(verifyingLoanAgreementSuccess: false);
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }

//       bool success = false;
//       int tries = 0;

//       while (!success && tries < 5) {
//         var checkSubmissionSuccessResponse =
//             await checkLoanAgreementSuccess(cancelToken);

//         if (checkSubmissionSuccessResponse.success) {
//           success = true;
//         } else {
//           tries++;
//           await Future.delayed(const Duration(seconds: 10));
//         }
//       }

//       state = state.copyWith(verifyingLoanAgreementSuccess: false);

//       if (!success) {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }

//       return ServerResponse(
//           success: true, message: response.data['message'], data: null);
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/submit-loan-agreement-and-check-success",
//           message: "Error occured when fetching Repayment Setup form",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when submitting loan agreement form and checking success! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> refetchLoanAgreementURL(
//       CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state =
//           state.copyWith(fetchingAadharKYCURl: true, aadharKYCFailure: false);

//       var httpService = HttpService();
//       var response = await httpService.post(
//           "/ondc/refetch-form-06-submission-url", authToken, cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       if (response.data['success']) {
//         state = state.copyWith(
//             fetchingLoanAgreementForm: false, loanAgreementFailure: false);
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         state =
//             state.copyWith(fetchingAadharKYCURl: false, aadharKYCFailure: true);
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(
//           fetchingLoanAgreementForm: false, loanAgreementFailure: true);
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/refetch-form-06-submission-url",
//           message: "Error occured when fetching Loan Agreement form",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when refetching Loan Agreement form! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   /* Confirm */
//   Future<ServerResponse> checkMonitoringConsentRequirement(
//       CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService.post(
//           "/ondc/check-monitoring-consent-requirement",
//           authToken,
//           cancelToken, {
//         "transaction_id": state.selectedOffer.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "monitoring_consent_required": response.data['data']
//                       ?['monitoring_consent_required'] ??
//                   false,
//               "loan_sanctioned":
//                   response.data['data']?['loan_sanctioned'] ?? false,
//               "loan_sanctioned_error":
//                   response.data['data']?['loan_sanctioned_error'] ?? "",
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/check-monitoring-consent-requirement",
//           message:
//               "Error occured when checking if monitoring consent is required",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking if monitoring consent is required! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> fetchLoanMonitoringAAURL(
//       CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var transactionId = state.transactionId;
//       var providerId = state.selectedOffer.offerProviderId;
//       var aaId = state.selectedAA.aaId;
//       var aaURL = state.selectedAA.url;

//       if (transactionId.isEmpty ||
//           aaId.isEmpty ||
//           aaURL.isEmpty ||
//           providerId.isEmpty) {
//         return ServerResponse(
//             success: false,
//             message:
//                 "Transaction Id, Provider Id or Account Aggregator Id not set. Restart the Journey or Contact Support!",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService.post(
//           "/ondc/generate-loan-monitoring-consent-url",
//           authToken,
//           cancelToken, {
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//         "aa_id": aaId,
//         "aa_url": aaURL,
//         "aa_name": state.selectedAA.key,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "url": response.data['data']?['aa_url'] ?? "",
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/generate-loan-monitoring-consent-url",
//           message: "Error occured when generating monitoring consent url",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when generating monitoring consent url! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> checkLoanMonitoringConsentSuccess(
//       String ecres, String resdate, CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/check-loan-monitoring-success", authToken, cancelToken, {
//         "ecres": ecres,
//         "resdate": resdate,
//         "transaction_id": state.transactionId,
//         "provider_id": state.selectedOffer.offerProviderId,
//         "aa_name": state.selectedAA.key
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/check-loan-monitoring-success",
//           message:
//               "Error occured when checking loan monitoring consent success",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking loan monitoring consent success! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }
// }
