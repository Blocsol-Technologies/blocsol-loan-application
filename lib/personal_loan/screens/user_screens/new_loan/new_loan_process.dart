// import 'dart:async';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/account_details/borrower_account_details_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/new_loan/new_loan_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class PCNewLoanProcessScreen extends ConsumerStatefulWidget {
//   const PCNewLoanProcessScreen({super.key});

//   @override
//   ConsumerState<PCNewLoanProcessScreen> createState() =>
//       _PCNewLoanProcessScreenState();
// }

// class _PCNewLoanProcessScreenState
//     extends ConsumerState<PCNewLoanProcessScreen> {
//   late Timer _timer;

//   void _handleNotificationBellPress() {
//     print("Notification Bell Pressed");
//   }

//   void _performLoanAction() async {
//     HapticFeedback.heavyImpact();

//     final currentState = ref.read(newLoanStateProvider).currentState;

//     switch (currentState) {
//       case NewLoanProgress.started:
//         context.go(AppRoutes.pc_new_loan_data_consent);
//         break;
//       case NewLoanProgress.formGenerated:
//         context.go(AppRoutes.pc_new_loan_account_aggregator_info);
//         break;
//       case NewLoanProgress.bankConsent:
//         context.go(AppRoutes.pc_new_loan_offers_home);
//         break;
//       case NewLoanProgress.loanOfferSelect:
//         context.go(AppRoutes.pc_new_loan_aadhar_kyc_webview);
//         break;
//       case NewLoanProgress.aadharKYC:
//         context.go(AppRoutes.pc_new_loan_share_bank_details);
//         break;

//       case NewLoanProgress.bankAccountDetails:
//         context.go(AppRoutes.pc_new_loan_repayment_setup);
//         break;
//       case NewLoanProgress.repaymentSetup:
//         context.go(AppRoutes.pc_new_loan_agreement);
//         break;
//       case NewLoanProgress.loanAgreement:
//         context.go(AppRoutes.pc_new_loan_final_processing_screen);
//         break;
//       case NewLoanProgress.monitoringConsent:
//         context.go(AppRoutes.pc_new_loan_final_disbursed_screen);
//         break;
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
//     }
//   }

//   void startTimer() {
//     _timer = Timer.periodic(const Duration(minutes: 60), (timer) {
//       ref.read(newLoanStateProvider.notifier).reset();
//     });
//   }

//   @override
//   void initState() {
//     startTimer();

//     int lastOfferFetchtime = ref.read(newLoanStateProvider).offersFetchTime;

