// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state_data.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_countdown_timer/index.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

// class SubmittingSearchForm extends ConsumerStatefulWidget {
//   const SubmittingSearchForm({super.key});

//   @override
//   ConsumerState<SubmittingSearchForm> createState() =>
//       _NewLoanSubmittingInvoicesForOffersScreenState();
// }

// class _NewLoanSubmittingInvoicesForOffersScreenState
//     extends ConsumerState<SubmittingSearchForm> {
//   late CountdownTimerController controller;
//   int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 600;
//   final submitInvoiceCancelToken = CancelToken();
//   final fetchOfferCancelToken = CancelToken();

//   void onCountdownEnd() {
//     final snackBar = SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.transparent,
//       content: AwesomeSnackbarContent(
//         title: 'On Snap!',
//         message: "Unable to fetch offers on invoices. Please contact support.",
//         contentType: ContentType.failure,
//       ),
//       duration: const Duration(seconds: 10),
//     );

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);
//   }

//   void performActions() async {
//     if (ref.read(newLoanStateProvider).submittingInvoicesForOffers) {
//       return;
//     }

//     ref
//         .read(newLoanStateProvider.notifier)
//         .setSubmittingInvoicesForOffers(true);

//     // Submit the forms
//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .submitForms(submitInvoiceCancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       ref
//           .read(newLoanStateProvider.notifier)
//           .setSubmittingInvoicesForOffers(false);

//       controller.disposeTimer();

//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'On Snap!',
//           message:
//               "Unable to submit invoice details to lenders. Please contact support",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 10),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       await Future.delayed(const Duration(seconds: 10));

//       if (mounted) {
//         context.go(AppRoutes.msme_new_loan_process);
//       }

//       return;
//     }

//     var generateAccountAggregatorResponse = await ref
//         .read(newLoanStateProvider.notifier)
//         .generateAAURL(fetchOfferCancelToken);

//     ref
//         .read(newLoanStateProvider.notifier)
//         .setSubmittingInvoicesForOffers(false);

//     if (!mounted) return;

//     if (generateAccountAggregatorResponse.success) {
//       bool redirectionRequired =
//           generateAccountAggregatorResponse.data['redirect'] ?? false;
//       if (redirectionRequired) {
//         ref
//             .read(newLoanStateProvider.notifier)
//             .updateState(NewLoanProgress.bankConsent);
//         context.go(AppRoutes.msme_new_loan_process);
//         return;
//       } else {
//         context.go(AppRoutes.msme_new_loan_account_aggregator_webview,
//             extra: generateAccountAggregatorResponse.data['url']);
//         return;
//       }
//     } else {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//             title: 'Error!',
//             message:
//                 "Unable to generate Account Aggregator Consent URL. Contact Support!!",
//             contentType: ContentType.failure),
//         duration: const Duration(seconds: 5),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       context.go(AppRoutes.msme_new_loan_process);

//       return;
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       performActions();
//     });
//     controller =
//         CountdownTimerController(endTime: endTime, onEnd: onCountdownEnd);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _ = ref.watch(serverSentEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: Container(
//             padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset("assets/animations/filing_invoice_forms.json",
//                     height: 250, width: 250),
//                 const SpacerWidget(height: 35),
//                 Text(
//                   'We are submitting your invoices for offers. This may take a few minutes.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h2,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onSurface),
//                 ),
//                 const SpacerWidget(height: 20),
//                 Text(
//                   'Do not press back or close the app.',
//                   textAlign: TextAlign.center,
//                   softWrap: true,
//                   style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h2,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onSurface),
//                 ),
//                 const SpacerWidget(height: 20),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                   decoration: BoxDecoration(
//                     color:
//                         Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(5),
//                     border: Border.all(
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                   ),
//                   child: CountdownTimer(
//                     controller: controller,
//                     onEnd: onCountdownEnd,
//                     endTime: endTime,
//                     widgetBuilder: (_, CurrentRemainingTime? time) {
//                       String text =
//                           "min: ${time?.min ?? 0} - sec: ${time?.sec}";

//                       if (time == null) {
//                         text = "Time's up!";
//                       }

//                       return Text(
//                         text,
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h2,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
