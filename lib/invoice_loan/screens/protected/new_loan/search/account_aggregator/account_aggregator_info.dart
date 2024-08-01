// import 'package:blocsol_invoice_based_credit/screens/user/protected/new_loan/components/continue_button.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class AccountAggregatorInformation extends ConsumerWidget {
//   const AccountAggregatorInformation({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final _ = ref.watch(serverSentEventStateProvider);
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
//                   children: <Widget>[
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () async {
//                               HapticFeedback.mediumImpact();
//                               context.go(AppRoutes.msme_new_loan_process);
//                             },
//                             child: Icon(
//                               Icons.arrow_back_outlined,
//                               size: 25,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.65),
//                             ),
//                           ),
//                           Expanded(
//                             child: Container(),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               HapticFeedback.mediumImpact();
//                               context.go(AppRoutes.msme_raise_new_ticket);
//                             },
//                             child: Container(
//                               height: 25,
//                               width: 56,
//                               clipBehavior: Clip.antiAlias,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(18),
//                                 border: Border.all(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .primary
//                                       .withOpacity(0.75),
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Help?",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.extraBold,
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SpacerWidget(height: 35),
//                     Text(
//                       "Account Aggregator",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h1,
//                         fontWeight: AppFontWeights.extraBold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                       softWrap: true,
//                     ),
//                     const SpacerWidget(
//                       height: 5,
//                     ),
//                     Text(
//                       "A new way to share bank account statements digitally",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h3,
//                         fontWeight: AppFontWeights.normal,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         letterSpacing: 0.14,
//                       ),
//                       softWrap: true,
//                     ),
//                     const SpacerWidget(
//                       height: 20,
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.width * 0.75,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 25, vertical: 20),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context)
//                             .colorScheme
//                             .secondary
//                             .withOpacity(0.8),
//                       ),
//                       child: Image.asset(
//                         'assets/images/users/msme/new_loans/account_aggregator/account_aggregator_process.png',
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 15,
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.surface,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Container(
//                                 height: 15,
//                                 width: 15,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Icon(Icons.arrow_forward_rounded,
//                                       size: 12,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary),
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 width: 12,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   "Share bank statements digitally, securely and instantly",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h3,
//                                     fontWeight: AppFontWeights.normal,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface,
//                                     letterSpacing: 0.14,
//                                   ),
//                                   softWrap: true,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SpacerWidget(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Container(
//                                 height: 15,
//                                 width: 15,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Icon(Icons.arrow_forward_rounded,
//                                       size: 12,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary),
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 width: 12,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   "No branch visits needed",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h3,
//                                     fontWeight: AppFontWeights.normal,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface,
//                                     letterSpacing: 0.14,
//                                   ),
//                                   softWrap: true,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SpacerWidget(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Container(
//                                 height: 15,
//                                 width: 15,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Icon(Icons.arrow_forward_rounded,
//                                       size: 12,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary),
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 width: 12,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   "RBI licensed entities",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h3,
//                                     fontWeight: AppFontWeights.normal,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface,
//                                     letterSpacing: 0.14,
//                                   ),
//                                   softWrap: true,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SpacerWidget(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Container(
//                                 height: 15,
//                                 width: 15,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Icon(Icons.arrow_forward_rounded,
//                                       size: 12,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary),
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 width: 12,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   "Revoke consent at anytime",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h3,
//                                     fontWeight: AppFontWeights.normal,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface,
//                                     letterSpacing: 0.14,
//                                   ),
//                                   softWrap: true,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SpacerWidget(
//                             height: 15,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: SizedBox(
//                   height: 120,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: width,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 8),
//                         color: Theme.of(context).colorScheme.secondary,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             RichText(
//                               text: TextSpan(
//                                 text: "Visit",
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface
//                                       .withOpacity(0.5),
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   letterSpacing: 0.14,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: " Sahamati ",
//                                     style: TextStyle(
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.medium,
//                                       letterSpacing: 0.14,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: "or",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface
//                                           .withOpacity(0.5),
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.medium,
//                                       letterSpacing: 0.14,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: " RBI ",
//                                     style: TextStyle(
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.medium,
//                                       letterSpacing: 0.14,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: "website to know more",
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface
//                                           .withOpacity(0.5),
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.medium,
//                                       letterSpacing: 0.14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       ContinueButton(
//                         onPressed: () {
//                           context.go(
//                               AppRoutes
//                                   .msme_new_loan_account_aggregator_bank_select,
//                               extra: false);
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