//     if (lastOfferFetchtime != 0 &&
//         ((DateTime.now().millisecondsSinceEpoch ~/ 1000) - lastOfferFetchtime >
//             900)) {
//       ref.read(newLoanStateProvider.notifier).reset();
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
//     final borrowerAccountDetailsRef =
//         ref.watch(borrowerAccountDetailsStateProvider);

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Stack(
//               children: [
//                 Container(
//                   width: width,
//                   height: RelativeSize.height(258, height),
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
//                                 context.go(AppRoutes.pc_home_screen);
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
//                                       context.go(AppRoutes.pc_raise_new_ticket);
//                                     },
//                                     child: Container(
//                                       height: 28,
//                                       width: 28,
//                                       clipBehavior: Clip.antiAlias,
//                                       decoration: const BoxDecoration(
//                                         color: Colors.transparent,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Center(
//                                         child: Icon(
//                                           Icons.support_agent_outlined,
//                                           size: 22,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onPrimary,
//                                         ),
//                                       ),
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
//                         height: 30,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Loan Process",
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
//                               "One-time registration. Online loan application. No document upload needed.",
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
//                       const SpacerWidget(
//                         height: 30,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: _SharePersonalDetails(
//                             loanProgressState: loanStateRef.currentState),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: _SelectOffer(
//                             loanProgressState: loanStateRef.currentState),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: _CompleteKYC(
//                             loanProgressState: loanStateRef.currentState),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: _BankAccount(
//                             loanProgressState: loanStateRef.currentState),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: _RepaymentSetup(
//                             loanProgressState: loanStateRef.currentState),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: _LoanAgreement(
//                             loanProgressState: loanStateRef.currentState),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: _LoanDisbursed(
//                             loanProgressState: loanStateRef.currentState),
//                       ),
//                       const SpacerWidget(
//                         height: 35,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               HapticFeedback.heavyImpact();
//                               _performLoanAction();
//                             },
//                             child: Container(
//                               height: RelativeSize.height(40, height),
//                               width: RelativeSize.width(252, width),
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Continue",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.medium,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
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

// class _SharePersonalDetails extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const _SharePersonalDetails({required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return loanProgressState.index < NewLoanProgress.bankConsent.index
//         ? Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(15, height),
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(20, height)),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primaryContainer
//                         .withOpacity(0.2),
//                     border: Border.all(
//                       width: 1,
//                       color: Theme.of(context).colorScheme.primaryContainer,
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
//                           color: Theme.of(context).colorScheme.onPrimary,
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
//                                       NewLoanProgress.formGenerated.index
//                                   ? Theme.of(context)
//                                       .colorScheme
//                                       .primaryContainer
//                                   : Theme.of(context).colorScheme.background,
//                               border: Border.all(
//                                 width: 1,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .primaryContainer,
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.formGenerated.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimaryContainer,
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
//                                             .onBackground
//                                             .withOpacity(0.75),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 20,
//                           ),
//                           Text(
//                             "Share Personal Details",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               letterSpacing: 0.21,
//                               color: loanProgressState.index ==
//                                       NewLoanProgress.started.index
//                                   ? Theme.of(context).colorScheme.onPrimary
//                                   : loanProgressState.index ==
//                                           NewLoanProgress.formGenerated.index
//                                       ? Theme.of(context).colorScheme.onPrimary
//                                       : const Color.fromRGBO(144, 144, 144, 1),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 15,
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
//                                   ? Theme.of(context)
//                                       .colorScheme
//                                       .primaryContainer
//                                   : Theme.of(context).colorScheme.background,
//                               border: Border.all(
//                                 width: 1,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .primaryContainer,
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.bankConsent.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimaryContainer,
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
//                                             .onBackground
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
//                               letterSpacing: 0.21,
//                               color: loanProgressState.index ==
//                                       NewLoanProgress.formGenerated.index
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
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.background,
//                       border: Border.all(
//                         width: 1,
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "1",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onBackground,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
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
//                     "Request a Loan",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.body,
//                       fontWeight: loanProgressState.index >=
//                               NewLoanProgress.bankConsent.index
//                           ? AppFontWeights.bold
//                           : AppFontWeights.medium,
//                       color: loanProgressState.index >=
//                               NewLoanProgress.bankConsent.index
//                           ? Theme.of(context).colorScheme.background
//                           : Theme.of(context)
//                               .colorScheme
//                               .onBackground
//                               .withOpacity(0.7),
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 5,
//                   child: Container(
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: loanProgressState.index >=
//                               NewLoanProgress.bankConsent.index
//                           ? Theme.of(context).colorScheme.primaryContainer
//                           : Theme.of(context).colorScheme.scrim,
//                     ),
//                     child: Center(
//                       child: loanProgressState.index >=
//                               NewLoanProgress.bankConsent.index
//                           ? Icon(
//                               Icons.check,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onPrimaryContainer,
//                               size: 15,
//                             )
//                           : Text(
//                               "1",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 color: Theme.of(context).colorScheme.background,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }

// class _SelectOffer extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const _SelectOffer({required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return loanProgressState.index >= NewLoanProgress.bankConsent.index &&
//             loanProgressState.index < NewLoanProgress.loanOfferSelect.index
//         ? Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(15, height),
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(20, height)),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primaryContainer
//                         .withOpacity(0.2),
//                     border: Border.all(
//                       width: 1,
//                       color: Theme.of(context).colorScheme.primaryContainer,
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
//                           color: Theme.of(context).colorScheme.onBackground,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 12,
//                       ),
//                       Text(
//                         "Select Loan offer from Lender",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.21,
//                           color: loanProgressState.index ==
//                                   NewLoanProgress.started.index
//                               ? const Color.fromRGBO(34, 34, 34, 1)
//                               : loanProgressState.index ==
//                                       NewLoanProgress.formGenerated.index
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
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.background,
//                       border: Border.all(
//                         width: 1,
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "2",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onBackground,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
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
//                     "Select Offer",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.body,
//                       fontWeight: loanProgressState.index >=
//                               NewLoanProgress.bankConsent.index
//                           ? AppFontWeights.bold
//                           : AppFontWeights.medium,
//                       color: loanProgressState.index >=
//                               NewLoanProgress.bankConsent.index
//                           ? Theme.of(context).colorScheme.primary
//                           : Theme.of(context)
//                               .colorScheme
//                               .onBackground
//                               .withOpacity(0.7),
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 5,
//                   child: Container(
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: loanProgressState.index >=
//                               NewLoanProgress.loanOfferSelect.index
//                           ? Theme.of(context).colorScheme.primaryContainer
//                           : Theme.of(context).colorScheme.scrim,
//                     ),
//                     child: Center(
//                       child: loanProgressState.index >=
//                               NewLoanProgress.loanOfferSelect.index
//                           ? Icon(
//                               Icons.check,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onPrimaryContainer,
//                               size: 15,
//                             )
//                           : Text(
//                               "2",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.bold,
//                                 color: Theme.of(context).colorScheme.background,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }

