// import 'dart:async';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/new_loan/components/continue_button.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/new_loan/search/gst_invoices/gst_consent_modal_bottom_sheet.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state_data.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class NewLoanProcess extends ConsumerStatefulWidget {
//   const NewLoanProcess({super.key});

//   @override
//   ConsumerState<NewLoanProcess> createState() => _NewLoanProcessState();
// }

// class _NewLoanProcessState extends ConsumerState<NewLoanProcess> {
//   late Timer _timer;

//   void _performLoanAction() async {
//     HapticFeedback.heavyImpact();

//     final currentState = ref.read(newLoanStateProvider).currentState;

//     switch (currentState) {
//       case NewLoanProgress.started:
//         showModalBottomSheet(
//             isScrollControlled: true,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(20),
//               ),
//             ),
//             backgroundColor: Theme.of(context).colorScheme.surface,
//             context: context,
//             builder: (context) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom),
//                 child: const GstConsentModalBottomSheet(),
//               );
//             });
//         return;
//       case NewLoanProgress.invoiceSelect:
//         context.go(AppRoutes.msme_new_loan_account_aggregator_info);
//         return;
//       case NewLoanProgress.bankConsent:
//         context.go(AppRoutes.msme_new_loan_invoice_offer_select);
//         return;
//       case NewLoanProgress.loanOfferSelect:
//         context.go(AppRoutes.msme_new_loan_aadhar_kyc);
//         return;
//       case NewLoanProgress.aadharKYC:
//         context.go(AppRoutes.msme_new_loan_udyam_kyc);
//         return;
//       case NewLoanProgress.udyamKYC:
//         context.go(AppRoutes.msme_new_loan_bank_account_details);
//         return;
//       case NewLoanProgress.bankAccountDetails:
//         context.go(AppRoutes.msme_new_loan_repayment_setup);
//         return;
//       case NewLoanProgress.repaymentSetup:
//         context.go(AppRoutes.msme_new_loan_agreement);
//         return;
//       case NewLoanProgress.loanAgreement:
//         context.go(AppRoutes.msme_new_loan_final_processing);
//         return;
//       case NewLoanProgress.monitoringConsent:
//         context.go(AppRoutes.msme_new_loan_final_details);
//         return;
//       default:
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: 'On Snap!',
//             message: "Invalid State! Contact Support",
//             contentType: ContentType.failure,
//           ),
//         );

//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(snackBar);
//         return;
//     }
//   }

//   void startTimer() {
//     _timer = Timer.periodic(const Duration(minutes: 15), (timer) {
//       ref.read(newLoanStateProvider.notifier).reset();
//     });
//   }

//   @override
//   void initState() {
//     startTimer();

//     int lastOfferFetchtime =
//         ref.read(newLoanStateProvider).invoiceWithOffersFetchTime;

