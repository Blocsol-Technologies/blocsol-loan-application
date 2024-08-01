// import 'package:blocsol_invoice_based_credit/screens/components/nav/bottom_nav_bar.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/liabilities/utils/top_decoration.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/shared/liability_card.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/details/company_details_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/liabilities/liabilities_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class LiabilitiesHome extends ConsumerStatefulWidget {
//   const LiabilitiesHome({super.key});

//   @override
//   ConsumerState<LiabilitiesHome> createState() => _LiabilitiesHomeState();
// }

// class _LiabilitiesHomeState extends ConsumerState<LiabilitiesHome> {
//   final _cancelToken = CancelToken();

//   void _handleNotificationBellPress() {
//     print("Notification Bell Pressed");
//   }

//   Future<void> _handleRefresh() async {
//     if (ref.read(liabilitiesStateProvider).fetchingLiabilitiess) {
//       return;
//     }

//     var _ = await ref
//         .read(liabilitiesStateProvider.notifier)
//         .fetchLiabilities(_cancelToken);
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _handleRefresh();
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final liabiliiesStateRef = ref.watch(liabilitiesStateProvider);
//     final companyDetailsRef = ref.watch(companyDetailsStateProvider);

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           bottomNavigationBar: const UserBottomNavBar(),
//           body: SizedBox(
//             child: Stack(
//               children: [
//                 const LiabilityTopDecoration(),
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
//                               context.go(AppRoutes.msme_home_screen);
//                             },
//                             child: Icon(
//                               Icons.arrow_back_ios,
//                               size: 20,
//                               color: Theme.of(context).colorScheme.onPrimary,
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               IconButton(
//                                 onPressed: () {
//                                   HapticFeedback.mediumImpact();
//                                   _handleNotificationBellPress();
//                                 },
//                                 icon: Icon(
//                                   Icons.notifications_active,
//                                   size: 25,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 width: 15,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   HapticFeedback.mediumImpact();
//                                 },
//                                 child: Container(
//                                   height: 28,
//                                   width: 28,
//                                   clipBehavior: Clip.antiAlias,
//                                   decoration: BoxDecoration(
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Center(
//                                       child: Text(
//                                     companyDetailsRef.tradeName[0],
//                                     style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .primary,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.bold,
//                                         letterSpacing: 0.14,
//                                         fontFamily: fontFamily),
//                                   )),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 25,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: RelativeSize.width(30, width),
//                           right: RelativeSize.width(30, width)),
//                       child: SizedBox(
//                         width: width,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
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
//                             Text(
//                               "GST: ${companyDetailsRef.gstNumber}",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.normal,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onPrimary
//                                     .withOpacity(0.75),
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
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: liabiliiesStateRef.fetchingLiabilitiess
//                             ? SizedBox(
//                                 width: width,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Lottie.asset(
//                                       'assets/animations/searching_data.json',
//                                       width:
//                                           (MediaQuery.of(context).size.width -
//                                                   40) *
//                                               0.85,
//                                     ),
//                                     const SpacerWidget(
//                                       height: 30,
//                                     ),
//                                     Text(
//                                       "Fetching Loan Data",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface,
//                                         fontSize: AppFontSizes.h2,
//                                         fontWeight: AppFontWeights.bold,
//                                         letterSpacing: 0.14,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                       softWrap: true,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : liabiliiesStateRef.liabilities.isEmpty
//                                 ? SizedBox(
//                                     width: width,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Lottie.asset(
//                                           'assets/animations/404.json',
//                                           width: (MediaQuery.of(context)
//                                                       .size
//                                                       .width -
//                                                   40) *
//                                               0.85,
//                                         ),
//                                         const SpacerWidget(
//                                           height: 30,
//                                         ),
//                                         Text(
//                                           "No Loans Found",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onSurface,
//                                             fontSize: AppFontSizes.h2,
//                                             fontWeight: AppFontWeights.bold,
//                                             letterSpacing: 0.14,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                           softWrap: true,
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 : ListView.builder(
//                                     shrinkWrap: true,
//                                     itemCount:
//                                         liabiliiesStateRef.liabilities.length,
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemBuilder: (context, index) {
//                                       return Padding(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal:
//                                               RelativeSize.width(30, width),
//                                         ),
//                                         child: LiabilityCard(
//                                           screenHeight: height,
//                                           screenWidth: width,
//                                           oldLoanDetails: liabiliiesStateRef
//                                               .liabilities[index],
//                                         ),
//                                       );
//                                     },
//                                   ),
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
