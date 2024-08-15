// import 'package:blocsol_personal_credit/state/auth/auth_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/utils/loan/loan_details.dart';
// import 'package:blocsol_personal_credit/utils/errors.dart';
// import 'package:blocsol_personal_credit/utils/http_service.dart';
// import 'package:blocsol_personal_credit/utils/schema.dart';
// import 'package:dio/dio.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'old_loans_state.g.dart';
// part 'old_loans_state.freezed.dart';

// @freezed
// class OldLoanStateData with _$OldLoanStateData {
//   const factory OldLoanStateData({
//     required List<LoanDetails> oldLoans,
//     required LoanDetails selectedOldOffer,
//     required bool fetchingOldOffers,
//     required int oldOffersFetchTime,
//     // Actions
//     required bool loanForeclosureFailed,
//     required bool initiatingForeclosure,
//     required bool prepaymentFailed,
//     required bool initiatingPrepayment,
//     required String prepaymentId,
//     required bool missedEmiPaymentFailed,
//     required bool initiatingMissedEmiPayment,
//     required String missedEmiPaymentId,
//   }) = _OldLoanStateData;
// }

// @riverpod
// class OldLoanDetailsState extends _$OldLoanDetailsState {
//   @override
//   OldLoanStateData build() {
//     ref.keepAlive();
//     return OldLoanStateData(
//         oldLoans: [],
//         selectedOldOffer: LoanDetails.newOffer(),
//         fetchingOldOffers: false,
//         oldOffersFetchTime: 0,
//         initiatingForeclosure: false,
//         initiatingPrepayment: false,
//         prepaymentId: "",
//         initiatingMissedEmiPayment: false,
//         missedEmiPaymentId: "",
//         missedEmiPaymentFailed: false,
//         loanForeclosureFailed: false,
//         prepaymentFailed: false);
//   }

//   void updateSelectedOffer(LoanDetails offer) {
//     state = state.copyWith(selectedOldOffer: offer);
//   }

//   void updateMissedEmiPaymentId(String id) {
//     state = state.copyWith(missedEmiPaymentId: id);
//   }

//   void reset() {
//     state = OldLoanStateData(
//         oldLoans: [],
//         selectedOldOffer: LoanDetails.newOffer(),
//         fetchingOldOffers: false,
//         oldOffersFetchTime: 0,
//         initiatingForeclosure: false,
//         initiatingPrepayment: false,
//         prepaymentId: "",
//         initiatingMissedEmiPayment: false,
//         missedEmiPaymentId: "",
//         missedEmiPaymentFailed: false,
//         loanForeclosureFailed: false,
//         prepaymentFailed: false);
//   }

//   // Fetch Old Loans
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

//       if (state.oldLoans.isEmpty) {
//         state = state.copyWith(fetchingOldOffers: true);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .get("/ondc/fetch-all-confirmed-orders", authToken, cancelToken, {});

//       // Updating the fetch time in order to show no offers fetched message on frontend if no offers or error
//       state = state.copyWith(
//           fetchingOldOffers: false,
//           oldOffersFetchTime: DateTime.now().millisecondsSinceEpoch ~/ 1000);

//       if (response.data['success']) {
//         List<LoanDetails> formattedOffers = [];

//         try {
//           List<dynamic> offers = response.data['data']?['offers'] ?? [];

//           formattedOffers =
//               offers.map((item) => LoanDetails.fromJson(item)).toList();

//           state = state.copyWith(
//             oldLoans: formattedOffers,
//           );
//         } catch (e, stackTrace) {
//           print(
//               "Error occured when fetching old loans from lenders, error is: $e");
//           var err = ErrorInstance(
//               exception: e,
//               path: "/ondc/fetch-all-confirmed-orders",
//               message: "Error occured when fetching old loans from lenders",
//               trace: stackTrace);
//           err.reportError();
//         }

//         if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
//                 state.oldOffersFetchTime >
//             900) {
//           state = state.copyWith(
//               oldLoans: formattedOffers,
//               oldOffersFetchTime:
//                   DateTime.now().millisecondsSinceEpoch ~/ 1000);
//         } else {
//           state = state.copyWith(
//             oldLoans: formattedOffers,
//           );
//         }
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(fetchingOldOffers: false);
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/fetch-offers",
//           message: "Error occured when fetching old loans from lenders",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when fetching old loans from lenders! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> refetchSelectedLoanOfferDetails(
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
//       var response = await httpService
//           .post("/ondc/fetch-single-confirmed-order", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//       });

//       if (response.data['success']) {
//         LoanDetails formattedOffer =
//             LoanDetails.fromJson(response.data['data']?['details']);

