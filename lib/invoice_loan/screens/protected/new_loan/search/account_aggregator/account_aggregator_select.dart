// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/new_loan/components/continue_button.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/details/company_details_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/lender_utils.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class NewLoanAccountAggregatorSelect extends ConsumerStatefulWidget {
//   final List<AccountAggregatorInfo> accountAggregators;
//   final bool skipSubmittingForms;

//   const NewLoanAccountAggregatorSelect(
//       {super.key,
//       required this.accountAggregators,
//       required this.skipSubmittingForms});

//   @override
//   ConsumerState<NewLoanAccountAggregatorSelect> createState() =>
//       _NewLoanAccountAggregatorSelectScreenState();
// }

// class _NewLoanAccountAggregatorSelectScreenState
//     extends ConsumerState<NewLoanAccountAggregatorSelect> {
//   int _selectedAccountAggregatorIndex = -1;
//   final _cancelToken = CancelToken();

//   Future<void> _startAccountAggregatorFlow() async {
//     if (_selectedAccountAggregatorIndex == -1) {
//       return;
//     }

//     var phoneNum = ref.read(companyDetailsStateProvider).phone;

//     var selectedAa = widget.accountAggregators[_selectedAccountAggregatorIndex];

//     selectedAa.setId(phoneNum);

//     ref.read(newLoanStateProvider.notifier).setAADetails(selectedAa);

//     if (widget.skipSubmittingForms) {
//       var generateAccountAggregatorResponse = await ref
//           .read(newLoanStateProvider.notifier)
//           .generateAAURL(_cancelToken);

//       if (!mounted) return;

//       if (generateAccountAggregatorResponse.success) {
//         context.go(AppRoutes.msme_new_loan_account_aggregator_webview,
//             extra: generateAccountAggregatorResponse.data['url']);
//       } else {
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//               title: 'Error!',
//               message:
//                   "Unable to generate Account Aggregator Consent URL. Contact Support!!",
//               contentType: ContentType.failure),
//           duration: const Duration(seconds: 5),
//         );

//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(snackBar);

//         await Future.delayed(const Duration(seconds: 10));

//         if (mounted) {
//           context.go(AppRoutes.msme_new_loan_process);
//           return;
//         }
//       }
//     } else {
//       context.go(AppRoutes.msme_new_loan_submit_invoices_for_offers);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
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
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         GestureDetector(
//                           onTap: () async {
//                             HapticFeedback.mediumImpact();
//                             context.go(
//                                 AppRoutes
//                                     .msme_new_loan_account_aggregator_bank_select,
//                                 extra: widget.skipSubmittingForms);
//                           },
//                           child: Icon(
//                             Icons.arrow_back_outlined,
//                             size: 25,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.65),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             HapticFeedback.mediumImpact();
//                             context.go(AppRoutes.msme_raise_new_ticket);
//                           },
//                           child: Container(
//                             height: 25,
//                             width: 65,
//                             clipBehavior: Clip.antiAlias,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(18),
//                               border: Border.all(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .primary
//                                     .withOpacity(0.75),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Help?",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.extraBold,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SpacerWidget(height: 32),
//                     Text(
//                       "Select Account Aggregator",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h1,
//                         fontWeight: AppFontWeights.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                       softWrap: true,
//                     ),
//                     const SpacerWidget(
//                       height: 10,
//                     ),
//                     Text(
//                       "Account will be created for you if you dont have one already!",
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
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: widget.accountAggregators.length,
//                       itemBuilder: (ctx, index) {
//                         return Container(
//                           width: MediaQuery.of(context).size.width,
//                           decoration: BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     width: 1.5,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface
//                                         .withOpacity(0.1))),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 0, vertical: 25),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               SizedBox(
//                                 height: 40,
//                                 child: Image.asset(
//                                   widget.accountAggregators[index].assetPath,
//                                   fit: BoxFit
//                                       .contain, // or BoxFit.contain based on your requirement
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 width: 15,
//                               ),
//                               Text(
//                                 widget.accountAggregators[index].name,
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: <Widget>[
//                                     Radio(
//                                       value: index,
//                                       groupValue:
//                                           _selectedAccountAggregatorIndex,
//                                       onChanged: (int? value) {
//                                         setState(() {
//                                           _selectedAccountAggregatorIndex =
//                                               value!;
//                                         });
//                                       },
//                                       activeColor:
//                                           Theme.of(context).colorScheme.primary,
//                                       fillColor: WidgetStateProperty
//                                           .resolveWith<Color?>(
//                                         (Set<WidgetState> states) {
//                                           if (states.contains(
//                                               WidgetState.selected)) {
//                                             return Theme.of(context)
//                                                 .colorScheme
//                                                 .primary;
//                                           }
//                                           return Theme.of(context)
//                                               .colorScheme
//                                               .onSurface
//                                               .withOpacity(
//                                                   0.3); // Change this to any color you want for unselected state
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: SizedBox(
//                   height: 70,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ContinueButton(
//                         onPressed: () async {
//                           await _startAccountAggregatorFlow();
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
