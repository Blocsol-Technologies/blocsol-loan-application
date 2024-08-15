// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/old_loans/old_loans_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class ForecloseLoanModalBottomSheet extends ConsumerStatefulWidget {
//   final String forecloseAmount;
//   const ForecloseLoanModalBottomSheet(
//       {super.key, required this.forecloseAmount});

//   @override
//   ConsumerState<ForecloseLoanModalBottomSheet> createState() =>
//       _ForecloseLoanModalBottomSheet();
// }

// class _ForecloseLoanModalBottomSheet
//     extends ConsumerState<ForecloseLoanModalBottomSheet> {
//   bool _errorOccured = false;
//   String _errorString = "";
//   final _cancelToken = CancelToken();

//   Future<void> _forecloseLoan() async {
//     if (ref.read(oldLoanDetailsStateProvider).initiatingForeclosure) {
//       return;
//     }

//     setState(() {
//       _errorOccured = false;
//       _errorString = "";
//     });

//     var response = await ref
//         .read(oldLoanDetailsStateProvider.notifier)
//         .initiateForeclosure(_cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       setState(() {
//         _errorOccured = true;
//         _errorString = response.message;
//       });

//       return;
//     }

//     context.go(AppRoutes.pc_old_loan_foreclose_webview,
//         extra: response.data['url']);
//   }

//   @override
//   void dispose() {
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final oldLoanStateRef = ref.watch(oldLoanDetailsStateProvider);
//     final selectedOffer = oldLoanStateRef.selectedOldOffer;
//     return Container(
//       height: 450,
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
//           Text(
//             "Amount: ${widget.forecloseAmount} INR!",
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
//           Text(
//             "What is foreclosure?",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h3,
//               fontWeight: AppFontWeights.normal,
//               color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
//               letterSpacing: 0.14,
//             ),
//           ),
//           const SpacerWidget(
//             height: 15,
//           ),
//           Text(
//             "Foreclosure Means that you want to repay the loan back in full and complete this loan journey. You also agree to pay any foreclosure penalty charges. Foreclosure penalty is ${selectedOffer.prepaymentPenalty}",
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
//                     await _forecloseLoan();
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
//                         "Foreclose",
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
//           _errorOccured
//               ? Text(
//                   _errorString,
//                   style: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.h3,
//                     fontWeight: AppFontWeights.normal,
//                     color: Theme.of(context).colorScheme.error,
//                   ),
//                 )
//               : oldLoanStateRef.initiatingForeclosure
//                   ? Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Lottie.asset('assets/animations/loading_spinner.json',
//                             height: 50, width: 50),
//                         const SpacerWidget(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: Text(
//                             "Sending Foreclosure Request. Do not press back or close the app",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.normal,
//                               color: Theme.of(context).colorScheme.onPrimary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : const SpacerWidget(),
//         ],
//       ),
//     );
//   }
// }
