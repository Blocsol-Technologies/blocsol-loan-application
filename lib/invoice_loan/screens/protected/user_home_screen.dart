// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/components/nav/bottom_nav_bar.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/details/company_details_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state_data.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class UserHome extends ConsumerStatefulWidget {
//   const UserHome({super.key});

//   @override
//   ConsumerState<UserHome> createState() => _UserHomeState();
// }

// class _UserHomeState extends ConsumerState<UserHome> {
//   final _cancelToken = CancelToken();

//   bool _searching = false;

//   Future<void> _handleGetLoanPress() async {
//     await HapticFeedback.heavyImpact();

//     if (_searching) {
//       return;
//     }

//     setState(() {
//       _searching = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .performGeneralSearch(false, _cancelToken);

//     if (mounted) {
//       if (response.success) {
//         setState(() {
//           _searching = false;
//         });
//         if (response.data['redirection']) {
//           await showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                     backgroundColor: Theme.of(context).colorScheme.surface,
//                     title: Text(
//                       'Previous Tx Exists',
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h1,
//                         fontWeight: AppFontWeights.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     content: Text(
//                       'Do you want to continue your previous action? ${getPreviousTxString(response.data['status'], response.data['state'])}',
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h3,
//                         fontWeight: AppFontWeights.medium,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     actions: <Widget>[
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop(true);
//                         },
//                         child: Text('Go Back',
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.h1,
//                               fontWeight: AppFontWeights.bold,
//                               color: Theme.of(context).colorScheme.primary,
//                             )),
//                       ),
//                       TextButton(
//                         onPressed: () async {
//                           var newResponse = await ref
//                               .read(newLoanStateProvider.notifier)
//                               .performGeneralSearch(true, _cancelToken);

//                           if (!context.mounted) return;

//                           if (mounted) {
//                             if (newResponse.success) {
//                               context.go(AppRoutes.msme_new_loan_process);
//                             } else {
//                               final snackBar = SnackBar(
//                                 elevation: 0,
//                                 behavior: SnackBarBehavior.floating,
//                                 backgroundColor: Colors.transparent,
//                                 content: AwesomeSnackbarContent(
//                                   title: 'Error!',
//                                   message: newResponse.message,
//                                   contentType: ContentType.failure,
//                                 ),
//                               );

//                               ScaffoldMessenger.of(context)
//                                 ..hideCurrentSnackBar()
//                                 ..showSnackBar(snackBar);
//                             }
//                           }
//                         },
//                         child: Text('No',
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.h1,
//                               fontWeight: AppFontWeights.bold,
//                               color: Theme.of(context).colorScheme.primary,
//                             )),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           switch (response.data['status']) {
//                             case "search":
//                               switch (response.data['state']) {
//                                 case "search_01_complete":
//                                   ref
//                                       .read(newLoanStateProvider.notifier)
//                                       .updateState(
//                                           NewLoanProgress.invoiceSelect);
//                                   context.go(
//                                       AppRoutes
//                                           .msme_new_loan_account_aggregator_select,
//                                       extra: true);
//                                 case "search_complete":
//                                   ref
//                                       .read(newLoanStateProvider.notifier)
//                                       .updateState(NewLoanProgress.bankConsent);
//                                   context.go(AppRoutes.msme_new_loan_process);
//                                 default:
//                                   context.go(AppRoutes.msme_new_loan_process);
//                               }
//                             case "select":
//                               switch (response.data['state']) {
//                                 case "select_02_pending":
//                                   ref
//                                       .read(newLoanStateProvider.notifier)
//                                       .updateState(
//                                           NewLoanProgress.loanOfferSelect);
//                                   context.go(AppRoutes.msme_new_loan_process);

//                                 default:
//                                   ref
//                                       .read(newLoanStateProvider.notifier)
//                                       .updateState(NewLoanProgress.bankConsent);
//                                   context.go(AppRoutes.msme_new_loan_process);
//                               }