//         state = state.copyWith(
//           selectedOldOffer: formattedOffer,
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
//           path: "/ondc/fetch-single-confirmed-order",
//           message:
//               "Error occured when refetching old loan details from lenders",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when refetching old loan details from lenders! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // Perform Status Request
//   Future<ServerResponse> performStatusRequest(CancelToken cancelToken) async {
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
//           .post("/ondc/perform-status-check", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
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
//           path: "/ondc/perform-status-check",
//           message:
//               "Error occured when performing status check for old loan from lenders",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when performing status check for the old loan! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   //Loan Foreclosure
//   Future<ServerResponse> initiateForeclosure(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state = state.copyWith(initiatingForeclosure: true);

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/initiate-foreclosure", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//       });

//       if (!response.data['success']) {
//         state = state.copyWith(initiatingForeclosure: false);
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }

//       response = await httpService
//           .post("/ondc/fetch-foreclosure-url", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//       });

//       state = state.copyWith(initiatingForeclosure: false);

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "url": response.data['data']['foreclose_url'],
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/initiating-foreclosure-and-fetching-url",
//           message: "Error occured when initiating foreclosure and fetching URL",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when initiating foreclosure and fetching URL! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> checkForeclosureSuccess(
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

//       state = state.copyWith(loanForeclosureFailed: false);

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/check-foreclosure-success", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(loanForeclosureFailed: true);
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/check-foreclosure-success",
//           message: "Error occured when checking foreclosure success",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking foreclosure success! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // Prepayment
//   Future<ServerResponse> initiatePartPrepayment(
//       String amount, CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state = state.copyWith(initiatingPrepayment: true);

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/initiate-prepayment", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//         "amount": amount,
//       });

//       if (!response.data['success']) {
//         state = state.copyWith(initiatingPrepayment: false);
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }

//       response = await httpService
//           .post("/ondc/fetch-prepayment-url", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//       });

//       state = state.copyWith(initiatingPrepayment: false);

//       if (response.data['success']) {
//         state = state.copyWith(
//             prepaymentId: response.data['data']['pre_payment_id']);
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "url": response.data['data']['pre_payment_url'],
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(initiatingPrepayment: false);
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/initiating-prepayment-and-fetching-url",
//           message: "Error occured when initiating prepayment and fetching URL",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when initiating prepayment and fetching URL! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> checkPrepaymentSuccess(CancelToken cancelToken) async {
//     try {
//       var (authToken, err) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       if (err != null) {
//         return ServerResponse(
//             success: false,
//             message: "Automatically Logged Out. Login again!!",
//             data: null);
//       }

//       state = state.copyWith(prepaymentFailed: false);

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/check-prepayment-success", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//         "prepayment_id": state.prepaymentId,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(prepaymentFailed: true);
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/check-prepayment-success",
//           message: "Error occured when checking prepayment success",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking prepayment success! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // Missed EMI Payment
//   Future<ServerResponse> initiateMissedEMIPayment(
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

//       state = state.copyWith(initiatingMissedEmiPayment: true);

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/ondc/initiate-missed-emi-repayment", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//       });

//       if (!response.data['success']) {
//         state = state.copyWith(initiatingMissedEmiPayment: false);
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }

//       response = await httpService.post(
//           "/ondc/fetch-missed-emi-repayment-url", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//         "payment_id": state.missedEmiPaymentId,
//       });

//       state = state.copyWith(initiatingMissedEmiPayment: false);

//       if (response.data['success']) {
//         state = state.copyWith(
//             missedEmiPaymentId: response.data['data']['missed_emi_id']);
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {
//               "url": response.data['data']['missed_emi_url'],
//             });
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/initiating-missed-emi-and-fetching-url",
//           message:
//               "Error occured when initiating missed emi repayment and fetching URL",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when initiating missed emi repayment and fetching URL! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   Future<ServerResponse> checkMissedEMIRepaymentSuccess(
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
//       state = state.copyWith(missedEmiPaymentFailed: false);
//       var httpService = HttpService();
//       var response = await httpService.post(
//           "/ondc/check-missed-emi-repayment-success", authToken, cancelToken, {
//         "transaction_id": state.selectedOldOffer.transactionId,
//         "provider_id": state.selectedOldOffer.offerProviderId,
//         "payment_id": state.missedEmiPaymentId,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(missedEmiPaymentFailed: true);
//       var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/check-missed-emi-repayment-success",
//           message: "Error occured when checking missed emi payment success",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occured when checking missed emi payment success! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }
// }
