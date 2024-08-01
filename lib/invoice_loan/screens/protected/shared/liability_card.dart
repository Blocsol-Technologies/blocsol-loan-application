// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/liabilities/liabilities_state.dart';
// import 'package:blocsol_invoice_based_credit/state/utils/loan_details.dart';
// import 'package:blocsol_invoice_based_credit/utils/lender_utils.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:percent_indicator/percent_indicator.dart';

// class LiabilityCard extends ConsumerWidget {
//   final double screenHeight;
//   final double screenWidth;
//   final LoanDetails oldLoanDetails;
//   const LiabilityCard(
//       {super.key,
//       required this.screenHeight,
//       required this.screenWidth,
//       required this.oldLoanDetails});

//   void _handleOnPayNow(BuildContext context, WidgetRef ref) {
//     ref
//         .read(liabilitiesStateProvider.notifier)
//         .updateSelectedOffer(oldLoanDetails);
//     context.go(AppRoutes.msme_liability_details);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: EdgeInsets.only(bottom: RelativeSize.height(20, screenHeight)),
//       height: RelativeSize.height(190, screenHeight),
//       width: screenWidth,
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               height: RelativeSize.height(180, screenHeight),
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
//                     color: oldLoanDetails.offerDetails.isLoanClosed()
//                         ? Theme.of(context).colorScheme.primary
//                         : oldLoanDetails.offerDetails.isLoanDisbursed()
//                             ? Theme.of(context).colorScheme.secondary
//                             : Colors.purple.shade500,
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
//                               percent: oldLoanDetails.offerDetails
//                                   .getAmountPaidPercentage(),
//                               backgroundColor:
//                                   const Color.fromARGB(255, 183, 182, 229),
//                               center: SizedBox(
//                                 height: 40,
//                                 width: 40,
//                                 child: getLenderDetailsAssetURL(
//                                     oldLoanDetails.offerDetails.bankName,
//                                     oldLoanDetails.offerDetails.bankLogoURL),
//                               ),
//                               circularStrokeCap: CircularStrokeCap.round,
//                               progressColor:
//                                   const Color.fromRGBO(102, 51, 153, 1),
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
//                               oldLoanDetails.offerDetails.bankName,
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
//                               "₹ ${oldLoanDetails.offerDetails.deposit}",
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
//                               oldLoanDetails.offerDetails.isLoanClosed()
//                                   ? "Closed"
//                                   : oldLoanDetails.offerDetails
//                                           .isLoanDisbursed()
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
//                           Text(
//                               "₹ ${oldLoanDetails.offerDetails.getBalanceLeft()}",
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
//                           Text(oldLoanDetails.offerDetails.getNextDueDate(),
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
//                       color: Theme.of(context).colorScheme.primary,
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
