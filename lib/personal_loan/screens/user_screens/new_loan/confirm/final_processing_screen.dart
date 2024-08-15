// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/new_loan/new_loan_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import 'package:lottie/lottie.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class PCNewLoanFinalProcessing extends ConsumerStatefulWidget {
//   const PCNewLoanFinalProcessing({super.key});

//   @override
//   ConsumerState<PCNewLoanFinalProcessing> createState() =>
//       _PCNewLoanFinalProcessingState();
// }

// class _PCNewLoanFinalProcessingState
//     extends ConsumerState<PCNewLoanFinalProcessing> {
//   final _cancelToken = CancelToken();

//   void _performFinalConfirmation() async {
//     bool monitoringConsentRequired = false;
//     bool loanSanctioned = false;

//     var confirmationSuccessResponse = await ref
//         .read(newLoanStateProvider.notifier)
//         .checkMonitoringConsentRequirement(_cancelToken);

//     if (!mounted) return;

//     if (confirmationSuccessResponse.success) {
//       monitoringConsentRequired =
//           confirmationSuccessResponse.data?['monitoring_consent_required'] ??
//               false;
//       loanSanctioned =
//           confirmationSuccessResponse.data?['loan_sanctioned'] ?? false;

//       if (!monitoringConsentRequired) {
//         if (loanSanctioned) {
//           ref
//               .read(newLoanStateProvider.notifier)
//               .updateState(NewLoanProgress.monitoringConsent);
//           context.go(AppRoutes.pc_new_loan_process);
//         } else {
//           final snackBar = SnackBar(
//             duration: const Duration(seconds: 120),
//             elevation: 0,
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: Colors.transparent,
//             content: AwesomeSnackbarContent(
//               title: 'Error!',
//               message: (confirmationSuccessResponse
//                           .data['loan_sanctioned_error'] as String)
//                       .isEmpty
//                   ? confirmationSuccessResponse.data['loan_sanctioned_error']
//                   : "Loan not sanctioned by the lender. Try again or contact support",
//               contentType: ContentType.failure,
//             ),
//           );

//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(snackBar);
//           return;
//         }
//       }

//       var response = await ref
//           .read(newLoanStateProvider.notifier)
//           .fetchLoanMonitoringAAURL(_cancelToken);

//       if (!mounted) return;

//       if (response.success) {
//         context.go(AppRoutes.pc_new_loan_loan_monitoring_webview,
//             extra: response.data['url']);
//         return;
//       } else {
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: 'Error!',
//             message: response.message,
//             contentType: ContentType.failure,
//           ),
//         );

//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(snackBar);
//         return;
//       }
//     } else {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message:
//               "Unable to fetch loan monitoring consent url. Please try again later.",
//           contentType: ContentType.failure,
//         ),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       context.go(AppRoutes.pc_new_loan_process);
//       return;
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _performFinalConfirmation();
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _cancelToken.cancel();
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
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.all(30),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Lottie.asset(
//                   "assets/animations/processing_form.json",
//                   height: 250,
//                   width: 250,
//                 ),
//                 const SizedBox(height: 50),
//                 GestureDetector(
//                   onTap: () {
//                     context.go(AppRoutes.pc_new_loan_process);
//                   },
//                   child: Text(
//                     "Processing Loan with Lender...",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h2,
//                       fontWeight: AppFontWeights.bold,
//                       letterSpacing: 0.4,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     softWrap: true,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Please do not press back or exit",
//                   style: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.medium,
//                     letterSpacing: 0.4,
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onBackground
//                         .withOpacity(0.6),
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