//                             case "init":
//                               switch (response.data['state']) {
//                                 case "init_01_pending":
//                                   ref
//                                       .read(newLoanStateProvider.notifier)
//                                       .updateState(NewLoanProgress.aadharKYC);
//                                   context.go(AppRoutes.msme_new_loan_process);
//                                 case "init_02_pending":
//                                   ref
//                                       .read(newLoanStateProvider.notifier)
//                                       .updateState(NewLoanProgress.udyamKYC);
//                                   context.go(AppRoutes.msme_new_loan_process);
//                                 case "init_03_pending":
//                                   ref
//                                       .read(newLoanStateProvider.notifier)
//                                       .updateState(
//                                           NewLoanProgress.bankAccountDetails);
//                                   context.go(AppRoutes.msme_new_loan_process);
//                                 case "init_04_pending":
//                                   ref
//                                       .read(newLoanStateProvider.notifier)
//                                       .updateState(
//                                           NewLoanProgress.repaymentSetup);
//                                   context.go(AppRoutes.msme_new_loan_process);
//                                 default:
//                                   ref
//                                       .read(newLoanStateProvider.notifier)
//                                       .updateState(NewLoanProgress.aadharKYC);
//                                   context.go(AppRoutes.msme_new_loan_process);
//                               }
//                           }
//                         },
//                         child: Text('Yes',
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.h1,
//                               fontWeight: AppFontWeights.bold,
//                               color: Theme.of(context).colorScheme.primary,
//                             )),
//                       ),
//                     ]);
//               });
//         } else {
//           context.go(AppRoutes.msme_new_loan_process);
//         }
//       } else {
//         setState(() {
//           _searching = false;
//         });
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: 'Error!',
//             message: response.message,
//             contentType: ContentType.failure,
//           ),
//         );

//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(snackBar);
//       }
//     }
//   }

//   Future<void> _handleRefresh() async {
//     if (ref.read(companyDetailsStateProvider).fetchingData) {
//       return;
//     }

