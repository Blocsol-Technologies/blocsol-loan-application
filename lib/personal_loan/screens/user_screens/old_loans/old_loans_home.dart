// import 'package:blocsol_personal_credit/screens/personal_credit/user_screens/components/bottom_navigation_bar.dart';
// import 'package:blocsol_personal_credit/screens/personal_credit/user_screens/components/old_loan_card.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/account_details/borrower_account_details_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/old_loans/old_loans_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class PCOldLoanHome extends ConsumerStatefulWidget {
//   const PCOldLoanHome({super.key});

//   @override
//   ConsumerState<PCOldLoanHome> createState() => _PCOldLoanHomeState();
// }

// class _PCOldLoanHomeState extends ConsumerState<PCOldLoanHome> {
//   void _handleNotificationBellPress() {
//     print("Notification Bell Pressed");
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final oldLoanStateRef = ref.watch(oldLoanDetailsStateProvider);
//     final borrowerAccountDetailsRef =
//         ref.watch(borrowerAccountDetailsStateProvider);

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           bottomNavigationBar: const BorrowerBottomNavigationBar(),
//           body: SizedBox(
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
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                           top: RelativeSize.height(30, height),
//                           left: RelativeSize.width(30, width),
//                           right: RelativeSize.width(30, width)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               HapticFeedback.mediumImpact();
//                               context.go(AppRoutes.pc_home_screen);
//                             },
//                             child: Icon(
//                               Icons.arrow_back_ios,
//                               size: 20,
//                               color: Theme.of(context).colorScheme.onPrimary,
//                             ),
//                           ),
//                           SizedBox(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 IconButton(
//                                   onPressed: () {
//                                     HapticFeedback.mediumImpact();
//                                     _handleNotificationBellPress();
//                                   },
//                                   icon: Icon(
//                                     Icons.notifications_active,
//                                     size: 25,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                   ),
//                                 ),
//                                 const SpacerWidget(
//                                   width: 15,
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     HapticFeedback.mediumImpact();
//                                   },
//                                   child: Container(
//                                     height: 28,
//                                     width: 28,
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: BoxDecoration(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: Image.network(
//                                         borrowerAccountDetailsRef
//                                                 .imageURL.isEmpty
//                                             ? "https://placehold.co/30x30/000000/FFFFFF.png"
//                                             : borrowerAccountDetailsRef
//                                                 .imageURL,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
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
//                           horizontal: RelativeSize.width(50, width)),
//                       child: SizedBox(
//                         width: width,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Your Loans",
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
//                               "Keep a track of your loans easily.",
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
//                       height: 40,
//                     ),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: oldLoanStateRef.oldLoans.length,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: RelativeSize.width(30, width),
//                               ),
//                               child: OldLoanCard(
//                                 screenHeight: height,
//                                 screenWidth: width,
//                                 oldLoanDetails: oldLoanStateRef.oldLoans[index],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
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
