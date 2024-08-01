// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/liabilities/missed-emi/missed_emi_payment_modal_bottom_sheet.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/liabilities/utils/top_decoration.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/liabilities/liabilities_state.dart';
// import 'package:blocsol_invoice_based_credit/state/utils/loan_details.dart';
// import 'package:blocsol_invoice_based_credit/utils/lender_utils.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:percent_indicator/percent_indicator.dart';

// class LiabilityPaymentHistory extends ConsumerStatefulWidget {
//   const LiabilityPaymentHistory({super.key});

//   @override
//   ConsumerState<LiabilityPaymentHistory> createState() =>
//       _LiabilityPaymentHistoryState();
// }

// class _LiabilityPaymentHistoryState
//     extends ConsumerState<LiabilityPaymentHistory> {
//   final _cancelToken = CancelToken();

//   Future<void> _missedEmiHandler(OfferPayments paymentDetails) async {
//     if (ref.read(liabilitiesStateProvider).initiatingMissedEmiPayment) {
//       return;
//     }

//     ref
//         .read(liabilitiesStateProvider.notifier)
//         .updateMissedEmiPaymentId(paymentDetails.id);

//     var response = await ref
//         .read(liabilitiesStateProvider.notifier)
//         .initiateMissedEMIPayment(_cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: response.message,
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 5),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//       return;
//     }

//     showModalBottomSheet(
//         isScrollControlled: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(20),
//           ),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         context: context,
//         builder: (context) {
//           return Padding(
//             padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom),
//             child: MissedEmiPaymentModalBottomSheet(
//               url: response.data['url'],
//             ),
//           );
//         });

//     return;
//   }

//   Future<void> _repayLoanHandler() async {
//     OfferPayments? paymentDetails;

//     for (final payment in ref
//         .watch(liabilitiesStateProvider)
//         .selectedLiability
//         .offerDetails
//         .payments
//         .paymentDetails) {
//       if (payment.status == LoanPaymentStatus.missed) {
//         paymentDetails = payment;
//         break;
//       }
//     }

//     if (paymentDetails != null) {
//       await _missedEmiHandler(paymentDetails);
//     } else {
//       context.go(AppRoutes.msme_liability_prepay);
//     }
//   }

