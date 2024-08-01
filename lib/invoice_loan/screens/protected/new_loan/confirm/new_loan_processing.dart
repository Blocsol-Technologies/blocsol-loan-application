// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state_data.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LoanProcessing extends ConsumerStatefulWidget {
//   const LoanProcessing({super.key});

//   @override
//   ConsumerState<LoanProcessing> createState() => _LoanProcessingState();
// }

// class _LoanProcessingState extends ConsumerState<LoanProcessing> {
//   final _cancelToken = CancelToken();

//   void _performFinalConfirmation() async {
//     bool monitoringConsentRequired = false;
//     bool loanSanctioned = false;

//     var confirmationSuccessResponse = await ref
//         .read(newLoanStateProvider.notifier)
//         .checkMonitoringConsentRequirement(_cancelToken);

//     if (confirmationSuccessResponse.success) {
//       monitoringConsentRequired =
//           confirmationSuccessResponse.data?['monitoring_consent_required'] ??
//               false;
//       loanSanctioned =
//           confirmationSuccessResponse.data?['loan_sanctioned'] ?? false;
//       if (!monitoringConsentRequired) {
//         if (mounted) {
//           if (loanSanctioned) {
//             ref
//                 .read(newLoanStateProvider.notifier)
//                 .updateState(NewLoanProgress.monitoringConsent);
//             context.go(AppRoutes.msme_new_loan_process);
//             return;
//           } else {
//             final snackBar = SnackBar(
//               duration: const Duration(seconds: 120),
//               elevation: 0,
//               behavior: SnackBarBehavior.floating,
//               backgroundColor: Colors.transparent,
//               content: AwesomeSnackbarContent(
//                 title: 'Error!',
//                 message: (confirmationSuccessResponse
//                             .data['loan_sanctioned_error'] as String)
//                         .isEmpty
//                     ? confirmationSuccessResponse.data['loan_sanctioned_error']
//                     : "Loan not sanctioned by the lender. Try again or contact support",
//                 contentType: ContentType.failure,
//               ),
//             );

//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(snackBar);
//           }
//           return;
//         }
//       }

//       if (mounted) {
//         context
//             .go(AppRoutes.msme_new_loan_check_monitoring_consent_requirement);
//         return;
//       }
//     } else {
//       if (mounted) {
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: 'Error!',
//             message:
//                 "Unable to confirm the loan disbursement. Please try again later.",
//             contentType: ContentType.failure,
//           ),
//         );

//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(snackBar);
//         return;
//       }
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
//     ref.watch(loanEventStateProvider);
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
//                     context.go(AppRoutes.msme_new_loan_process);
//                   },
//                   child: Text(
//                     "Processing Loan with Lender...",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h1,
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
//                     fontSize: AppFontSizes.h3,
//                     fontWeight: AppFontWeights.medium,
//                     letterSpacing: 0.4,
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onSurface
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
