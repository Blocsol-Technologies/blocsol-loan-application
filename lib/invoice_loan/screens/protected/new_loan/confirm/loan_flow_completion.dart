// import 'package:blocsol_invoice_based_credit/screens/user/protected/new_loan/components/continue_button.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class LoanFlowCompletion extends ConsumerStatefulWidget {
//   const LoanFlowCompletion({super.key});

//   @override
//   ConsumerState<LoanFlowCompletion> createState() => _LoanFlowCompletionState();
// }

// class _LoanFlowCompletionState extends ConsumerState<LoanFlowCompletion> {
//   void financeOtherInvoicesHandler() async {
//     ref.read(newLoanStateProvider.notifier).reset();
//     context.go(AppRoutes.msme_home_screen);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final newLoanStateRef = ref.watch(newLoanStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);
//     ref.watch(loanEventStateProvider);
//     final selectedInvoice = newLoanStateRef.selectedInvoice;
//     final selectedOffer = newLoanStateRef.selectedOffer;

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           backgroundColor: Theme.of(context).colorScheme.surface,
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Center(
//                     child: Lottie.asset(
//                       "assets/animations/money_growth_person.json",
//                       height: 200,
//                       width: 250,
//                     ),
//                   ),
//                 ),
//                 const SpacerWidget(height: 23),
//                 Text(
//                   "Loan Sanctioned",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontSize: AppFontSizes.h1,
//                     fontWeight: AppFontWeights.extraBold,
//                     fontFamily: fontFamily,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//                 const SpacerWidget(height: 23),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 75,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.2),
//                                 width: 1))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Status",
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.4),
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             Text(
//                               "SANCTIONED",
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.165,
//                               ),
//                             ),
//                             const SpacerWidget(
//                               height: 3,
//                             ),
//                             Text(
//                               "${selectedOffer.getLoanPercentOfTotalValue(selectedInvoice.amount)}% of order value",
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.4),
//                                 fontSize: AppFontSizes.body2,
//                                 fontWeight: AppFontWeights.normal,
//                                 fontFamily: fontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 75,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.2),
//                                 width: 1))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Lender",
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.4),
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             Text(
//                               selectedOffer.bankName,
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.165,
//                               ),
//                             ),
//                             const SpacerWidget(
//                               height: 3,
//                             ),
//                             Text(
//                               selectedOffer.bankName,
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.4),
//                                 fontSize: AppFontSizes.body2,
//                                 fontWeight: AppFontWeights.normal,
//                                 fontFamily: fontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 75,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.2),
//                                 width: 1))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Total Loan",
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.4),
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             Text(
//                               "₹ ${selectedOffer.netDisbursedAmount}",
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.165,
//                               ),
//                             ),
//                             const SpacerWidget(
//                               height: 3,
//                             ),
//                             Text(
//                               "${selectedOffer.getLoanPercentOfTotalValue(selectedInvoice.amount)}% of order value",
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.4),
//                                 fontSize: AppFontSizes.body2,
//                                 fontWeight: AppFontWeights.normal,
//                                 fontFamily: fontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 75,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.2),
//                                 width: 1))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Deposit Account",
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.4),
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             Text(
//                               newLoanStateRef.bankAccountNumber,
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.165,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 75,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.2),
//                                 width: 1))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Interest",
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.4),
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             Text(
//                               "₹ ${selectedOffer.interest}",
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.165,
//                               ),
//                             ),
//                             const SpacerWidget(
//                               height: 3,
//                             ),
//                             Text(
//                               "@${selectedOffer.interestRate}% p.a.",
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.4),
//                                 fontSize: AppFontSizes.body2,
//                                 fontWeight: AppFontWeights.normal,
//                                 fontFamily: fontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 75,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.2),
//                                 width: 1))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Total Repayment",
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.4),
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             Text(
//                               "₹ ${selectedOffer.totalRepayment}",
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.165,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 75,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.2),
//                                 width: 1))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Due Date",
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.4),
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             Text(
//                               selectedOffer.tenure,
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.165,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 75,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.2),
//                                 width: 1))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Loan Id",
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.4),
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             SizedBox(
//                               width: 150,
//                               child: Text(
//                                 newLoanStateRef.selectedOffer.offerId,
//                                 softWrap: true,
//                                 textAlign: TextAlign.end,
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.bold,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.165,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SpacerWidget(height: 40),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ContinueButton(
//                       onPressed: () {
//                         financeOtherInvoicesHandler();
//                       },
//                       text: "Finance other Invoices",
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