//     var _ = await ref
//         .read(companyDetailsStateProvider.notifier)
//         .getCompanyDetails(_cancelToken);
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
//     final detailsRef = ref.watch(companyDetailsStateProvider);
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         bottomNavigationBar: const UserBottomNavBar(),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             horizontal: RelativeSize.width(15, width),
//             vertical: RelativeSize.height(30, width),
//           ),
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Expanded(
//                     child: SizedBox(),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       HapticFeedback.mediumImpact();
//                       context.go(AppRoutes.msme_profile);
//                     },
//                     icon: Icon(
//                       Icons.supervised_user_circle_outlined,
//                       size: 30,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                 ],
//               ),
//               const SpacerWidget(
//                 height: 15,
//               ),
//               ClipPath(
//                 clipper: BottomClipper(),
//                 child: Container(
//                   width: width,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: RelativeSize.width(30, width),
//                     vertical: RelativeSize.height(40, height),
//                   ),
//                   decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.secondary),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Hello ${detailsRef.tradeName}",
//                         softWrap: true,
//                         textAlign: TextAlign.start,
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h1,
//                           fontWeight: AppFontWeights.medium,
//                           color: Theme.of(context).colorScheme.onSecondary,
//                         ),
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           text: "PAN:",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             color: const Color.fromRGBO(78, 78, 78, 1),
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.medium,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: " ${detailsRef.gstNumber}",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color:
//                                     Theme.of(context).colorScheme.onSecondary,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.normal,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           HapticFeedback.heavyImpact();
//                           _handleGetLoanPress();
//                         },
//                         child: Container(
//                           padding: EdgeInsets.fromLTRB(
//                             RelativeSize.width(25, width),
//                             RelativeSize.height(15, height),
//                             RelativeSize.width(20, width),
//                             RelativeSize.height(15, height),
//                           ),
//                           decoration: BoxDecoration(
//                               color: const Color.fromRGBO(0, 165, 236, 1),
//                               borderRadius: BorderRadius.circular(8),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.25),
//                                   offset: const Offset(
//                                       0, 4), // horizontal, vertical offset
//                                   blurRadius: 10, // blur radius
//                                   spreadRadius: 1, // spread radius
//                                 ),
//                               ]),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.5),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Container(
//                                     height: 35,
//                                     width: 35,
//                                     decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: Icon(
//                                         Icons.currency_rupee_sharp,
//                                         size: 27,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .primary,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 width: 15,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Text(
//                                     "Get New Loan",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       fontSize: AppFontSizes.h2,
//                                       fontWeight: AppFontWeights.extraBold,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary,
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     height: 2,
//                                   ),
//                                   Text(
//                                     "5 steps to get a loan",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       fontSize: AppFontSizes.body,
//                                       fontWeight: AppFontWeights.medium,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Expanded(
//                                 child: Container(),
//                               ),
//                               _searching
//                                   ? SizedBox(
//                                       height: 20,
//                                       width: 20,
//                                       child: CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 Theme.of(context)
//                                                     .colorScheme
//                                                     .onPrimary),
//                                         strokeWidth: 4,
//                                       ),
//                                     )
//                                   : Icon(
//                                       Icons.arrow_forward_ios_sharp,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary,
//                                       size: 25,
//                                     ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               ClipPath(
//                 clipper: TopClipper(),
//                 child: Container(
//                   width: width,
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(35, width),
//                       RelativeSize.height(30, height),
//                       RelativeSize.width(35, width),
//                       RelativeSize.height(15, height)),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "How to get a new loan?",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onPrimary,
//                           letterSpacing: 0.14,
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                               color: const Color.fromRGBO(74, 155, 189, 1),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: const Color.fromRGBO(124, 146, 179, 1),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Image.asset(
//                               "assets/images/users/msme/new_loans/home/step1.png",
//                               height: 30,
//                               width: 30,
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 15,
//                           ),
//                           Flexible(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                   "Step 1:",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.bold,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                     letterSpacing: 0.14,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Request Loan by Sharing GST invoices",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.medium,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                     letterSpacing: 0.14,
//                                   ),
//                                   softWrap: true,
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 35,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                               color: const Color.fromRGBO(74, 155, 189, 1),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: const Color.fromRGBO(124, 146, 179, 1),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Image.asset(
//                               "assets/images/users/msme/new_loans/home/step2.png",
//                               height: 30,
//                               width: 30,
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 15,
//                           ),
//                           Flexible(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                   "Step 2:",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.bold,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                     letterSpacing: 0.14,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Select the best Loan Offer",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.medium,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                     letterSpacing: 0.14,
//                                   ),
//                                   softWrap: true,
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 35,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                               color: const Color.fromRGBO(74, 155, 189, 1),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: const Color.fromRGBO(124, 146, 179, 1),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Image.asset(
//                               "assets/images/users/msme/new_loans/home/step3.png",
//                               height: 30,
//                               width: 30,
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 15,
//                           ),
//                           Flexible(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                   "Step 3:",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.bold,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                     letterSpacing: 0.14,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Complete KYC & Loan Application",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.medium,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                     letterSpacing: 0.14,
//                                   ),
//                                   softWrap: true,
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 35,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                               color: const Color.fromRGBO(74, 155, 189, 1),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: const Color.fromRGBO(124, 146, 179, 1),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Image.asset(
//                               "assets/images/users/msme/new_loans/home/step4.png",
//                               height: 30,
//                               width: 30,
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 15,
//                           ),
//                           Flexible(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                   "Step 4:",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.bold,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                     letterSpacing: 0.14,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Setup Repayment & Monitoring Consent",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.medium,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                     letterSpacing: 0.14,
//                                   ),
//                                   softWrap: true,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 30,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "INVOICEPE",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               color: Theme.of(context).colorScheme.onPrimary,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 10,
//                       ),
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

// class BottomClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();

//     double sideRadius = 15.0;
//     double midPoint = size.height;
//     double cornerRadius = 15.0;

//     path.moveTo(0, cornerRadius);
//     path.lineTo(0, (midPoint - sideRadius));

//     //LEFT ARC
//     path.quadraticBezierTo(
//         sideRadius, midPoint - sideRadius, sideRadius, midPoint);
//     path.quadraticBezierTo(
//         sideRadius, midPoint + sideRadius, 0, midPoint + sideRadius);

//     path.lineTo(size.width, (midPoint + sideRadius));

//     //RIGHT ARC
//     path.quadraticBezierTo((size.width - sideRadius), (midPoint + sideRadius),
//         (size.width - sideRadius), (midPoint));
//     path.quadraticBezierTo((size.width - sideRadius), (midPoint - sideRadius),
//         size.width, midPoint - sideRadius);

//     path.lineTo(size.width, cornerRadius);

//     //TopRight
//     path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);

//     path.lineTo(cornerRadius, 0);

//     //TopLeft
//     path.quadraticBezierTo(0, 0, 0, cornerRadius);

//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// class TopClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();

//     double sideRadius = 15.0;
//     double midPoint = 0;
//     double cornerRadius = 15.0;

//     path.moveTo(cornerRadius, 0);

//     // LEFT ARC
//     path.quadraticBezierTo(
//         0 + sideRadius, (midPoint + sideRadius), 0, sideRadius);
//     // path.quadraticBezierTo(
//     //     sideRadius, midPoint - sideRadius, 0, midPoint - sideRadius);

//     path.lineTo(0, size.height - cornerRadius);

//     //BottomLeft
//     path.quadraticBezierTo(0, size.height, cornerRadius, size.height);

//     path.lineTo(size.width - cornerRadius, size.height);

//     //BottomRight
//     path.quadraticBezierTo(
//         size.width, size.height, size.width, size.height - cornerRadius);

//     path.lineTo(size.width, (midPoint + sideRadius));

//     //RIGHT ARC
//     path.quadraticBezierTo((size.width - sideRadius), (midPoint + sideRadius),
//         (size.width - sideRadius), (midPoint));
//     // path.quadraticBezierTo((size.width - sideRadius), (midPoint - sideRadius),
//     //     size.width, midPoint - sideRadius);

//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
