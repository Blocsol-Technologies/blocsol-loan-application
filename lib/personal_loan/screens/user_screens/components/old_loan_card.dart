// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/old_loans/old_loans_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/utils/loan/loan_details.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:blocsol_personal_credit/utils/bank_logo_picker.dart';
// import 'package:percent_indicator/percent_indicator.dart';

// class OldLoanCard extends ConsumerWidget {
//   final double screenHeight;
//   final double screenWidth;
//   final LoanDetails oldLoanDetails;
//   const OldLoanCard(
//       {super.key,
//       required this.screenHeight,
//       required this.screenWidth,
//       required this.oldLoanDetails});

//   void _handleOnPayNow(BuildContext context, WidgetRef ref) {
//     ref
//         .read(oldLoanDetailsStateProvider.notifier)
//         .updateSelectedOffer(oldLoanDetails);
//     context.go(AppRoutes.pc_old_loan_details_home);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: EdgeInsets.only(bottom: RelativeSize.height(20, screenHeight)),
//       height: RelativeSize.height(210, screenHeight),
//       width: screenWidth,
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               height: RelativeSize.height(200, screenHeight),
//               padding: EdgeInsets.symmetric(
//                 horizontal: RelativeSize.width(20, screenWidth),
//                 vertical: RelativeSize.height(15, screenHeight),
//               ),
//               width: RelativeSize.width(310, screenWidth),
//               decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.tertiary,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     width: 1,
//                     color: oldLoanDetails.isLoanClosed()
//                         ? Theme.of(context).colorScheme.primary
//                         : oldLoanDetails.isLoanDisbursed()
//                             ? Colors.blue.shade500
//                             : Colors.orange.shade500,
//                   )),
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Expanded(
//                         flex: 1,
//                         child: SizedBox(
//                           height: 80,
//                           width: 80,
//                           child: Center(
//                             child: CircularPercentIndicator(
//                               radius: 40,
//                               lineWidth: 8,
//                               animation: true,
//                               percent: 0.7,
//                               center: SizedBox(
//                                 height: 40,
//                                 width: 40,
//                                 child: getLenderDetailsAssetURL(
//                                     oldLoanDetails.bankName,
//                                     oldLoanDetails.bankLogoURL),
//                               ),
//                               circularStrokeCap: CircularStrokeCap.round,
//                               progressColor:
//                                   Theme.of(context).colorScheme.secondary,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         width: 15,
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               oldLoanDetails.bankName,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onTertiary,
//                               ),
//                             ),
//                             const SpacerWidget(
//                               height: 12,
//                             ),
//                             Text(
//                               "Loan Amount",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.normal,
//                                 color: Theme.of(context).colorScheme.onTertiary,
//                               ),
//                             ),
//                             Text(
//                               "₹ ${oldLoanDetails.deposit}",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onTertiary,
//                               ),
//                             ),
//                             const SpacerWidget(
//                               height: 5,
//                             ),
//                             Text(
//                               oldLoanDetails.isLoanClosed()
//                                   ? "Closed"
//                                   : oldLoanDetails.isLoanDisbursed()
//                                       ? "Disbursed"
//                                       : "Sanctioned",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onTertiary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SpacerWidget(
//                     height: 15,
//                   ),
//                   Container(
//                     height: 1,
//                     width: screenWidth,
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onTertiary
//                         .withOpacity(0.3),
//                   ),
//                   const SpacerWidget(
//                     height: 10,
//                   ),
//                   Column(
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Text("Due Amount",
//                               style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body2,
//                                   fontWeight: AppFontWeights.normal,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onTertiary)),
//                           Text("₹ ${oldLoanDetails.getBalanceLeft()}",
//                               style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body2,
//                                   fontWeight: AppFontWeights.bold,
//                                   color:
//                                       Theme.of(context).colorScheme.primary)),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 5,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Text("Due Date",
//                               style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body2,
//                                   fontWeight: AppFontWeights.normal,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onTertiary)),
//                           Text(oldLoanDetails.getNextDueDate(),
//                               style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body2,
//                                   fontWeight: AppFontWeights.bold,
//                                   color:
//                                       Theme.of(context).colorScheme.primary)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     HapticFeedback.mediumImpact();
//                     _handleOnPayNow(context, ref);
//                   },
//                   child: Container(
//                     height: RelativeSize.height(25, screenHeight),
//                     width: RelativeSize.width(105, screenWidth),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4),
//                       color: Theme.of(context).colorScheme.surface,
//                     ),
//                     child: Center(
//                       child: Text(
//                         "Pay Now",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body2,
//                           fontWeight: AppFontWeights.medium,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