// class _CompleteKYC extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const _CompleteKYC({required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return loanProgressState.index >= NewLoanProgress.loanOfferSelect.index &&
//             loanProgressState.index < NewLoanProgress.aadharKYC.index
//         ? Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(15, height),
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(20, height)),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primaryContainer
//                         .withOpacity(0.2),
//                     border: Border.all(
//                       width: 1,
//                       color: Theme.of(context).colorScheme.primaryContainer,
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
//                           color: Theme.of(context).colorScheme.onBackground,
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
//                                   ? Theme.of(context)
//                                       .colorScheme
//                                       .primaryContainer
//                                   : Theme.of(context).colorScheme.background,
//                               border: Border.all(
//                                 width: 1,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .primaryContainer,
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.aadharKYC.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimaryContainer,
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
//                                             .onBackground
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
//                               letterSpacing: 0.21,
//                               color: loanProgressState.index ==
//                                       NewLoanProgress.formGenerated.index
//                                   ? const Color.fromRGBO(34, 34, 34, 1)
//                                   : loanProgressState.index >=
//                                           NewLoanProgress.aadharKYC.index
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
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.background,
//                       border: Border.all(
//                         width: 1,
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "3",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onBackground,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : _InactiveStep(
//             step: "Complete KYC",
//             stepNumber: "3",
//             stepCompleted:
//                 loanProgressState.index >= NewLoanProgress.aadharKYC.index,
//           );
//   }
// }

// class _BankAccount extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const _BankAccount({required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return loanProgressState.index >= NewLoanProgress.aadharKYC.index &&
//             loanProgressState.index < NewLoanProgress.bankAccountDetails.index
//         ? Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(15, height),
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(20, height)),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primaryContainer
//                         .withOpacity(0.2),
//                     border: Border.all(
//                       width: 1,
//                       color: Theme.of(context).colorScheme.primaryContainer,
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
//                           color: Theme.of(context).colorScheme.onBackground,
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
//                           letterSpacing: 0.21,
//                           color: loanProgressState.index ==
//                                   NewLoanProgress.bankAccountDetails.index
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
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.background,
//                       border: Border.all(
//                         width: 1,
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "4",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onBackground,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : _InactiveStep(
//             step: "Share Loan Deposit Account",
//             stepNumber: "4",
//             stepCompleted: loanProgressState.index >=
//                 NewLoanProgress.bankAccountDetails.index,
//           );
//   }
// }

// class _RepaymentSetup extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const _RepaymentSetup({required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return loanProgressState.index >=
//                 NewLoanProgress.bankAccountDetails.index &&
//             loanProgressState.index < NewLoanProgress.repaymentSetup.index
//         ? Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(15, height),
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(20, height)),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primaryContainer
//                         .withOpacity(0.2),
//                     border: Border.all(
//                       width: 1,
//                       color: Theme.of(context).colorScheme.primaryContainer,
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
//                           color: Theme.of(context).colorScheme.onBackground,
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
//                           letterSpacing: 0.21,
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
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.background,
//                       border: Border.all(
//                         width: 1,
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "5",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onBackground,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : _InactiveStep(
//             step: "Setup Repayment",
//             stepNumber: "5",
//             stepCompleted:
//                 loanProgressState.index >= NewLoanProgress.repaymentSetup.index,
//           );
//   }
// }

// class _LoanAgreement extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const _LoanAgreement({required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return loanProgressState.index >= NewLoanProgress.repaymentSetup.index &&
//             loanProgressState.index < NewLoanProgress.disbursed.index
//         ? Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(15, height),
//                       RelativeSize.width(28, width),
//                       RelativeSize.height(20, height)),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primaryContainer
//                         .withOpacity(0.2),
//                     border: Border.all(
//                       width: 1,
//                       color: Theme.of(context).colorScheme.primaryContainer,
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
//                           color: Theme.of(context).colorScheme.onBackground,
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
//                                   ? Theme.of(context)
//                                       .colorScheme
//                                       .primaryContainer
//                                   : Theme.of(context).colorScheme.background,
//                               border: Border.all(
//                                 width: 1,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .primaryContainer,
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.loanAgreement.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimaryContainer,
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
//                                             .onBackground
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
//                               letterSpacing: 0.21,
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
//                         height: 15,
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
//                                   ? Theme.of(context)
//                                       .colorScheme
//                                       .primaryContainer
//                                   : Theme.of(context).colorScheme.background,
//                               border: Border.all(
//                                 width: 1,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .primaryContainer,
//                               ),
//                             ),
//                             child: Center(
//                               child: loanProgressState.index >=
//                                       NewLoanProgress.monitoringConsent.index
//                                   ? Icon(
//                                       Icons.check,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimaryContainer,
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
//                                             .onBackground
//                                             .withOpacity(0.75),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 20,
//                           ),
//                           Expanded(
//                             child: Text(
//                               "Provide consent for Monitoring",
//                               softWrap: true,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.bold,
//                                 letterSpacing: 0.21,
//                                 color: loanProgressState.index ==
//                                         NewLoanProgress.loanAgreement.index
//                                     ? const Color.fromRGBO(34, 34, 34, 1)
//                                     : loanProgressState.index >=
//                                             NewLoanProgress
//                                                 .monitoringConsent.index
//                                         ? Theme.of(context).colorScheme.primary
//                                         : const Color.fromRGBO(
//                                             144, 144, 144, 1),
//                               ),
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
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.background,
//                       border: Border.all(
//                         width: 1,
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "6",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onBackground,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : _InactiveStep(
//             step: "Loan agreement",
//             stepNumber: "6",
//             stepCompleted: loanProgressState.index >=
//                 NewLoanProgress.monitoringConsent.index,
//           );
//   }
// }

// class _LoanDisbursed extends StatelessWidget {
//   final NewLoanProgress loanProgressState;

//   const _LoanDisbursed({required this.loanProgressState});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return loanProgressState.index == NewLoanProgress.disbursed.index
//         ? Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: RelativeSize.width(30, width),
//                       vertical: RelativeSize.height(15, height)),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primaryContainer
//                         .withOpacity(0.8),
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(
//                       width: 1,
//                       color: Theme.of(context).colorScheme.primaryContainer,
//                     ),
//                   ),
//                   child: Text(
//                     "LOAN SANCTIONED",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.body,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onPrimaryContainer,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 5,
//                   child: Container(
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Theme.of(context).colorScheme.primaryContainer),
//                     child: Center(
//                       child: Icon(
//                         Icons.check,
//                         color: Theme.of(context).colorScheme.onPrimaryContainer,
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
//             padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
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
//                     "LOAN DISBURSED",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.body,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onBackground,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: -18,
//                   top: 5,
//                   child: Container(
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context)
//                           .colorScheme
//                           .onBackground
//                           .withOpacity(0.6),
//                     ),
//                     child: Center(
//                       child: Icon(
//                         Icons.currency_rupee_sharp,
//                         color: Theme.of(context).colorScheme.background,
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

// class _InactiveStep extends StatelessWidget {
//   final String step;
//   final String stepNumber;
//   final bool stepCompleted;

//   const _InactiveStep(
//       {required this.step,
//       required this.stepNumber,
//       this.stepCompleted = false});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
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
//                 color: Theme.of(context).colorScheme.scrim,
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
//                         .onBackground
//                         .withOpacity(0.7),
//                 letterSpacing: 0.2,
//               ),
//             ),
//           ),
//           Positioned(
//             left: -18,
//             top: 5,
//             child: Container(
//               height: 35,
//               width: 35,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: stepCompleted
//                     ? Theme.of(context).colorScheme.primaryContainer
//                     : Theme.of(context).colorScheme.scrim,
//               ),
//               child: Center(
//                 child: stepCompleted
//                     ? Icon(
//                         Icons.check,
//                         color: Theme.of(context).colorScheme.onPrimaryContainer,
//                         size: 15,
//                       )
//                     : Text(
//                         stepNumber,
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.background,
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
