// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class NewLoanErrorScreen extends ConsumerStatefulWidget {
//   final String errorMessage;
//   const NewLoanErrorScreen({super.key, required this.errorMessage});

//   @override
//   ConsumerState<NewLoanErrorScreen> createState() => _NewLoanErrorScreenState();
// }

// class _NewLoanErrorScreenState extends ConsumerState<NewLoanErrorScreen> {
//   @override
//   Widget build(BuildContext context) {
//     ref.watch(loanEventStateProvider);
//     ref.watch(serverSentEventStateProvider);
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             const SizedBox(height: 120),
//             Lottie.asset("assets/animations/error.json",
//                 height: 200, width: 200),
//             const SizedBox(height: 35),
//             Text(
//               widget.errorMessage,
//               softWrap: true,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: fontFamily,
//                 fontSize: AppFontSizes.h2,
//                 fontWeight: AppFontWeights.bold,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             GestureDetector(
//               onTap: () {
//                 HapticFeedback.mediumImpact();
//                 context.go(AppRoutes.msme_new_loan_process);
//               },
//               child: Container(
//                 height: 30,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primary,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Contact Support",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h3,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onPrimary,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             GestureDetector(
//               onTap: () {
//                 HapticFeedback.mediumImpact();
//                 context.go(AppRoutes.msme_home_screen);
//               },
//               child: Container(
//                 height: 30,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primary,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Go Back",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h3,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onPrimary,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
// }
