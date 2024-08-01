// import 'dart:math';

// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state_data.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/lender_utils.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_countdown_timer/index.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';

// class SingleOfferDetails extends ConsumerStatefulWidget {
//   const SingleOfferDetails({super.key});

//   @override
//   ConsumerState<SingleOfferDetails> createState() => _SingleOfferDetailsState();
// }

// class _SingleOfferDetailsState extends ConsumerState<SingleOfferDetails> {
//   int _endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 900;

//   @override
//   void initState() {
//     int properEndtime = max(
//         900 -
//             (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
//                 ref.read(newLoanStateProvider).invoiceWithOffersFetchTime),
//         0);

//     setState(() {
//       _endTime = DateTime.now().millisecondsSinceEpoch + (properEndtime) * 1000;
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
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
//           bottomNavigationBar: const ScreenActions(),
//           body: SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(0, RelativeSize.height(20, height), 0,
//                 RelativeSize.height(50, height)),
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: RelativeSize.width(20, width)),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () async {
//                           HapticFeedback.mediumImpact();

//                           context.go(AppRoutes.msme_new_loan_offer_details);
//                         },
//                         child: Icon(
//                           Icons.arrow_back_outlined,
//                           size: 25,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.65),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(),
//                       ),
//                       Container(
//                         height: 25,
//                         width: 65,
//                         clipBehavior: Clip.antiAlias,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18),
//                           border: Border.all(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .primary
//                                 .withOpacity(0.75),
//                             width: 1,
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Help?",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.extraBold,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerWidget(height: 36),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: RelativeSize.width(20, width)),
//                   child: Container(
//                     width: 180,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 5,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4),
//                       color: const Color.fromRGBO(233, 248, 238, 1),
//                       border: Border.all(
//                         color: Theme.of(context).colorScheme.surface,
//                         width: 1,
//                       ),
//                     ),
//                     child: Center(
//                       child: CountdownTimer(
//                         endTime: _endTime,
//                         widgetBuilder: (_, CurrentRemainingTime? time) {
//                           String text =
//                               "${time?.min ?? "00"}min : ${time?.sec ?? "00"}sec";

//                           if (ref
//                               .read(newLoanStateProvider)
//                               .fetchingInvoiceWithOffers) {
//                             text = "Fetching...";
//                           }

//                           if (time == null) {
//                             text = "Time's up!";
//                           }

//                           return Text(
//                             "Valid for: $text",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.medium,
//                               color: const Color.fromRGBO(39, 188, 92, 1),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: RelativeSize.width(20, width)),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 40,
//                         child: getLenderDetailsAssetURL(
//                             selectedOffer.bankName, selectedOffer.bankLogoURL),
//                       ),
//                       const SpacerWidget(
//                         width: 10,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           ref
//                               .read(newLoanStateProvider.notifier)
//                               .updateState(NewLoanProgress.loanOfferSelect);
//                           context.go(AppRoutes.msme_new_loan_process);
//                         },
//                         child: Text(
//                           "Offer Details",
//                           style: TextStyle(
//                               fontFamily: fontFamily,
//                               color: Theme.of(context).colorScheme.onSurface,
//                               fontSize: AppFontSizes.title,
//                               fontWeight: AppFontWeights.extraBold,
//                               letterSpacing: 0.4),
//                           softWrap: true,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 13,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: RelativeSize.width(20, width)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       RichText(
//                         text: TextSpan(
//                           text: "Lender : ",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             color: Theme.of(context).colorScheme.onSurface,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.normal,
//                             letterSpacing: 0.14,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: selectedOffer.bankName,
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SpacerWidget(
//                         width: 10,
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           text: "KYC : ",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             color: Theme.of(context).colorScheme.onSurface,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.normal,
//                             letterSpacing: 0.14,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: "To be done",
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 40,
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.secondary,
//                   ),
//                   child: Row(
//                     children: <Widget>[
//                       Column(
//                         children: <Widget>[
//                           Text(
//                             "Loan",
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.onSurface,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.medium,
//                               fontFamily: fontFamily,
//                             ),
//                           ),
//                           const SpacerWidget(
//                             height: 3,
//                           ),
//                           Text(
//                             "₹ ${selectedOffer.deposit}",
//                             style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h2,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.14),
//                           ),
//                         ],
//                       ),
//                       Expanded(child: Container()),
//                       Column(
//                         children: <Widget>[
//                           Text(
//                             "Interest",
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.onSurface,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.medium,
//                               fontFamily: fontFamily,
//                             ),
//                           ),
//                           const SpacerWidget(
//                             height: 3,
//                           ),
//                           Text(
//                             "₹ ${selectedOffer.interest} ",
//                             style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h2,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.14),
//                           ),
//                         ],
//                       ),
//                       Expanded(child: Container()),
//                       Column(
//                         children: <Widget>[
//                           Text(
//                             "Duration",
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.onSurface,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.medium,
//                               fontFamily: fontFamily,
//                             ),
//                           ),
//                           const SpacerWidget(
//                             height: 3,
//                           ),
//                           Text(
//                             selectedOffer.tenure,
//                             style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h2,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontFamily: fontFamily,
//                                 letterSpacing: 0.14),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(25, width), 20, 0, 12),
//                   child: Text(
//                     "REPAYMENT",
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontSize: AppFontSizes.h2,
//                       fontWeight: AppFontWeights.bold,
//                       fontFamily: fontFamily,
//                       letterSpacing: 0.14,
//                     ),
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 20,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(25, width), 0, 40, 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.primary,
//                               shape: BoxShape.circle,
//                             ),
//                             height: 15,
//                             width: 15,
//                             child: Center(
//                               child: Icon(
//                                 Icons.arrow_forward,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                                 size: 12,
//                               ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 12,
//                           ),
//                           Expanded(
//                             child: Text(
//                               "You may reduce the interest by repaying before the due date",
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 fontFamily: fontFamily,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 13.5,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.primary,
//                               shape: BoxShape.circle,
//                             ),
//                             height: 15,
//                             width: 15,
//                             child: Center(
//                               child: Icon(
//                                 Icons.arrow_forward,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                                 size: 12,
//                               ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 12,
//                           ),
//                           Expanded(
//                             child: Text(
//                               "Late repayment will lead to penalty",
//                               style: TextStyle(
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 fontFamily: fontFamily,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.fromLTRB(25, 20, 0, 12),
//                   child: Text(
//                     "LOAN DETAILS (Key Fact Sheet)",
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontSize: AppFontSizes.h2,
//                       fontWeight: AppFontWeights.bold,
//                       fontFamily: fontFamily,
//                       letterSpacing: 0.14,
//                     ),
//                   ),
//                 ),

//                 // 1. Loan Amount
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
//                           "Loan Value",
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
//                               "₹ ${selectedOffer.deposit}",
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

//                 // 2. Interest Rate
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
//                               "@${selectedOffer.interestRate} p.a.",
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

//                 // 2.1 Annual Interest Rate
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
//                           "Annual Percentage Rate (APR)",
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
//                               selectedOffer.annualPercentageRate,
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

//                 // 3. Application Fee
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
//                           "Application Fee",
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
//                               "₹ ${selectedOffer.applicationFee}",
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

//                 // 4. Processing Fees
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
//                           "Processing Charge",
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
//                               "₹ ${selectedOffer.processingFee}",
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

//                 // 5. Insurance Charges
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
//                           "Insurance Charges",
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
//                               "₹ ${selectedOffer.insuranceCharges.isNotEmpty ? selectedOffer.insuranceCharges : "0"}",
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

//                 // 6. Other Charges
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
//                           "Other Charges",
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
//                               "₹ ${selectedOffer.otherCharges}",
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

//                 // 7. Total Disbursed Amount
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
//                           "Total Amount Disbursed",
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
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // 8. Total Loan Repayment
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
//                           "Total Repayment Amount",
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

//                 // 9. Loan Tenure
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
//                           "Loan Tenure",
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

//                 // 10. Repayment Frequency
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
//                           "Repayment Frequency",
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
//                               selectedOffer.repaymentFrequency,
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

//                 // 11. Number of Installments
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
//                           "Number of Installments",
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
//                               selectedOffer.numInstallments,
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

//                 // 12. Installment Amount
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
//                           "Installment Amount",
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
//                               selectedOffer.installmentAmount,
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

//                 // 13. Cool off period
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
//                           "Cool Off Period",
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
//                               selectedOffer.coolOffPeriod,
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

//                 // 14. Delay Payment
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
//                           "Payment Delay Penalty",
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
//                               "${selectedOffer.lateCharge} per Month",
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

//                 // 15. Prepayment Penalty
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
//                           "Prepayment Penalty",
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
//                               selectedOffer.prepaymentPenalty,
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

//                 // 16. Other Penalty Fee
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
//                           "Other Penalty Fee",
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
//                               selectedOffer.otherPenaltyFee,
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

//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.fromLTRB(25, 20, 0, 12),
//                   color: Theme.of(context)
//                       .colorScheme
//                       .onSurface
//                       .withOpacity(0.05),
//                   child: Text(
//                     "Loan Service Provider Details",
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontSize: AppFontSizes.h2,
//                       fontWeight: AppFontWeights.bold,
//                       fontFamily: fontFamily,
//                       letterSpacing: 0.14,
//                     ),
//                   ),
//                 ),

//                 // 17. LSP Name
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
//                           "LSP Name",
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
//                               width: 120,
//                               child: Text(
//                                 selectedOffer.lspContactInfo.name,
//                                 softWrap: true,
//                                 textAlign: TextAlign.right,
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

//                 // 18. LSP Email
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
//                           "LSP Email",
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
//                               selectedOffer.lspContactInfo.email,
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

//                 // 19. LSP Contact
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
//                           "LSP Contact",
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
//                               selectedOffer.lspContactInfo.number,
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

//                 // 20. LSP Address
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 200,
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
//                           "LSP Address",
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
//                                 softWrap: true,
//                                 textAlign: TextAlign.right,
//                                 selectedOffer.lspContactInfo.address,
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

//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.fromLTRB(25, 20, 0, 12),
//                   color: Theme.of(context)
//                       .colorScheme
//                       .onSurface
//                       .withOpacity(0.05),
//                   child: Text(
//                     "Support Contact",
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontSize: AppFontSizes.h2,
//                       fontWeight: AppFontWeights.bold,
//                       fontFamily: fontFamily,
//                       letterSpacing: 0.14,
//                     ),
//                   ),
//                 ),

//                 // 21. Name
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
//                           "Name",
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
//                               "Avijeet Singh Gill",
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

//                 // 22. Designation
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 130,
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
//                           "Designation",
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
//                               width: 120,
//                               child: Text(
//                                 "Nodal Grievance Redressal Officer",
//                                 textAlign: TextAlign.right,
//                                 softWrap: true,
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

//                 // 23. Address
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 200,
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
//                           "Address",
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
//                                 "F547 Modern 8A Industrial Area Sector 75 SAS Nagar Mohali Punjab 160055",
//                                 textAlign: TextAlign.right,
//                                 softWrap: true,
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

//                 // 24. Phone Number
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Container(
//                     height: 100,
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
//                           "Phone",
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
//                               "8360458365",
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
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// String getRepaymentTime(int start, int days) {
//   DateTime startDate = DateTime.fromMillisecondsSinceEpoch(start * 1000);

//   // Calculate the end date by adding the number of days
//   DateTime endDate = startDate.add(Duration(days: days));

//   // Format the end date
//   String formattedEndDate = DateFormat('d MMM, yyyy').format(endDate);

//   return formattedEndDate;
// }

// class FormResponse {
//   final String message;
//   final int formNumber;

//   FormResponse({
//     required this.message,
//     required this.formNumber,
//   });
// }

// class ScreenActions extends ConsumerStatefulWidget {
//   const ScreenActions({super.key});

//   @override
//   ScreenActionsState createState() => ScreenActionsState();
// }

// class ScreenActionsState extends ConsumerState<ScreenActions> {
//   final _cancelToken = CancelToken();
//   bool _performingNextActions = false;
//   bool _performingSelect02 = false;

//   Future<void> _updateLoanOffer() async {
//     if (!ref.read(newLoanStateProvider).loanOfferUpdated) {
//       context.go(AppRoutes.msme_new_loan_update_offer_details);
//       return;
//     }

//     if (_performingSelect02) return;

//     setState(() {
//       _performingSelect02 = true;
//     });

//     final transactionId =
//         ref.read(newLoanStateProvider).selectedOffer.transactionId;
//     final providerId =
//         ref.read(newLoanStateProvider).selectedOffer.offerProviderId;
//     final offerId = ref.read(newLoanStateProvider).selectedOffer.offerId;
//     final invoiceNumber = ref.read(newLoanStateProvider).selectedInvoice.inum;

//     var response = await ref.read(newLoanStateProvider.notifier).selectOffer(
//         transactionId, providerId, offerId, invoiceNumber, _cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _performingSelect02 = false;
//     });

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'On Snap!',
//           message:
//               "Unable to select the offer. Contact support or Please try again later.",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 10),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }

//     return;
//   }

//   Future<void> _performNextActionsAfterOfferSelection() async {
//     // if (_performingNextActions) return;

//     setState(() {
//       _performingNextActions = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .performNextActions(_cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _performingNextActions = false;
//     });

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'On Snap!',
//           message:
//               "Unable to select the offer. Contact support or Please try again later.",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 10),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }
//     ref
//         .read(newLoanStateProvider.notifier)
//         .updateState(NewLoanProgress.loanOfferSelect);

//     bool navigateToAadharKYC = response.data["navigateToAadharKYC"] ?? false;

//     if (navigateToAadharKYC) {
//       context.go(AppRoutes.msme_new_loan_process);
//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//         width: MediaQuery.of(context).size.width,
//         height: RelativeSize.height(70, height),
//         decoration: const BoxDecoration(color: Colors.transparent),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 HapticFeedback.heavyImpact();
//                 _performNextActionsAfterOfferSelection();
//               },
//               child: Container(
//                 height: RelativeSize.height(40, height),
//                 width: RelativeSize.width(120, width),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primary,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Center(
//                   child: _performingNextActions
//                       ? Lottie.asset("assets/animations/loading_spinner.json",
//                           height: 50, width: 50)
//                       : Text(
//                           "Continue",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.medium,
//                             color: Theme.of(context).colorScheme.onPrimary,
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//             const SpacerWidget(
//               width: 30,
//             ),
//             GestureDetector(
//               onTap: () {
//                 HapticFeedback.heavyImpact();
//                 _updateLoanOffer();
//               },
//               child: Container(
//                 height: RelativeSize.height(40, height),
//                 width: RelativeSize.width(200, width),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primary,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Center(
//                   child: _performingSelect02
//                       ? Lottie.asset("assets/animations/loading_spinner.json",
//                           height: 50, width: 50)
//                       : Text(
//                           "Update Loan Requirement",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.medium,
//                             color: Theme.of(context).colorScheme.onPrimary,
//                           ),
//                         ),
//                 ),
//               ),
//             )
//           ],
//         ));
//   }
// }
