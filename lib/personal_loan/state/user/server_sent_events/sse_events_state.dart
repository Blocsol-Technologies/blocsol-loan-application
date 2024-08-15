// import 'package:blocsol_personal_credit/state/auth/auth_state.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/new_loan/new_loan_state.dart';
// import 'package:blocsol_personal_credit/utils/errors.dart';
// import 'package:blocsol_personal_credit/utils/http_service.dart';
// import 'package:dio/dio.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:eventflux/eventflux.dart';
// import 'dart:convert';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'sse_events_state.freezed.dart';
// part 'sse_events_state.g.dart';

// @freezed
// class ServerEventsStateData with _$ServerEventsStateData {
//   const factory ServerEventsStateData({
//     required bool update,
//   }) = _ServerEventsStateData;
// }

// @riverpod
// class ServerSentEventState extends _$ServerSentEventState {
//   @override
//   ServerEventsStateData build() {
//     ref.keepAlive();

//     var (token, _) = ref.read(authStateProvider.notifier).getAuthTokenSync();

//     EventFlux.instance.connect(
//       EventFluxConnectionType.get,
//       '$serverUrl/financial-services/personal-credit/ondc/events',
//       header: {"Authorization": token, "Keep-Alive": "true"},
//       onSuccessCallback: (EventFluxResponse? response) {
//         response?.stream?.listen((data) async {
//           var serverSentData = data.data;

//           Map<String, dynamic> jsonData = json.decode(serverSentData);

//           String context = jsonData['Context'] ?? "";
//           num stepNumber = jsonData['StepNumber'] ?? 0;
//           bool success = jsonData['Success'] ?? false;
//           String message = jsonData['Message'] ?? "";

//           print(
//               "message received from server sent event. $message. current state is ${ref.read(newLoanStateProvider).currentState} success is: ${success}");

//           switch (context) {
//             // Customer will reperform the select request again and again to refetch the offer details change form
//             case "select":
//               // on_select_01. Cant have on_select_01 and on_select_02 because these are multi lender submissions
//               // if (stepNumber == 1) {
//               //   if (success) {
//               //     ref
//               //         .read(newLoanStateProvider.notifier)
//               //         .updateState(NewLoanProgress.formGenerated);
//               //     ref
//               //         .read(routerStateProvider)
//               //         .go(AppRoutes.pc_new_loan_process);
//               //     return;
//               //   } else {
//               //     ref.read(routerStateProvider).go(AppRoutes.pc_new_loan_error,
//               //         extra: "Unable to select the offer from the lender");
//               //     return;
//               //   }
//               // }

//               // on_select_02
//               // if (stepNumber == 2) {
//               //   if (success) {
//               //     ref
//               //         .read(routerStateProvider)
//               //         .go(AppRoutes.pc_new_loan_update_offer_screen);
//               //   } else {
//               //     ref.read(routerStateProvider).go(AppRoutes.pc_new_loan_error,
//               //         extra: "Error when fetching the loan update form");

//               //     return;
//               //   }
//               // }

//               // on_select_03
//               if (stepNumber == 3) {
//                 if (success) {
//                   if (ref.read(newLoanStateProvider).aadharKYCFailure) {
//                     ref
//                         .read(newLoanStateProvider.notifier)
//                         .updateState(NewLoanProgress.loanOfferSelect);
//                     ref
//                         .read(newLoanStateProvider.notifier)
//                         .setAadharKYCFailure(false);

//                     ref
//                         .read(routerStateProvider)
//                         .go(AppRoutes.pc_new_loan_process);
//                     return;
//                   }

//                   return;
//                 } else {
//                   ref.read(routerStateProvider).go(AppRoutes.pc_new_loan_error,
//                       extra:
//                           "Unable to refetch the updated loan offer from the lender. OnInit03 failed");
//                   return;
//                 }
//               }

//               if (stepNumber == 4) {
//                 if (success) {
//                   final cancelToken = CancelToken();
//                   var response = await ref
//                       .read(newLoanStateProvider.notifier)
//                       .checkAadharKYCSuccess(cancelToken);

//                   if (!response.success) {
//                     ref.read(routerStateProvider).go(
//                         AppRoutes.pc_new_loan_error,
//                         extra:
//                             "Error when checking aadhar kyc success ${response.message}");
//                     return;
//                   }
//                   return;
//                 } else {
//                   ref
//                       .read(newLoanStateProvider.notifier)
//                       .setAadharKYCFailure(true);
//                   return;
//                 }
//               }

