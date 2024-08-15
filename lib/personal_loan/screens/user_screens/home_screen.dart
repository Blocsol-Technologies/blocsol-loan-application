// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_personal_credit/screens/personal_credit/user_screens/components/bottom_navigation_bar.dart';
// import 'package:blocsol_personal_credit/screens/personal_credit/user_screens/components/old_loan_card.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/new_loan/new_loan_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/old_loans/old_loans_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:dio/dio.dart';

// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/account_details/borrower_account_details_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';

// class PCHomeScreen extends ConsumerStatefulWidget {
//   const PCHomeScreen({super.key});

//   @override
//   ConsumerState<PCHomeScreen> createState() => _PCHomeScreenState();
// }

// class _PCHomeScreenState extends ConsumerState<PCHomeScreen> {
//   final _cancelToken = CancelToken();

//   void _handleNotificationBellPress() {
//     // TODO: Implement Notification Bell Press
//   }

//   Future<void> _fetchBorrowerData() async {
//     var response = await ref
//         .read(borrowerAccountDetailsStateProvider.notifier)
//         .getBorrowerDetails(_cancelToken);

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

//     response = await ref
//         .read(oldLoanDetailsStateProvider.notifier)
//         .fetchOffers(_cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       return;
//     }

//     setState(() {});
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchBorrowerData();
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     var oldLoanStateRef = ref.read(oldLoanDetailsStateProvider);
//     var borrowerAccountDetailsRef =
//         ref.watch(borrowerAccountDetailsStateProvider);

