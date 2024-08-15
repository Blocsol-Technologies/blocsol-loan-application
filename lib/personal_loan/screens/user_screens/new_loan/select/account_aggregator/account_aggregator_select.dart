// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/account_details/borrower_account_details_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/new_loan/new_loan_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class PCNewLoanAASelect extends ConsumerStatefulWidget {
//   const PCNewLoanAASelect({super.key});

//   @override
//   ConsumerState<PCNewLoanAASelect> createState() => _PCNewLoanAASelectState();
// }

// class _PCNewLoanAASelectState extends ConsumerState<PCNewLoanAASelect> {
//   final _cancelToken = CancelToken();

//   int _selectedAAIndex = -1;

//   void _handleNotificationBellPress() {
//     print("Notification Bell Pressed");
//   }

//   void _fetchAAURL() {
//     if (_selectedAAIndex == -1) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Please select an account aggregator to continue.",
//           contentType: ContentType.failure,
//         ),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//       return;
//     }

//     var phoneNum = ref.read(borrowerAccountDetailsStateProvider).phone;

//     var selectedAa = ref
//         .read(newLoanStateProvider)
//         .accountAggregatorInfoList[_selectedAAIndex];

//     selectedAa.setAaId(phoneNum);

//     ref.read(newLoanStateProvider.notifier).setSelectedAA(selectedAa);

//     context.go(AppRoutes.pc_new_loan_generate_offers_and_aa_consent);
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
//     final borrowerAccountDetailsRef =
//         ref.watch(borrowerAccountDetailsStateProvider);
//     final loanStateRef = ref.watch(newLoanStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);

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
//                   height: RelativeSize.height(250, height),
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
//                     vertical: RelativeSize.height(20, height),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
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
//                                 context.go(AppRoutes
//                                     .pc_new_loan_account_aggregator_bank_select);
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
//                         height: 30,
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
//                                 "Account Aggregator",
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
//                               Text(
//                                 "Choose one of the RBI approved Account Aggregators to share your financial information",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.normal,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                   letterSpacing: 0.24,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 softWrap: true,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 30,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(30, width),
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.background,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           height: RelativeSize.height(250, height),
//                           width: width,
//                           child: SingleChildScrollView(
//                             physics: const BouncingScrollPhysics(),
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: loanStateRef
//                                       .accountAggregatorInfoList.length,
//                                   itemBuilder: (ctx, index) {
//                                     return Container(
//                                       width: MediaQuery.of(context).size.width,
//                                       decoration: BoxDecoration(
//                                         border: Border(
//                                             bottom: BorderSide(
//                                                 width: 1.5,
//                                                 color: Theme.of(context)
//                                                     .colorScheme
//                                                     .onBackground
//                                                     .withOpacity(0.1))),
//                                       ),
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 20, vertical: 15),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: <Widget>[
//                                           SizedBox(
//                                             height: 30,
//                                             child: Image.asset(
//                                               loanStateRef
//                                                   .accountAggregatorInfoList[
//                                                       index]
//                                                   .assetPath,
//                                               fit: BoxFit
//                                                   .contain, // or BoxFit.contain based on your requirement
//                                             ),
//                                           ),
//                                           const SpacerWidget(
//                                             width: 15,
//                                           ),
//                                           Text(
//                                             loanStateRef
//                                                 .accountAggregatorInfoList[
//                                                     index]
//                                                 .name,
//                                             style: TextStyle(
//                                               fontFamily: fontFamily,
//                                               fontSize: AppFontSizes.body,
//                                               fontWeight:
//                                                   AppFontWeights.extraBold,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .onBackground,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: <Widget>[
//                                                 Radio(
//                                                   value: index,
//                                                   groupValue: _selectedAAIndex,
//                                                   onChanged: (int? value) {
//                                                     setState(() {
//                                                       _selectedAAIndex = value!;
//                                                     });
//                                                   },
//                                                   activeColor: Theme.of(context)
//                                                       .colorScheme
//                                                       .primary,
//                                                   fillColor:
//                                                       MaterialStateProperty
//                                                           .resolveWith<Color?>(
//                                                     (Set<MaterialState>
//                                                         states) {
//                                                       if (states.contains(
//                                                           MaterialState
//                                                               .selected)) {
//                                                         return Theme.of(context)
//                                                             .colorScheme
//                                                             .primary;
//                                                       }
//                                                       return Theme.of(context)
//                                                           .colorScheme
//                                                           .onBackground
//                                                           .withOpacity(
//                                                               0.3); // Change this to any color you want for unselected state
//                                                     },
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 30,
//                       ),
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             SizedBox(
//                               height: 30,
//                               child: Image.asset(
//                                   "assets/images/aa/sahamati_certified.png",
//                                   fit: BoxFit.contain),
//                             )
//                           ]),
//                       const SpacerWidget(
//                         height: 40,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               HapticFeedback.heavyImpact();
//                               _fetchAAURL();
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