//               break;
//             case "init":
//               // on_init_01 response
//               if (stepNumber == 1) {
//                 if (success) {
//                   ref
//                       .read(newLoanStateProvider.notifier)
//                       .updateState(NewLoanProgress.aadharKYC);
//                   ref
//                       .read(routerStateProvider)
//                       .go(AppRoutes.pc_new_loan_process);
//                   return;
//                 } else {
//                   ref.read(routerStateProvider).go(AppRoutes.pc_new_loan_error,
//                       extra: "Error on the on_init_01");
//                   return;
//                 }
//               }

//               if (stepNumber == 2) {
//                 if (success) {
//                   ref
//                       .read(newLoanStateProvider.notifier)
//                       .updateState(NewLoanProgress.bankAccountDetails);
//                   ref
//                       .read(routerStateProvider)
//                       .go(AppRoutes.pc_new_loan_process);
//                   return;
//                 } else {
//                   ref.read(routerStateProvider).go(AppRoutes.pc_new_loan_error,
//                       extra: "Error on the on_init_02");
//                   return;
//                 }
//               }

//               // repayment response
//               if (stepNumber == 3) {
//                 if (success) {
//                   final cancelToken = CancelToken();
//                   var response = await ref
//                       .read(newLoanStateProvider.notifier)
//                       .checkRepaymentSuccess(cancelToken);

//                   if (!response.success) {
//                     ref
//                         .read(newLoanStateProvider.notifier)
//                         .updateRepaymentSetupFailure(true);
//                     ref.read(routerStateProvider).go(
//                         AppRoutes.pc_new_loan_error,
//                         extra:
//                             "Error when checking loan repayment success ${response.message}");
//                     return;
//                   }
//                   ref
//                       .read(newLoanStateProvider.notifier)
//                       .updateRepaymentSetupFailure(false);
//                   return;
//                 } else {
//                   ref
//                       .read(newLoanStateProvider.notifier)
//                       .updateRepaymentSetupFailure(true);
//                   ref.read(routerStateProvider).go(AppRoutes.pc_new_loan_error,
//                       extra:
//                           "Error on the checking loan repayment status check");
//                   return;
//                 }
//               }

//               // on_init_03 response
//               if (stepNumber == 4) {
//                 if (success) {
//                   ref
//                       .read(newLoanStateProvider.notifier)
//                       .updateState(NewLoanProgress.repaymentSetup);
//                   ref
//                       .read(routerStateProvider)
//                       .go(AppRoutes.pc_new_loan_process);
//                   return;
//                 } else {
//                   ref.read(routerStateProvider).go(AppRoutes.pc_new_loan_error,
//                       extra: "Error on the on_init_03");
//                   return;
//                 }
//               }

//               // loan agreement
//               if (stepNumber == 5) {
//                 if (success) {
//                   final cancelToken = CancelToken();
//                   var response = await ref
//                       .read(newLoanStateProvider.notifier)
//                       .checkLoanAgreementSuccess(cancelToken);

//                   if (!response.success) {
//                     ref
//                         .read(newLoanStateProvider.notifier)
//                         .updateLoanAgreementFailure(true);
//                     return;
//                   }
//                   ref
//                       .read(newLoanStateProvider.notifier)
//                       .updateLoanAgreementFailure(false);
//                   return;
//                 } else {
//                   ref
//                       .read(newLoanStateProvider.notifier)
//                       .updateLoanAgreementFailure(true);
//                   return;
//                 }
//               }

//               break;
//             case "confirm":
//               // on_confirm_01 response
//               if (stepNumber == 1) {
//                 if (success) {
//                   ref
//                       .read(newLoanStateProvider.notifier)
//                       .updateState(NewLoanProgress.loanAgreement);
//                   ref
//                       .read(routerStateProvider)
//                       .go(AppRoutes.pc_new_loan_process);
//                   return;
//                 } else {
//                   ref.read(routerStateProvider).go(AppRoutes.pc_new_loan_error,
//                       extra: "Error on the on_confirm_01");
//                   return;
//                 }
//               }
//               break;
//             default:
//               print("No context found");
//               break;
//           }
//         });
//       },
//       onError: (e) async {
//         var err = ErrorInstance(
//           exception: e,
//           path: "/ondc/general-search",
//           message: "Error occured when performing search for lenders",
//         );

//         await err.reportError();
//       },
//       autoReconnect: true,
//     );

//     // void disConnect() async {
//     //   await EventFlux.instance.disconnect();
//     // }

//     // ref.onDispose(disConnect);

//     return const ServerEventsStateData(
//       update: false,
//     );
//   }
// }