//     if (lastOfferFetchtime != 0 &&
//         ((DateTime.now().millisecondsSinceEpoch ~/ 1000) - lastOfferFetchtime >
//             900)) {
//       // ref.read(newLoanStateProvider.notifier).reset();
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final loanStateRef = ref.watch(newLoanStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);
//     ref.watch(loanEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: Stack(
//             children: [
//               SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 padding: EdgeInsets.fromLTRB(
//                     RelativeSize.width(20, width),
//                     RelativeSize.height(20, height),
//                     RelativeSize.width(20, width),
//                     RelativeSize.height(50, height)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: GestureDetector(
//                         onTap: () async {
//                           HapticFeedback.mediumImpact();
//                           context.go(AppRoutes.msme_home_screen);
//                         },
//                         child: Icon(
//                           Icons.arrow_back_rounded,
//                           size: 25,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.65),
//                         ),
//                       ),
//                     ),
//                     const SpacerWidget(height: 32),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(15, width)),
//                       child: Text(
//                         "Loan Process",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h1,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                         softWrap: true,
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 5,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(15, width)),
//                       child: Text(
//                         "One-time registration. Online loan application. No document upload needed.",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.normal,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           letterSpacing: 0.14,
//                         ),
//                         softWrap: true,
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 22,
//                     ),
//                     SearchPhase(loanProgressState: loanStateRef.currentState),
//                     const SpacerWidget(
//                       height: 12,
//                     ),
//                     SelectOffer(loanProgressState: loanStateRef.currentState),
//                     const SpacerWidget(
//                       height: 12,
//                     ),
//                     CompleteKYC(loanProgressState: loanStateRef.currentState),
//                     const SpacerWidget(
//                       height: 12,
//                     ),
//                     ShareBankDetails(
//                         loanProgressState: loanStateRef.currentState),
//                     const SpacerWidget(
//                       height: 12,
//                     ),
//                     RepaymentSetup(
//                         loanProgressState: loanStateRef.currentState),
//                     const SpacerWidget(
//                       height: 12,
//                     ),
//                     LoanAgreement(loanProgressState: loanStateRef.currentState),
//                     const SpacerWidget(
//                       height: 12,
//                     ),
//                     FinalStep(loanProgressState: loanStateRef.currentState),
//                     const SpacerWidget(
//                       height: 12,
//                     ),
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: SizedBox(
//                   height: RelativeSize.height(60, height),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ContinueButton(
//                         onPressed: () {
//                           _performLoanAction();
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SearchPhase extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const SearchPhase({super.key, required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     return loanProgressState.index < NewLoanProgress.bankConsent.index
//         ? Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 20),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.fromLTRB(28, 15, 28, 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context).colorScheme.secondary,
//                     border: Border.all(
//                       width: 1,
//                       color: const Color.fromRGBO(0, 165, 236, 1),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Request a Loan",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: loanProgressState.index >=
//                                       NewLoanProgress.invoiceSelect.index
//                                   ? Theme.of(context).colorScheme.primary
//                                   : Theme.of(context).colorScheme.surface,
//                               border: Border.all(
//                                 width: 1,
//                                 color: const Color.fromRGBO(0, 165, 236, 1),
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.invoiceSelect.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                       size: 10,
//                                     )
//                                   : Text(
//                                       "1",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface
//                                             .withOpacity(0.75),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 20,
//                           ),
//                           Text(
//                             "Share GST Invoices",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               letterSpacing: 0.11,
//                               color: loanProgressState.index ==
//                                       NewLoanProgress.started.index
//                                   ? const Color.fromRGBO(34, 34, 34, 1)
//                                   : loanProgressState.index ==
//                                           NewLoanProgress.invoiceSelect.index
//                                       ? Theme.of(context).colorScheme.primary
//                                       : const Color.fromRGBO(144, 144, 144, 1),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: loanProgressState.index >=
//                                       NewLoanProgress.bankConsent.index
//                                   ? Theme.of(context).colorScheme.primary
//                                   : Theme.of(context).colorScheme.surface,
//                               border: Border.all(
//                                 width: 1,
//                                 color: const Color.fromRGBO(0, 165, 236, 1),
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.bankConsent.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                       size: 10,
//                                     )
//                                   : Text(
//                                       "2",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface
//                                             .withOpacity(0.75),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 20,
//                           ),
//                           Text(
//                             "Give consent for bank data",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               letterSpacing: 0.11,
//                               color: loanProgressState.index ==
//                                       NewLoanProgress.invoiceSelect.index
//                                   ? const Color.fromRGBO(34, 34, 34, 1)
//                                   : loanProgressState.index >=
//                                           NewLoanProgress.bankConsent.index
//                                       ? Theme.of(context).colorScheme.primary
//                                       : const Color.fromRGBO(144, 144, 144, 1),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 8,
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.surface,
//                       border: Border.all(
//                         width: 1,
//                         color: const Color.fromRGBO(0, 115, 165, 1),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "1",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : InactiveStep(
//             step: "Request a Loan",
//             stepNumber: "1",
//             stepCompleted:
//                 loanProgressState.index >= NewLoanProgress.bankConsent.index,
//           );
//   }
// }

// class SelectOffer extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const SelectOffer({super.key, required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     return loanProgressState.index >= NewLoanProgress.bankConsent.index &&
//             loanProgressState.index < NewLoanProgress.loanOfferSelect.index
//         ? Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 20),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.fromLTRB(28, 15, 28, 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context).colorScheme.secondary,
//                     border: Border.all(
//                       width: 1,
//                       color: const Color.fromRGBO(0, 165, 236, 1),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Select Offers",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Text(
//                         "Share GST Invoices on which finance is required",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.11,
//                           color: loanProgressState.index ==
//                                   NewLoanProgress.started.index
//                               ? const Color.fromRGBO(34, 34, 34, 1)
//                               : loanProgressState.index ==
//                                       NewLoanProgress.invoiceSelect.index
//                                   ? Theme.of(context).colorScheme.primary
//                                   : const Color.fromRGBO(144, 144, 144, 1),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 8,
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.surface,
//                       border: Border.all(
//                         width: 1,
//                         color: const Color.fromRGBO(0, 115, 165, 1),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "2",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : InactiveStep(
//             step: "Select Offers",
//             stepNumber: "2",
//             stepCompleted:
//                 loanProgressState.index >= NewLoanProgress.bankConsent.index,
//           );
//   }
// }

// class CompleteKYC extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const CompleteKYC({super.key, required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     return loanProgressState.index >= NewLoanProgress.loanOfferSelect.index &&
//             loanProgressState.index < NewLoanProgress.udyamKYC.index
//         ? Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 20),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.fromLTRB(28, 15, 28, 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context).colorScheme.secondary,
//                     border: Border.all(
//                       width: 1,
//                       color: const Color.fromRGBO(0, 165, 236, 1),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Complete KYC",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: loanProgressState.index >=
//                                       NewLoanProgress.aadharKYC.index
//                                   ? Theme.of(context).colorScheme.primary
//                                   : Theme.of(context).colorScheme.surface,
//                               border: Border.all(
//                                 width: 1,
//                                 color: const Color.fromRGBO(0, 165, 236, 1),
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.aadharKYC.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                       size: 10,
//                                     )
//                                   : Text(
//                                       "1",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface
//                                             .withOpacity(0.75),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 20,
//                           ),
//                           Text(
//                             "Aadhar KYC",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               letterSpacing: 0.11,
//                               color: loanProgressState.index ==
//                                       NewLoanProgress.invoiceSelect.index
//                                   ? const Color.fromRGBO(34, 34, 34, 1)
//                                   : loanProgressState.index >=
//                                           NewLoanProgress.aadharKYC.index
//                                       ? Theme.of(context).colorScheme.primary
//                                       : const Color.fromRGBO(144, 144, 144, 1),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: loanProgressState.index >=
//                                       NewLoanProgress.udyamKYC.index
//                                   ? Theme.of(context).colorScheme.primary
//                                   : Theme.of(context).colorScheme.surface,
//                               border: Border.all(
//                                 width: 1,
//                                 color: const Color.fromRGBO(0, 165, 236, 1),
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.udyamKYC.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                       size: 10,
//                                     )
//                                   : Text(
//                                       "2",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface
//                                             .withOpacity(0.75),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 20,
//                           ),
//                           Text(
//                             "Udyam KYC",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               letterSpacing: 0.11,
//                               color: loanProgressState.index ==
//                                       NewLoanProgress.aadharKYC.index
//                                   ? const Color.fromRGBO(34, 34, 34, 1)
//                                   : loanProgressState.index >=
//                                           NewLoanProgress.udyamKYC.index
//                                       ? Theme.of(context).colorScheme.primary
//                                       : const Color.fromRGBO(144, 144, 144, 1),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 8,
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.surface,
//                       border: Border.all(
//                         width: 1,
//                         color: const Color.fromRGBO(0, 115, 165, 1),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "3",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : InactiveStep(
//             step: "Complete KYC",
//             stepNumber: "3",
//             stepCompleted:
//                 loanProgressState.index >= NewLoanProgress.udyamKYC.index,
//           );
//   }
// }

// class ShareBankDetails extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const ShareBankDetails({super.key, required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     return loanProgressState.index >= NewLoanProgress.udyamKYC.index &&
//             loanProgressState.index < NewLoanProgress.bankAccountDetails.index
//         ? Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 20),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.fromLTRB(28, 15, 28, 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context).colorScheme.secondary,
//                     border: Border.all(
//                       width: 1,
//                       color: const Color.fromRGBO(0, 165, 236, 1),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Share Loan Deposit Account",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Text(
//                         "Select a deposit account for the loan application",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.11,
//                           color: loanProgressState.index ==
//                                   NewLoanProgress.udyamKYC.index
//                               ? const Color.fromRGBO(34, 34, 34, 1)
//                               : loanProgressState.index >=
//                                       NewLoanProgress.bankAccountDetails.index
//                                   ? Theme.of(context).colorScheme.primary
//                                   : const Color.fromRGBO(144, 144, 144, 1),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 8,
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.surface,
//                       border: Border.all(
//                         width: 1,
//                         color: const Color.fromRGBO(0, 115, 165, 1),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "4",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : InactiveStep(
//             step: "Share Loan Deposit Account",
//             stepNumber: "4",
//             stepCompleted: loanProgressState.index >=
//                 NewLoanProgress.bankAccountDetails.index,
//           );
//   }
// }

// class RepaymentSetup extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const RepaymentSetup({super.key, required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     return loanProgressState.index >=
//                 NewLoanProgress.bankAccountDetails.index &&
//             loanProgressState.index < NewLoanProgress.repaymentSetup.index
//         ? Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 20),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.fromLTRB(28, 15, 28, 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context).colorScheme.secondary,
//                     border: Border.all(
//                       width: 1,
//                       color: const Color.fromRGBO(0, 165, 236, 1),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Setup Repayment",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Text(
//                         "Complete repayment setup for the loan application",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.11,
//                           color: loanProgressState.index ==
//                                   NewLoanProgress.bankAccountDetails.index
//                               ? const Color.fromRGBO(34, 34, 34, 1)
//                               : loanProgressState.index >=
//                                       NewLoanProgress.repaymentSetup.index
//                                   ? Theme.of(context).colorScheme.primary
//                                   : const Color.fromRGBO(144, 144, 144, 1),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 8,
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.surface,
//                       border: Border.all(
//                         width: 1,
//                         color: const Color.fromRGBO(0, 115, 165, 1),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "5",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : InactiveStep(
//             step: "Setup Repayment",
//             stepNumber: "5",
//             stepCompleted:
//                 loanProgressState.index >= NewLoanProgress.repaymentSetup.index,
//           );
//   }
// }

// class LoanAgreement extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const LoanAgreement({super.key, required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     return loanProgressState.index >= NewLoanProgress.repaymentSetup.index &&
//             loanProgressState.index < NewLoanProgress.disbursed.index
//         ? Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 20),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.fromLTRB(28, 15, 28, 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context).colorScheme.secondary,
//                     border: Border.all(
//                       width: 1,
//                       color: const Color.fromRGBO(0, 165, 236, 1),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Loan agreement",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: loanProgressState.index >=
//                                       NewLoanProgress.loanAgreement.index
//                                   ? Theme.of(context).colorScheme.primary
//                                   : Theme.of(context).colorScheme.surface,
//                               border: Border.all(
//                                 width: 1,
//                                 color: const Color.fromRGBO(0, 165, 236, 1),
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.loanAgreement.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                       size: 10,
//                                     )
//                                   : Text(
//                                       "1",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface
//                                             .withOpacity(0.75),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 20,
//                           ),
//                           Text(
//                             "Loan agreement",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               letterSpacing: 0.11,
//                               color: loanProgressState.index ==
//                                       NewLoanProgress.repaymentSetup.index
//                                   ? const Color.fromRGBO(34, 34, 34, 1)
//                                   : loanProgressState.index >=
//                                           NewLoanProgress.loanAgreement.index
//                                       ? Theme.of(context).colorScheme.primary
//                                       : const Color.fromRGBO(144, 144, 144, 1),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: loanProgressState.index >=
//                                       NewLoanProgress.monitoringConsent.index
//                                   ? Theme.of(context).colorScheme.primary
//                                   : Theme.of(context).colorScheme.surface,
//                               border: Border.all(
//                                 width: 1,
//                                 color: const Color.fromRGBO(0, 165, 236, 1),
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.monitoringConsent.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                       size: 10,
//                                     )
//                                   : Text(
//                                       "2",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface
//                                             .withOpacity(0.75),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 20,
//                           ),
//                           Text(
//                             "Provide consent for Monitoring",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               letterSpacing: 0.11,
//                               color: loanProgressState.index ==
//                                       NewLoanProgress.loanAgreement.index
//                                   ? const Color.fromRGBO(34, 34, 34, 1)
//                                   : loanProgressState.index >=
//                                           NewLoanProgress
//                                               .monitoringConsent.index
//                                       ? Theme.of(context).colorScheme.primary
//                                       : const Color.fromRGBO(144, 144, 144, 1),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 8,
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.surface,
//                       border: Border.all(
//                         width: 1,
//                         color: const Color.fromRGBO(0, 115, 165, 1),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "6",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : InactiveStep(
//             step: "Loan agreement",
//             stepNumber: "6",
//             stepCompleted: loanProgressState.index >=
//                 NewLoanProgress.monitoringConsent.index,
//           );
//   }
// }

// class FinalStep extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const FinalStep({super.key, required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     return loanProgressState.index == NewLoanProgress.disbursed.index
//         ? Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 20),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                   decoration: BoxDecoration(
//                     color:
//                         Theme.of(context).colorScheme.surface.withOpacity(0.8),
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(
//                       width: 1,
//                       color: const Color.fromRGBO(0, 165, 236, 1),
//                     ),
//                   ),
//                   child: Text(
//                     "LOAN DISBURSED",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.body,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onSurface,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 5,
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Color.fromRGBO(0, 115, 165, 1),
//                     ),
//                     child: Center(
//                       child: Icon(
//                         Icons.check,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         size: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 20),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(
//                       width: 1,
//                       color: Theme.of(context).colorScheme.scrim,
//                     ),
//                   ),
//                   child: Text(
//                     "LOAN SANCTIONED",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.body,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onSurface,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 5,
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context)
//                           .colorScheme
//                           .onSurface
//                           .withOpacity(0.6),
//                     ),
//                     child: Center(
//                       child: Icon(
//                         Icons.currency_rupee_sharp,
//                         color: Theme.of(context).colorScheme.surface,
//                         size: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }

// class InactiveStep extends StatelessWidget {
//   final String step;
//   final String stepNumber;
//   final bool stepCompleted;

//   const InactiveStep(
//       {super.key,
//       required this.step,
//       required this.stepNumber,
//       this.stepCompleted = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.only(left: 20),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: <Widget>[
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4),
//               border: Border.all(
//                 width: 1,
//                 color: stepCompleted
//                     ? Theme.of(context).colorScheme.primary
//                     : Theme.of(context).colorScheme.scrim,
//               ),
//             ),
//             child: Text(
//               step,
//               style: TextStyle(
//                 fontFamily: fontFamily,
//                 fontSize: AppFontSizes.body,
//                 fontWeight:
//                     stepCompleted ? AppFontWeights.bold : AppFontWeights.medium,
//                 color: stepCompleted
//                     ? Theme.of(context).colorScheme.primary
//                     : Theme.of(context)
//                         .colorScheme
//                         .onSurface
//                         .withOpacity(0.7),
//                 letterSpacing: 0.2,
//               ),
//             ),
//           ),
//           Positioned(
//             left: -18,
//             top: 5,
//             child: Container(
//               height: 38,
//               width: 38,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: stepCompleted
//                     ? Theme.of(context).colorScheme.primary
//                     : Theme.of(context).colorScheme.scrim,
//               ),
//               child: Center(
//                 child: stepCompleted
//                     ? Icon(
//                         Icons.check,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         size: 15,
//                       )
//                     : Text(
//                         stepNumber,
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.surface,
//                         ),
//                       ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