//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         bottomNavigationBar: const BorrowerBottomNavigationBar(),
//         body: SizedBox(
//           height: height,
//           width: width,
//           child: Column(
//             children: <Widget>[
//               // Hero
//               SizedBox(
//                 width: width,
//                 height: RelativeSize.height(280, height),
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: width,
//                       height: RelativeSize.height(245, height),
//                       padding: EdgeInsets.all(RelativeSize.width(30, width)),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.primary,
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(40),
//                           bottomRight: Radius.circular(40),
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
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
//                                 width: 25,
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
//                                     child: Image.network(
//                                       borrowerAccountDetailsRef.imageURL.isEmpty
//                                           ? "https://placehold.co/30x30/000000/FFFFFF.png"
//                                           : borrowerAccountDetailsRef.imageURL,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           const SpacerWidget(
//                             height: 25,
//                           ),
//                           Text(
//                             "Welcome",
//                             style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h1,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onPrimary),
//                           ),
//                           const SpacerWidget(
//                             height: 5,
//                           ),
//                           Text(
//                             borrowerAccountDetailsRef.name.isEmpty
//                                 ? "Loading..."
//                                 : borrowerAccountDetailsRef.name,
//                             style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h1,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onPrimary),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       child: SizedBox(
//                         width: width,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             _GetNewLoanButton(
//                                 screenHeight: height, screenWidth: width)
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SpacerWidget(
//                 height: 10,
//               ),

//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: RelativeSize.width(50, width)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       "My Loans",
//                       style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.normal,
//                           color: Theme.of(context).colorScheme.onBackground),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         HapticFeedback.mediumImpact();
//                         context.go(AppRoutes.pc_old_loans_screen);
//                       },
//                       child: Text(
//                         "Show All",
//                         style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.medium,
//                             color: Theme.of(context).colorScheme.primary),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SpacerWidget(
//                 height: 15,
//               ),
//               Expanded(
//                 child: Container(
//                     width: width,
//                     padding: EdgeInsets.symmetric(
//                         horizontal: RelativeSize.width(30, width)),
//                     child: oldLoanStateRef.oldLoans.isNotEmpty
//                         ? SingleChildScrollView(
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: oldLoanStateRef.oldLoans.length,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 return Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: RelativeSize.width(30, width),
//                                   ),
//                                   child: OldLoanCard(
//                                     screenHeight: height,
//                                     screenWidth: width,
//                                     oldLoanDetails:
//                                         oldLoanStateRef.oldLoans[index],
//                                   ),
//                                 );
//                               },
//                             ),
//                           )
//                         : oldLoanStateRef.oldLoans.isEmpty &&
//                                 oldLoanStateRef.fetchingOldOffers
//                             ? Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Lottie.asset(
//                                       'assets/animations/loading_spinner.json',
//                                       height: 150,
//                                       width: 150),
//                                   const SpacerWidget(
//                                     height: 20,
//                                   ),
//                                   Text(
//                                     "Fetching Loan Offers!",
//                                     style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.h2,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground),
//                                   ),
//                                 ],
//                               )
//                             : oldLoanStateRef.oldLoans.isEmpty &&
//                                     !oldLoanStateRef.fetchingOldOffers &&
//                                     oldLoanStateRef.oldOffersFetchTime != 0
//                                 ? Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Lottie.asset(
//                                           'assets/animations/error.json',
//                                           height: 150,
//                                           width: 150),
//                                       const SpacerWidget(
//                                         height: 20,
//                                       ),
//                                       Text(
//                                         "No Loan Offers Found!",
//                                         style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.h2,
//                                             fontWeight: AppFontWeights.bold,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onBackground),
//                                       ),
//                                     ],
//                                   )
//                                 : const SizedBox()),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _GetNewLoanButton extends ConsumerStatefulWidget {
//   final double screenHeight;
//   final double screenWidth;
//   const _GetNewLoanButton(
//       {required this.screenHeight, required this.screenWidth});

//   @override
//   ConsumerState<_GetNewLoanButton> createState() => _GetNewLoanButtonState();
// }

// class _GetNewLoanButtonState extends ConsumerState<_GetNewLoanButton> {
//   final _cancelToken = CancelToken();

//   bool _sendingSearchRequest = false;

//   Future<void> _handleGetNewLoan() async {
//     if (_sendingSearchRequest) return;

//     setState(() {
//       _sendingSearchRequest = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .performGeneralSearch(false, _cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _sendingSearchRequest = false;
//     });

//     if (response.success) {
//       if (response.data['redirection']) {
//         await showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                   backgroundColor: Theme.of(context).colorScheme.background,
//                   title: Text(
//                     'Pevious Tx Exists',
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h1,
//                       fontWeight: AppFontWeights.bold,
//                       color: Theme.of(context).colorScheme.onBackground,
//                     ),
//                   ),
//                   content: Text(
//                     'Do you want to continue your previous action? ${getPreviousTxString(response.data['status'], response.data['state'])}',
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h3,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onBackground,
//                     ),
//                   ),
//                   actions: <Widget>[
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop(true);
//                       },
//                       child: Text('Go Back',
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h1,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.primary,
//                           )),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         var newResponse = await ref
//                             .read(newLoanStateProvider.notifier)
//                             .performGeneralSearch(true, _cancelToken);

//                         if (!context.mounted) return;

//                         if (mounted) {
//                           if (newResponse.success) {
//                             context.go(AppRoutes.pc_new_loan_process);
//                           } else {
//                             final snackBar = SnackBar(
//                               elevation: 0,
//                               behavior: SnackBarBehavior.floating,
//                               backgroundColor: Colors.transparent,
//                               content: AwesomeSnackbarContent(
//                                 title: 'Error!',
//                                 message: newResponse.message,
//                                 contentType: ContentType.failure,
//                               ),
//                             );

//                             ScaffoldMessenger.of(context)
//                               ..hideCurrentSnackBar()
//                               ..showSnackBar(snackBar);
//                           }
//                         }
//                       },
//                       child: Text('No',
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h1,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.primary,
//                           )),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         switch (response.data['status']) {
//                           case "search":
//                             switch (response.data['state']) {
//                               case "approved":
//                                 ref
//                                     .read(newLoanStateProvider.notifier)
//                                     .updateState(NewLoanProgress.formGenerated);
//                                 context.go(
//                                     AppRoutes
//                                         .pc_new_loan_account_aggregator_bank_select,
//                                     extra: true);
//                               case "search_complete":
//                                 ref
//                                     .read(newLoanStateProvider.notifier)
//                                     .updateState(NewLoanProgress.bankConsent);
//                                 context.go(AppRoutes.pc_new_loan_process);
//                               default:
//                                 context.go(AppRoutes.pc_new_loan_process);
//                             }
//                           case "select":
//                             switch (response.data['state']) {
//                               case "on_select_02":
//                                 ref
//                                     .read(newLoanStateProvider.notifier)
//                                     .updateState(
//                                         NewLoanProgress.loanOfferSelect);
//                                 context.go(AppRoutes.pc_new_loan_process);

//                               default:
//                                 ref
//                                     .read(newLoanStateProvider.notifier)
//                                     .updateState(NewLoanProgress.bankConsent);
//                                 context.go(AppRoutes.pc_new_loan_process);
//                             }

//                           case "init":
//                             switch (response.data['state']) {
//                               case "on_init_01":
//                                 ref
//                                     .read(newLoanStateProvider.notifier)
//                                     .updateState(NewLoanProgress.aadharKYC);
//                                 context.go(AppRoutes.pc_new_loan_process);
//                               case "on_init_02":
//                                 ref
//                                     .read(newLoanStateProvider.notifier)
//                                     .updateState(
//                                         NewLoanProgress.bankAccountDetails);
//                                 context.go(AppRoutes.pc_new_loan_process);
//                               case "on_init_03":
//                                 ref
//                                     .read(newLoanStateProvider.notifier)
//                                     .updateState(
//                                         NewLoanProgress.repaymentSetup);
//                                 context.go(AppRoutes.pc_new_loan_process);
//                               default:
//                                 ref
//                                     .read(newLoanStateProvider.notifier)
//                                     .updateState(NewLoanProgress.aadharKYC);
//                                 context.go(AppRoutes.pc_new_loan_process);
//                             }
//                         }
//                       },
//                       child: Text('Yes',
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h1,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.primary,
//                           )),
//                     ),
//                   ]);
//             });
//       } else {
//         context.go(AppRoutes.pc_new_loan_process);
//       }
//     } else {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: response.message,
//           contentType: ContentType.failure,
//         ),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//     }
//     return;
//   }

//   @override
//   void dispose() {
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.mediumImpact();
//         _handleGetNewLoan();
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: RelativeSize.width(30, widget.screenWidth),
//           vertical: RelativeSize.height(25, widget.screenHeight),
//         ),
//         height: RelativeSize.height(90, widget.screenHeight),
//         width: RelativeSize.width(310, widget.screenWidth),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.tertiary,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "Get New Loan!",
//               style: TextStyle(
//                 fontFamily: fontFamily,
//                 fontSize: AppFontSizes.h2,
//                 fontWeight: AppFontWeights.bold,
//                 color: Theme.of(context).colorScheme.onTertiary,
//               ),
//             ),
//             Container(
//               height: 40,
//               width: 40,
//               decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.background,
//                   shape: BoxShape.circle),
//               child: Center(
//                 child: _sendingSearchRequest
//                     ? Lottie.asset('assets/animations/loading_spinner.json',
//                         height: 40, width: 40)
//                     : Icon(
//                         Icons.arrow_forward_ios,
//                         color: Theme.of(context).colorScheme.onBackground,
//                         size: 15,
//                       ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// String getPreviousTxString(String status, String state) {
//   if (status == "search") {
//     switch (state) {
//       case "approved":
//         return "You need to provide consent on Account Aggregator";
//       case "search_complete":
//         return "You were selecting offers from different lenders";
//     }
//   }

//   if (status == "select") {
//     if (state == "on_select_02") {
//       return "You selected an offer and now need to perform Individual KYC";
//     }

//     return "You were selecting offers from different lenders";
//   }

//   if (status == "init") {
//     switch (state) {
//       case "on_init_01":
//         return "You completed aadhar KYC and now need to complete Udyam Entity KYC.";
//       case "on_init_02":
//         return "You completed Udyam Entity KYC and now need to provide Bank Account details.";
//       case "on_init_03":
//         return "You provided Bank Account Details and now need to set up Repayment.";
//       case "on_init_04":
//         return "You set up Repayment and now need to sign the Loan Agreement.";
//     }
//   }

//   return "";
// }
