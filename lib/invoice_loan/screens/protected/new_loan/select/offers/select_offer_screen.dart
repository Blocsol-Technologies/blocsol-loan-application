// import 'dart:math';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/utils/loan_details.dart';
// import 'package:blocsol_invoice_based_credit/utils/lender_utils.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_countdown_timer/index.dart';
// import 'package:lottie/lottie.dart';

// class LoanOfferDetails extends ConsumerStatefulWidget {
//   const LoanOfferDetails({super.key});

//   @override
//   ConsumerState<LoanOfferDetails> createState() => _LoanOfferDetailsState();
// }

// class _LoanOfferDetailsState extends ConsumerState<LoanOfferDetails> {
//   int _endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 900;

//   @override
//   void initState() {
//     int properEndTime = max(
//         900 -
//             (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
//                 ref.read(newLoanStateProvider).invoiceWithOffersFetchTime),
//         0);

//     setState(() {
//       _endTime = DateTime.now().millisecondsSinceEpoch + (properEndTime) * 1000;
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;

//     final selectedInvoiceOffer =
//         ref.watch(newLoanStateProvider).selectedInvoice;
//     final _ = ref.watch(serverSentEventStateProvider);
//     ref.watch(loanEventStateProvider);

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(
//                 RelativeSize.width(20, width),
//                 RelativeSize.height(20, height),
//                 RelativeSize.width(20, width),
//                 RelativeSize.height(50, height)),
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     GestureDetector(
//                       onTap: () async {
//                         HapticFeedback.mediumImpact();
//                         context
//                             .go(AppRoutes.msme_new_loan_invoice_offer_select);
//                       },
//                       child: Icon(
//                         Icons.arrow_back_outlined,
//                         size: 25,
//                         color: Theme.of(context)
//                             .colorScheme
//                             .onSurface
//                             .withOpacity(0.65),
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(),
//                     ),
//                     Container(
//                       height: 25,
//                       width: 65,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         border: Border.all(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .primary
//                               .withOpacity(0.75),
//                           width: 1,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Help?",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.extraBold,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SpacerWidget(height: 36),
//                 Container(
//                   width: 180,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: const Color.fromRGBO(233, 248, 238, 1),
//                     border: Border.all(
//                       color: Theme.of(context).colorScheme.surface,
//                       width: 1,
//                     ),
//                   ),
//                   child: Center(
//                     child: CountdownTimer(
//                       endTime: _endTime,
//                       widgetBuilder: (_, CurrentRemainingTime? time) {
//                         String text =
//                             "${time?.min ?? "00"}min : ${time?.sec ?? "00"}sec";

//                         if (ref
//                             .read(newLoanStateProvider)
//                             .fetchingInvoiceWithOffers) {
//                           text = "Fetching...";
//                         }

//                         if (time == null) {
//                           text = "Time's up!";
//                         }

//                         return Text(
//                           "Valid for: $text",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.medium,
//                             color: const Color.fromRGBO(39, 188, 92, 1),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 16,
//                 ),
//                 Text(
//                   "Select Offer ",
//                   style: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.h1,
//                     fontWeight: AppFontWeights.bold,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   softWrap: true,
//                 ),
//                 const SpacerWidget(
//                   height: 16,
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: "Invoice Number:  ",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontSize: AppFontSizes.h3,
//                       fontWeight: AppFontWeights.normal,
//                       letterSpacing: 0.14,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: selectedInvoiceOffer.inum,
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                           fontSize: AppFontSizes.h2,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.14,
//                           fontFamily: fontFamily,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: "Invoice Amount:  ",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontSize: AppFontSizes.h3,
//                       fontWeight: AppFontWeights.normal,
//                       letterSpacing: 0.14,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: "₹ ${selectedInvoiceOffer.amount}",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurface,
//                           fontSize: AppFontSizes.h2,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.14,
//                           fontFamily: fontFamily,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 45,
//                 ),
//                 ...selectedInvoiceOffer.offerDetailsList.map((offer) {
//                   return InvoiceOfferWidget(
//                     invoiceNumber: selectedInvoiceOffer.inum,
//                     offer: offer,
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class InvoiceOfferWidget extends ConsumerStatefulWidget {
//   final String invoiceNumber;
//   final OfferDetails offer;
//   const InvoiceOfferWidget(
//       {super.key, required this.offer, required this.invoiceNumber});

//   @override
//   ConsumerState<InvoiceOfferWidget> createState() => _InvoiceOfferWidgetState();
// }

// class _InvoiceOfferWidgetState extends ConsumerState<InvoiceOfferWidget> {
//   final _cancelToken = CancelToken();

//   bool _selectingOffer = false;

//   Future<void> _selectOffer() async {
//     if (_selectingOffer) {
//       return;
//     }

//     setState(() {
//       _selectingOffer = true;
//     });

//     ref.read(newLoanStateProvider.notifier).setOfferSelected(widget.offer);

//     var response = await ref.read(newLoanStateProvider.notifier).selectOffer(
//         widget.offer.transactionId,
//         widget.offer.offerProviderId,
//         widget.offer.offerId,
//         widget.invoiceNumber,
//         _cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       setState(() {
//         _selectingOffer = false;
//       });
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

//     await Future.delayed(const Duration(seconds: 5));

//     if (ref.read(newLoanStateProvider).selectedOffer.installmentAmount != "") {
//       return;
//     }

//     if (!mounted) return;

//     response = await ref
//         .read(newLoanStateProvider.notifier)
//         .refetchSelectedOfferDetails(_cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _selectingOffer = false;
//     });

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'On Snap!',
//           message: "Unable to select the offer. ${response.message}",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 10),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }

//     context.go(AppRoutes.msme_new_loan_single_loan_offer_details);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.only(
//         bottom: RelativeSize.height(30, height),
//       ),
//       child: GestureDetector(
//         onTap: () {
//           HapticFeedback.mediumImpact();
//           _selectOffer();
//         },
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.secondary,
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: [
//               BoxShadow(
//                 color: Theme.of(context)
//                     .colorScheme
//                     .onSurface
//                     .withOpacity(0.15), // Shadow color
//                 offset: const Offset(0, 2), // Offset in the x and y direction
//                 blurRadius: 10, // Spread of the shadow
//                 spreadRadius: 0, // Extent of the shadow
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 30,
//                     width: 85,
//                     child: getLenderDetailsAssetURL(
//                         widget.offer.bankName, widget.offer.bankLogoURL),
//                   ),
//                   const SpacerWidget(
//                     width: 15,
//                   ),
//                   Expanded(
//                       child: Text(
//                     widget.offer.bankName,
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h3,
//                       fontWeight: AppFontWeights.bold,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   )),
//                   const SpacerWidget(
//                     width: 5,
//                   ),
//                   _selectingOffer
//                       ? Lottie.asset("assets/animations/loading_spinner.json",
//                           height: 30, width: 30)
//                       : Icon(
//                           Icons.arrow_forward_ios_sharp,
//                           size: 20,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.5),
//                         )
//                 ],
//               ),
//               const SpacerWidget(
//                 height: 23,
//               ),
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "Loan",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.5),
//                           ),
//                         ),
//                         const SpacerWidget(
//                           height: 4,
//                         ),
//                         Text(
//                           "₹ ${widget.offer.deposit}",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SpacerWidget(
//                     width: 8,
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "Interest",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.5),
//                           ),
//                         ),
//                         const SpacerWidget(
//                           height: 4,
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: widget.offer.interestRate,
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               color: Theme.of(context).colorScheme.onSurface,
//                               fontSize: AppFontSizes.h3,
//                               fontWeight: AppFontWeights.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SpacerWidget(
//                     width: 8,
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "Fee",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.5),
//                           ),
//                         ),
//                         const SpacerWidget(
//                           height: 4,
//                         ),
//                         Text(
//                           "₹ ${widget.offer.getNumericalValOrDefault(widget.offer.applicationFee)}",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SpacerWidget(
//                 height: 21,
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 8,
//                 ),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.surface,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Center(
//                   child: RichText(
//                     text: TextSpan(
//                       text: "Repay Loan of ",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         fontSize: AppFontSizes.body,
//                         fontWeight: AppFontWeights.normal,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: "₹ ${widget.offer.totalRepayment} ",
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onSurface,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.bold,
//                             fontFamily: fontFamily,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "in ",
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onSurface,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.normal,
//                             fontFamily: fontFamily,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "${widget.offer.tenure} ",
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onSurface,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.bold,
//                             fontFamily: fontFamily,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
