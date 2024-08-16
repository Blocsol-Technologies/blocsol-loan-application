// import 'dart:math';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/account_details/borrower_account_details_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/new_loan/new_loan_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:blocsol_personal_credit/utils/bank_logo_picker.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_countdown_timer/index.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';

// class PCNewLoanOfferDetails extends ConsumerStatefulWidget {
//   const PCNewLoanOfferDetails({super.key});

//   @override
//   ConsumerState<PCNewLoanOfferDetails> createState() =>
//       _PCNewLoanOfferDetailsState();
// }

// class _PCNewLoanOfferDetailsState extends ConsumerState<PCNewLoanOfferDetails> {
//   int _endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 900;
//   final _cancelToken = CancelToken();

//   void _handleNotificationBellPress() {}

//   @override
//   void initState() {
//     int properEndTime = max(
//         900 -
//             (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
//                 ref.read(newLoanStateProvider).offersFetchTime),
//         0);

//     setState(() {
//       _endTime = DateTime.now().millisecondsSinceEpoch + (properEndTime) * 1000;
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
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final newLoanStateRef = ref.watch(newLoanStateProvider);
//     final selectedOffer = newLoanStateRef.selectedOffer;
//     final borrowerAccountDetailsRef =
//         ref.watch(borrowerAccountDetailsStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           bottomNavigationBar: const LoanOfferActions(),
//           resizeToAvoidBottomInset: false,
//           body: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Stack(
//               children: [
//                 Container(
//                   width: width,
//                   height: RelativeSize.height(235, height),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primary,
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(40),
//                       bottomRight: Radius.circular(40),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       vertical: RelativeSize.height(20, height)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(30, width)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             GestureDetector(
//                               onTap: () {
//                                 HapticFeedback.mediumImpact();
//                                 context.go(AppRoutes.pc_new_loan_offers_home);
//                               },
//                               child: Icon(
//                                 Icons.arrow_back_ios,
//                                 size: 20,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                             ),
//                             SizedBox(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   IconButton(
//                                     onPressed: () {
//                                       HapticFeedback.mediumImpact();
//                                       _handleNotificationBellPress();
//                                     },
//                                     icon: Icon(
//                                       Icons.notifications_active,
//                                       size: 25,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary,
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     width: 15,
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       HapticFeedback.mediumImpact();
//                                     },
//                                     child: Container(
//                                       height: 28,
//                                       width: 28,
//                                       clipBehavior: Clip.antiAlias,
//                                       decoration: BoxDecoration(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onPrimary,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Center(
//                                         child: Image.network(
//                                           borrowerAccountDetailsRef
//                                                   .imageURL.isEmpty
//                                               ? "https://placehold.co/30x30/000000/FFFFFF.png"
//                                               : borrowerAccountDetailsRef
//                                                   .imageURL,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: SizedBox(
//                           width: width,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Offer Details",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.h1,
//                                   fontWeight: AppFontWeights.medium,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 softWrap: true,
//                               ),
//                               const SpacerWidget(
//                                 height: 10,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     height: 40,
//                                     child: getLenderDetailsAssetURL(
//                                         selectedOffer.bankName,
//                                         selectedOffer.bankLogoURL),
//                                   ),
//                                   const SpacerWidget(
//                                     width: 10,
//                                   ),
//                                   SizedBox(
//                                     width: 120,
//                                     child: Text(
//                                       selectedOffer.bankName,
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.normal,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onPrimary,
//                                         letterSpacing: 0.24,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                       softWrap: true,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 40,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(30, width)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 150,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(4),
//                                 color: const Color.fromRGBO(233, 248, 238, 1),
//                                 border: Border.all(
//                                   color: Theme.of(context).colorScheme.surface,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: CountdownTimer(
//                                   endTime: _endTime,
//                                   widgetBuilder:
//                                       (_, CurrentRemainingTime? time) {
//                                     String text =
//                                         "${time?.min ?? "00"}m : ${time?.sec ?? "00"}s";

//                                     if (ref
//                                         .read(newLoanStateProvider)
//                                         .fetchingOffers) {
//                                       text = "Fetching...";
//                                     }

//                                     if (time == null) {
//                                       text = "Time's up!";
//                                     }

