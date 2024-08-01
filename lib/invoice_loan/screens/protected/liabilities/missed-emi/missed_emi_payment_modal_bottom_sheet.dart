// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/liabilities/liabilities_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class MissedEmiPaymentModalBottomSheet extends ConsumerStatefulWidget {
//   final String url;
//   const MissedEmiPaymentModalBottomSheet({super.key, required this.url});

//   @override
//   ConsumerState<MissedEmiPaymentModalBottomSheet> createState() =>
//       _MissedEmiPaymentModalBottomSheet();
// }

// class _MissedEmiPaymentModalBottomSheet
//     extends ConsumerState<MissedEmiPaymentModalBottomSheet> {
//   Future<void> _continue() async {
//     context.go(AppRoutes.msme_liability_missed_emi_webview, extra: widget.url);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final oldLoanStateRef = ref.watch(liabilitiesStateProvider);
//     final selectedLiability = oldLoanStateRef.selectedLiability;
//     return Container(
//       height: 260,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.fromLTRB(25, 25, 25, 40),
//       color: Theme.of(context).colorScheme.primary,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "Disclaimer!",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h1,
//               fontWeight: AppFontWeights.bold,
//               color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
//               letterSpacing: 0.14,
//             ),
//           ),
//           const SpacerWidget(
//             height: 15,
//           ),
//           const SpacerWidget(
//             height: 15,
//           ),
//           Text(
//             "When making missed EMI payment, you agree to pay Missed EMI Penalty charges which are ${selectedLiability..offerDetails.lateCharge}",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.body,
//               fontWeight: AppFontWeights.medium,
//               color: Theme.of(context).colorScheme.onPrimary,
//               letterSpacing: 0.14,
//             ),
//           ),
//           const SpacerWidget(
//             height: 30,
//           ),
//           SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 GestureDetector(
//                   onTap: () async {
//                     await _continue();
//                   },
//                   child: Container(
//                     height: 40,
//                     width: 120,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.onPrimary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "Make Payment",
//                         style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             color: Theme.of(context).colorScheme.primary),
//                       ),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     height: 40,
//                     width: 100,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.onPrimary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "Go Back",
//                         style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             color: Theme.of(context).colorScheme.primary),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const SpacerWidget(
//             height: 15,
//           ),
//         ],
//       ),
//     );
//   }
// }
