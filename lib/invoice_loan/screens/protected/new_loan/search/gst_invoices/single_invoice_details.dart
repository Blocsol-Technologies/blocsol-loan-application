// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/utils/loan_details.dart';
// import 'package:blocsol_invoice_based_credit/utils/functions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';

// class NewLoanSingleInvoiceDetailsScreen extends ConsumerWidget {
//   final Invoice invoice;

//   const NewLoanSingleInvoiceDetailsScreen({super.key, required this.invoice});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _ = ref.watch(serverSentEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Theme.of(context).colorScheme.surface,
//           resizeToAvoidBottomInset: false,
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     HapticFeedback.mediumImpact();
//                     context.go(AppRoutes.msme_new_loan_invoice_select);
//                   },
//                   child: Icon(
//                     Icons.arrow_back_outlined,
//                     size: 30,
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onSurface
//                         .withOpacity(0.65),
//                   ),
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Center(
//                     child: Lottie.asset(
//                       "assets/animations/invoices.json",
//                       height: 300,
//                     ),
//                   ),
//                 ),
//                 // 1. Loan Details
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "1. Invoice Details",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h1,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onPrimary,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 23),
//                 // Invoice Company Name
//                 Container(
//                   height: 95,
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.2),
//                               width: 1))),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "Company Name",
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.4),
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.medium,
//                           fontFamily: fontFamily,
//                           letterSpacing: 0.14,
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           SizedBox(
//                             width: 150,
//                             child: Text(invoice.companyName,
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.bold,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.165,
//                                 ),
//                                 textAlign: TextAlign.right,
//                                 softWrap: true),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Invoice Company GST
//                 Container(
//                   height: 95,
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.2),
//                               width: 1))),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "Company GST",
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.4),
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.medium,
//                           fontFamily: fontFamily,
//                           letterSpacing: 0.14,
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           SizedBox(
//                             width: 150,
//                             child: Text(invoice.companyGST,
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.bold,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.165,
//                                 ),
//                                 textAlign: TextAlign.right,
//                                 softWrap: true),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Invoice Amount
//                 Container(
//                   height: 95,
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.2),
//                               width: 1))),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "Invoice Amount",
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.4),
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.medium,
//                           fontFamily: fontFamily,
//                           letterSpacing: 0.14,
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           SizedBox(
//                             width: 150,
//                             child: Text("₹ ${invoice.amount}",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.bold,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.165,
//                                 ),
//                                 textAlign: TextAlign.right,
//                                 softWrap: true),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Invoice Number
//                 Container(
//                   height: 95,
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.2),
//                               width: 1))),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "Invoice Number",
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.4),
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.medium,
//                           fontFamily: fontFamily,
//                           letterSpacing: 0.14,
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           SizedBox(
//                             width: 150,
//                             child: Text(
//                                 invoice.irn.isNotEmpty
//                                     ? invoice.irn
//                                     : invoice.inum,
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.bold,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.165,
//                                 ),
//                                 textAlign: TextAlign.right,
//                                 softWrap: true),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Invoice Date
//                 Container(
//                   height: 95,
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.2),
//                               width: 1))),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "Date",
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.4),
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.medium,
//                           fontFamily: fontFamily,
//                           letterSpacing: 0.14,
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           SizedBox(
//                             width: 150,
//                             child: Text(
//                                 invoice.irn.isNotEmpty
//                                     ? invoice.irngendate
//                                     : invoice.idt,
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.bold,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.165,
//                                 ),
//                                 textAlign: TextAlign.right,
//                                 softWrap: true),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Invoice State
//                 Container(
//                   height: 95,
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.2),
//                               width: 1))),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "State",
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.4),
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.medium,
//                           fontFamily: fontFamily,
//                           letterSpacing: 0.14,
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           SizedBox(
//                             width: 150,
//                             child: Text(getStateNameFromStateCode(invoice.pos),
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.bold,
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.165,
//                                 ),
//                                 textAlign: TextAlign.right,
//                                 softWrap: true),
//                           ),
//                         ],
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