//                                     return Text(
//                                       "Valid for: $text",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.medium,
//                                         color: const Color.fromRGBO(
//                                             39, 188, 92, 1),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(30, width)),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 15),
//                           decoration: BoxDecoration(
//                             color: const Color.fromRGBO(217, 229, 222, 1),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Row(
//                             children: <Widget>[
//                               Column(
//                                 children: <Widget>[
//                                   Text(
//                                     "Loan",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.body,
//                                       fontWeight: AppFontWeights.medium,
//                                       fontFamily: fontFamily,
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     height: 3,
//                                   ),
//                                   Text(
//                                     "₹ ${selectedOffer.deposit}",
//                                     style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         fontFamily: fontFamily,
//                                         letterSpacing: 0.14),
//                                   ),
//                                 ],
//                               ),
//                               Expanded(child: Container()),
//                               Column(
//                                 children: <Widget>[
//                                   Text(
//                                     "Interest",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.body,
//                                       fontWeight: AppFontWeights.medium,
//                                       fontFamily: fontFamily,
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     height: 3,
//                                   ),
//                                   Text(
//                                     "₹ ${selectedOffer.interest} ",
//                                     style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         fontFamily: fontFamily,
//                                         letterSpacing: 0.14),
//                                   ),
//                                 ],
//                               ),
//                               Expanded(child: Container()),
//                               Column(
//                                 children: <Widget>[
//                                   Text(
//                                     "Duration",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.body,
//                                       fontWeight: AppFontWeights.medium,
//                                       fontFamily: fontFamily,
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     height: 3,
//                                   ),
//                                   Text(
//                                     selectedOffer.tenure,
//                                     style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         fontFamily: fontFamily,
//                                         letterSpacing: 0.14),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: const EdgeInsets.fromLTRB(25, 23, 0, 12),
//                         child: Text(
//                           "REPAYMENT",
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onBackground,
//                             fontSize: AppFontSizes.h2,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 15,
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: const EdgeInsets.fromLTRB(20, 0, 40, 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   height: 15,
//                                   width: 15,
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.arrow_forward,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary,
//                                       size: 12,
//                                     ),
//                                   ),
//                                 ),
//                                 const SpacerWidget(
//                                   width: 12,
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     "You may reduce the interest by repaying before the due date",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.body,
//                                       fontWeight: AppFontWeights.medium,
//                                       fontFamily: fontFamily,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SpacerWidget(
//                               height: 13.5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   height: 15,
//                                   width: 15,
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.arrow_forward,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary,
//                                       size: 12,
//                                     ),
//                                   ),
//                                 ),
//                                 const SpacerWidget(
//                                   width: 12,
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     "Late repayment will lead to penalty",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.body,
//                                       fontWeight: AppFontWeights.medium,
//                                       fontFamily: fontFamily,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: const EdgeInsets.fromLTRB(25, 20, 0, 12),
//                         child: Text(
//                           "LOAN DETAILS (Key Fact Sheet)",
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onBackground,
//                             fontSize: AppFontSizes.h2,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                       ),

//                       // 1. Loan Value
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Loan Value",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "₹ ${selectedOffer.deposit}",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 2. Interest Rate
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Interest",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "₹ ${selectedOffer.interest}",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     height: 3,
//                                   ),
//                                   Text(
//                                     "@${selectedOffer.interestRate} p.a.",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.4),
//                                       fontSize: AppFontSizes.body2,
//                                       fontWeight: AppFontWeights.normal,
//                                       fontFamily: fontFamily,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 2.1. Annual Percentage Rate
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Annual Percentage Rate (APR)",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     selectedOffer.annualPercentageRate,
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 3. Application Fee
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Application Fee",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "₹ ${selectedOffer.getNumericalValOrDefault(selectedOffer.applicationFee)}",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 4. Processing Fee
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Processing Charge",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "₹ ${selectedOffer.getNumericalValOrDefault(selectedOffer.processingFee)}",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 5. Total Insurance
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Insurance Charge",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "₹ ${selectedOffer.getNumericalValOrDefault(selectedOffer.insuranceCharges)}",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 6. Other Charges
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Other Charges",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "₹ ${selectedOffer.getNumericalValOrDefault(selectedOffer.otherCharges)}",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 7. Total Disbursed Amount
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Total Amount Disbursed",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "₹ ${selectedOffer.getTotalDisbursedAmount()}",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 8. Total Repayment Amount
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Total Repayment Amount",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "₹ ${selectedOffer.totalRepaymentAmount}",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 9. Tenure
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Loan Tenure",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     selectedOffer.tenure,
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 10. Repayment Frequency
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Repayment Frequency",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "Monthly",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 11. Number of Installments
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "No. of Installments",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     selectedOffer.numInstallments,
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 12. Installment Amount
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Installment Amount",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "₹  ${selectedOffer.emi}",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 13. Cool off period
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Cool of Period",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     selectedOffer.coolOffPeriod,
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 14. Delay Payment
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Late Charge",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     "${selectedOffer.lateCharge} per Month",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 15. Prepayment Penalty
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Prepayment Penalty",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     selectedOffer.prepaymentPenalty,
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 16. Other Penalty Fee
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Other Penalty Fee",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     selectedOffer.otherPenaltyFee,
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: const EdgeInsets.fromLTRB(25, 20, 0, 12),
//                         child: Text(
//                           "Loan Service Provider Details",
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onBackground,
//                             fontSize: AppFontSizes.h2,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                       ),

//                       // 17. LSP Name
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "LSP Name",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     width: 120,
//                                     child: Text(
//                                       selectedOffer.lspContactDetails.name,
//                                       softWrap: true,
//                                       style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         fontFamily: fontFamily,
//                                         letterSpacing: 0.165,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 18. LSP Email
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "LSP Email",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     selectedOffer.lspContactDetails.email,
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 19. LSP Contact
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "LSP Contact",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     selectedOffer.lspContactDetails.phone,
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.bold,
//                                       fontFamily: fontFamily,
//                                       letterSpacing: 0.165,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 20. LSP Address
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 150,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "LSP Address",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     width: 180,
//                                     child: Text(
//                                       selectedOffer.lspContactDetails.address,
//                                       softWrap: true,
//                                       textAlign: TextAlign.end,
//                                       style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         fontFamily: fontFamily,
//                                         letterSpacing: 0.165,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: const EdgeInsets.fromLTRB(25, 20, 0, 12),
//                         child: Text(
//                           "Support Contact",
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onBackground,
//                             fontSize: AppFontSizes.h2,
//                             fontWeight: AppFontWeights.medium,
//                             fontFamily: fontFamily,
//                             letterSpacing: 0.14,
//                           ),
//                         ),
//                       ),

//                       // 21. Support Name
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Name",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     width: 120,
//                                     child: Text(
//                                       "Avijeet Singh Gill",
//                                       softWrap: true,
//                                       textAlign: TextAlign.end,
//                                       style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         fontFamily: fontFamily,
//                                         letterSpacing: 0.165,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 22. Designation
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Designation",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     width: 150,
//                                     child: Text(
//                                       "Nodal Grievance Redressal Officer",
//                                       softWrap: true,
//                                       textAlign: TextAlign.end,
//                                       style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         fontFamily: fontFamily,
//                                         letterSpacing: 0.165,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 23. Address
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 110,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Address",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     width: 150,
//                                     child: Text(
//                                       "F547 Modern 8A Industrial Area Sector 75 SAS Nagar Mohali Punjab 160055",
//                                       softWrap: true,
//                                       textAlign: TextAlign.end,
//                                       style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         fontFamily: fontFamily,
//                                         letterSpacing: 0.165,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 23. Phone
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Container(
//                           height: 75,
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground
//                                           .withOpacity(0.2),
//                                       width: 1))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "Phone",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground
//                                       .withOpacity(0.4),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     width: 120,
//                                     child: Text(
//                                       "8360458365",
//                                       softWrap: true,
//                                       textAlign: TextAlign.end,
//                                       style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         fontFamily: fontFamily,
//                                         letterSpacing: 0.165,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 32,
//                       ),
//                     ],
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

// class LoanOfferActions extends ConsumerStatefulWidget {
//   const LoanOfferActions({super.key});

//   @override
//   ConsumerState<LoanOfferActions> createState() => _LoanOfferActionsState();
// }

// class _LoanOfferActionsState extends ConsumerState<LoanOfferActions> {
//   final _cancelToken = CancelToken();
//   bool _performingNextActions = false;
//   bool _performingSelect02 = false;

//   Future<void> updateLoanOffer() async {
//     if (!ref.read(newLoanStateProvider).loanOfferUpdated) {
//       context.go(AppRoutes.pc_new_loan_update_offer_screen);
//       return;
//     }

//     if (_performingSelect02) return;

//     setState(() {
//       _performingSelect02 = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .performSelect2(_cancelToken);

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

//     context.go(AppRoutes.pc_new_loan_update_offer_screen);

//     return;
//   }

//   Future<void> _performNextActionsAfterOfferSelection() async {
//     // if (_performingNextActions) return;

//     setState(() {
//       _performingNextActions = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .performNextActionsAfterOfferSelection(_cancelToken);

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
//       context.go(AppRoutes.pc_new_loan_process);
//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final newLoanStateRef = ref.watch(newLoanStateProvider);
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: RelativeSize.height(70, height),
//       decoration: const BoxDecoration(color: Colors.transparent),
//       child: newLoanStateRef.offerSelected
//           ? Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     HapticFeedback.heavyImpact();
//                     _performNextActionsAfterOfferSelection();
//                   },
//                   child: Container(
//                     height: RelativeSize.height(40, height),
//                     width: RelativeSize.width(120, width),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: _performingNextActions
//                           ? Lottie.asset(
//                               "assets/animations/loading_spinner.json",
//                               height: 50,
//                               width: 50)
//                           : Text(
//                               "Continue",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//                 const SpacerWidget(
//                   width: 30,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     HapticFeedback.heavyImpact();
//                     updateLoanOffer();
//                   },
//                   child: Container(
//                     height: RelativeSize.height(40, height),
//                     width: RelativeSize.width(200, width),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: _performingSelect02
//                           ? Lottie.asset(
//                               "assets/animations/loading_spinner.json",
//                               height: 50,
//                               width: 50)
//                           : Text(
//                               "Update Loan Requirement",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                             ),
//                     ),
//                   ),
//                 )
//               ],
//             )
//           : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     HapticFeedback.heavyImpact();
//                     updateLoanOffer();
//                   },
//                   child: Container(
//                     height: RelativeSize.height(40, height),
//                     width: RelativeSize.width(252, width),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: _performingSelect02
//                           ? Lottie.asset(
//                               "assets/animations/loading_spinner.json",
//                               height: 50,
//                               width: 50)
//                           : Text(
//                               "Continue",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
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