//   @override
//   void dispose() {
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final oldLoanStateRef = ref.watch(liabilitiesStateProvider);
//     final selectedLiability = oldLoanStateRef.selectedLiability;

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Stack(
//               children: [
//                 const LiabilityTopDecoration(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                           top: RelativeSize.height(20, height),
//                           left: RelativeSize.width(30, width),
//                           right: RelativeSize.width(30, width)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               HapticFeedback.mediumImpact();
//                               context.go(AppRoutes.msme_liability_details);
//                             },
//                             child: Icon(
//                               Icons.arrow_back_ios,
//                               size: 20,
//                               color: Theme.of(context).colorScheme.onPrimary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 30,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(40, width)),
//                       child: SizedBox(
//                         width: width,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               selectedLiability.offerDetails.bankName,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h1,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                               textAlign: TextAlign.center,
//                               softWrap: true,
//                             ),
//                             const SpacerWidget(
//                               height: 10,
//                             ),
//                             Text(
//                               selectedLiability.offerDetails.offerProviderId,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.normal,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                                 letterSpacing: 0.24,
//                               ),
//                               textAlign: TextAlign.center,
//                               softWrap: true,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 75,
//                     ),
//                     Container(
//                       height: RelativeSize.height(340, height),
//                       width: width,
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(40, width)),
//                       child: Stack(
//                         children: [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     height: 120,
//                                     width: 120,
//                                     child: Center(
//                                       child: CircularPercentIndicator(
//                                         radius: 60,
//                                         lineWidth: 12,
//                                         animation: true,
//                                         percent: selectedLiability.offerDetails
//                                             .getAmountPaidPercentage(),
//                                         center: SizedBox(
//                                           height: 100,
//                                           width: 100,
//                                           child: getLenderDetailsAssetURL(
//                                               selectedLiability
//                                                   .offerDetails.bankName,
//                                               selectedLiability
//                                                   .offerDetails.bankLogoURL),
//                                         ),
//                                         circularStrokeCap:
//                                             CircularStrokeCap.round,
//                                         progressColor: const Color.fromRGBO(
//                                             38, 36, 123, 1),
//                                       ),
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     width: 48,
//                                   ),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: <Widget>[
//                                         Text(
//                                           "Balance Left",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.body,
//                                             fontWeight: AppFontWeights.normal,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onTertiary,
//                                           ),
//                                         ),
//                                         const SpacerWidget(
//                                           height: 15,
//                                         ),
//                                         Text(
//                                           "₹ ${selectedLiability.offerDetails.getBalanceLeft()}",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.h2,
//                                             fontWeight: AppFontWeights.medium,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onTertiary,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SpacerWidget(
//                                 height: 30,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     height: RelativeSize.height(45, height),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "Amount Paid",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.body,
//                                             fontWeight: AppFontWeights.normal,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onTertiary,
//                                           ),
//                                         ),
//                                         Text(
//                                           "₹ ${selectedLiability.offerDetails.getAmountPaid()}",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.h3,
//                                             fontWeight: AppFontWeights.medium,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onTertiary,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     width: 20,
//                                   ),
//                                   SizedBox(
//                                     height: RelativeSize.height(45, height),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "Repayment",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.body,
//                                             fontWeight: AppFontWeights.normal,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onTertiary,
//                                           ),
//                                         ),
//                                         Text(
//                                           "₹ ${selectedLiability.offerDetails.totalRepayment}",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.h3,
//                                             fontWeight: AppFontWeights.medium,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onTertiary,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     width: 20,
//                                   ),
//                                   SizedBox(
//                                     height: RelativeSize.height(45, height),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "Next Due Date",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.body,
//                                             fontWeight: AppFontWeights.normal,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onTertiary,
//                                           ),
//                                         ),
//                                         Text(
//                                           selectedLiability.offerDetails
//                                               .getNextDueDate(),
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.h3,
//                                             fontWeight: AppFontWeights.medium,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onTertiary,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               const SpacerWidget(
//                                 height: 42,
//                               ),
//                               Container(
//                                 width: RelativeSize.width(300, width),
//                                 height: 5,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color:
//                                         const Color.fromRGBO(207, 210, 186, 1)),
//                                 clipBehavior: Clip.antiAlias,
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: RelativeSize.width(
//                                           300 *
//                                               selectedLiability.offerDetails
//                                                   .getPaidEMIPercentage(),
//                                           width),
//                                       height: 5,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .primary),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 height: 5,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   const SpacerWidget(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     "${selectedLiability.offerDetails.getNumPaidEMIS()} EMI Paid of ${selectedLiability.offerDetails.getNumEMIS()}",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       fontSize: AppFontSizes.body,
//                                       fontWeight: AppFontWeights.normal,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onTertiary,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SpacerWidget(
//                                 height: 40,
//                               ),
//                               Text(
//                                 "Payment Details",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.medium,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 height: 18,
//                               ),
//                               Container(
//                                 height: 3,
//                                 width: RelativeSize.width(225, width),
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .scrim
//                                     .withOpacity(0.5),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 30,
//                     ),
//                     ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: selectedLiability
//                             .offerDetails.payments.paymentDetails.length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: RelativeSize.width(30, width)),
//                             child: SizedBox(
//                               width: width,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     selectedLiability.offerDetails.formatDate(
//                                         selectedLiability.offerDetails.payments
//                                             .paymentDetails[index].endTime),
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       fontSize: AppFontSizes.body,
//                                       fontWeight: AppFontWeights.normal,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onTertiary,
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     height: 5,
//                                   ),
//                                   Container(
//                                     width: width,
//                                     height: RelativeSize.height(50, height),
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal:
//                                             RelativeSize.width(35, width)),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: const Color.fromRGBO(
//                                             233, 233, 250, 1)),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           height: 50,
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Monthly Installment",
//                                                 textAlign: TextAlign.start,
//                                                 style: TextStyle(
//                                                   fontFamily: fontFamily,
//                                                   fontSize: AppFontSizes.body,
//                                                   fontWeight:
//                                                       AppFontWeights.normal,
//                                                   color: Theme.of(context)
//                                                       .colorScheme
//                                                       .onSurface,
//                                                 ),
//                                               ),
//                                               const SpacerWidget(
//                                                 height: 5,
//                                               ),
//                                               Text(
//                                                 "$index of ${selectedLiability.offerDetails.getNumEMIS()}",
//                                                 textAlign: TextAlign.start,
//                                                 style: TextStyle(
//                                                   fontFamily: fontFamily,
//                                                   fontSize: AppFontSizes.body,
//                                                   fontWeight:
//                                                       AppFontWeights.medium,
//                                                   color: Theme.of(context)
//                                                       .colorScheme
//                                                       .onSurface,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 50,
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 "₹ ${selectedLiability.offerDetails.getNumericalValOrDefault(
//                                                   selectedLiability
//                                                       .offerDetails
//                                                       .payments
//                                                       .paymentDetails[index]
//                                                       .amount,
//                                                 )}",
//                                                 textAlign: TextAlign.start,
//                                                 style: TextStyle(
//                                                   fontFamily: fontFamily,
//                                                   fontSize: AppFontSizes.body,
//                                                   fontWeight:
//                                                       AppFontWeights.medium,
//                                                   color: Theme.of(context)
//                                                       .colorScheme
//                                                       .onSurface,
//                                                 ),
//                                               ),
//                                               const SpacerWidget(
//                                                 height: 5,
//                                               ),
//                                               Text(
//                                                 selectedLiability.offerDetails
//                                                     .getPaymentStatus(
//                                                         selectedLiability
//                                                             .offerDetails
//                                                             .payments
//                                                             .paymentDetails[
//                                                                 index]
//                                                             .status),
//                                                 textAlign: TextAlign.start,
//                                                 style: TextStyle(
//                                                   fontFamily: fontFamily,
//                                                   fontSize: AppFontSizes.body,
//                                                   fontWeight:
//                                                       AppFontWeights.normal,
//                                                   color: selectedLiability
//                                                       .offerDetails
//                                                       .getPaymentStatusColor(
//                                                           selectedLiability
//                                                               .offerDetails
//                                                               .payments
//                                                               .paymentDetails[
//                                                                   index]
//                                                               .status),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   selectedLiability.offerDetails.payments
//                                               .paymentDetails[index].status ==
//                                           LoanPaymentStatus.missed
//                                       ? GestureDetector(
//                                           onTap: () {
//                                             HapticFeedback.heavyImpact();
//                                             _missedEmiHandler(selectedLiability
//                                                 .offerDetails
//                                                 .payments
//                                                 .paymentDetails[index]);
//                                           },
//                                           child: Container(
//                                             width: width,
//                                             height: 30,
//                                             decoration: BoxDecoration(
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .primary,
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                             ),
//                                             child: Center(
//                                               child: oldLoanStateRef
//                                                       .initiatingMissedEmiPayment
//                                                   ? Lottie.asset(
//                                                       'assets/animations/loading_spinner.json',
//                                                       height: 50,
//                                                       width: 50)
//                                                   : Text(
//                                                       "Make Missed EMI Payment",
//                                                       style: TextStyle(
//                                                         fontFamily: fontFamily,
//                                                         fontSize:
//                                                             AppFontSizes.body,
//                                                         fontWeight:
//                                                             AppFontWeights
//                                                                 .medium,
//                                                         color: Theme.of(context)
//                                                             .colorScheme
//                                                             .onPrimary,
//                                                       ),
//                                                     ),
//                                             ),
//                                           ),
//                                         )
//                                       : const SizedBox(),
//                                   const SpacerWidget(
//                                     height: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }),
//                     const SpacerWidget(
//                       height: 45,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         HapticFeedback.heavyImpact();
//                         _repayLoanHandler();
//                       },
//                       child: Container(
//                         height: RelativeSize.height(40, height),
//                         width: RelativeSize.width(252, width),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.primary,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Continue",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.medium,
//                               color: Theme.of(context).colorScheme.onPrimary,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 45,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
