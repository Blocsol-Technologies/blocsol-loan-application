// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import 'package:lottie/lottie.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class MonitoringConsentRequirementCheck extends ConsumerStatefulWidget {
//   const MonitoringConsentRequirementCheck({super.key});

//   @override
//   ConsumerState<MonitoringConsentRequirementCheck> createState() =>
//       _MonitoringConsentRequirementCheckState();
// }

// class _MonitoringConsentRequirementCheckState
//     extends ConsumerState<MonitoringConsentRequirementCheck> {
//   final _cancelToken = CancelToken();

//   void fetchMonitoringConsentHandler() async {
//     if (ref.read(newLoanStateProvider).generatingMonitoringConsent) return;

//     ref
//         .read(newLoanStateProvider.notifier)
//         .setGeneratingMonitoringConsent(true);
//     ref
//         .read(newLoanStateProvider.notifier)
//         .setGenerateMonitoringConsentErr(false);

//     bool success = false;
//     int numTries = 0;
//     String url = "";

//     while (!success || numTries < 5) {
//       var generateConsentResponse = await ref
//           .read(newLoanStateProvider.notifier)
//           .generateLoanMonitoringConsentRequest(_cancelToken);

//       if (generateConsentResponse.success) {
//         success = true;
//         url = generateConsentResponse.data['url'];
//         break;
//       }

//       await Future.delayed(const Duration(seconds: 10));

//       numTries++;
//     }

//     ref
//         .read(newLoanStateProvider.notifier)
//         .setGeneratingMonitoringConsent(false);

//     if (!success) {
//       ref
//           .read(newLoanStateProvider.notifier)
//           .setGenerateMonitoringConsentErr(true);
//     }

//     if (mounted) {
//       ref
//           .read(newLoanStateProvider.notifier)
//           .setGenerateMonitoringConsentErr(false);
//       context.go(AppRoutes.msme_new_loan_monitoring_consent_webview,
//           extra: url);
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       fetchMonitoringConsentHandler();
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
//     final newLoanStateRef = ref.watch(newLoanStateProvider);
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
//             child: newLoanStateRef.generateMonitoringConsentErr
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Lottie.asset(
//                         "assets/animations/error.json",
//                         height: 300,
//                         width: 300,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         "Error when generating monitoring consent. Contact Support...",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h1,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.4,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                         softWrap: true,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 40),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               context.go(AppRoutes.msme_new_loan_process);
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 12, horizontal: 20),
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Go Back",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h3,
//                                     fontWeight: AppFontWeights.medium,
//                                     letterSpacing: 0.4,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               fetchMonitoringConsentHandler();
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 12, horizontal: 20),
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Try Again",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h3,
//                                     fontWeight: AppFontWeights.medium,
//                                     letterSpacing: 0.4,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Lottie.asset(
//                         "assets/animations/submitting_details.json",
//                         height: 300,
//                         width: 300,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         "Generating Consent Details...",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h1,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.4,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                         softWrap: true,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 40),
//                       Text(
//                         "Please do not press back or exit",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.medium,
//                           letterSpacing: 0.4,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.6),
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
