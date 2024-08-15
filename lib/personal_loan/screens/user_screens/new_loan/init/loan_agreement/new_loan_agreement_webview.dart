// import 'dart:async';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/account_details/borrower_account_details_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/new_loan/new_loan_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class PCNewLoanAgreementWebview extends ConsumerStatefulWidget {
//   final String url;
//   const PCNewLoanAgreementWebview({super.key, required this.url});

//   @override
//   ConsumerState<PCNewLoanAgreementWebview> createState() =>
//       _PCNewLoanAgreementWebviewState();
// }

// class _PCNewLoanAgreementWebviewState
//     extends ConsumerState<PCNewLoanAgreementWebview> {
//   bool _loadingAgreementURL = false;
//   final _cancelToken = CancelToken();
//   final GlobalKey _loanAgreementWebviewKey = GlobalKey();

//   InAppWebViewController? _webViewController;

//   String _currentUrl = "";

//   bool _verifyingLoanAgreementSuccess = false;

//   void _checkLoanAgreementSuccess() async {
//     // if (_verifyingLoanAgreementSuccess) {
//     //   return;
//     // }

//     setState(() {
//       _verifyingLoanAgreementSuccess = true;
//     });

//     var checkForm07SubmissionSuccessResponse = await ref
//         .read(newLoanStateProvider.notifier)
//         .checkLoanAgreementSuccess(_cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _verifyingLoanAgreementSuccess = true;
//     });

//     if (!checkForm07SubmissionSuccessResponse.success) {
//       if (mounted) {
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: 'Error!',
//             message: "Loan Repayment Setup Unsuccessful. Contact Support",
//             contentType: ContentType.failure,
//           ),
//           duration: const Duration(seconds: 15),
//         );

//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(snackBar);

//         return;
//       }
//     }

//     ref
//         .read(newLoanStateProvider.notifier)
//         .updateState(NewLoanProgress.loanAgreement);

//     if (mounted) {
//       context.go(AppRoutes.pc_new_loan_process);
//     }
//   }

//   Future<void> _refetchLoanAgreement() async {
//     if (!ref.read(newLoanStateProvider).loanAgreementFailure) {
//       return;
//     }

//     ref.read(newLoanStateProvider.notifier).updateLoanAgreementFailure(false);

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .refetchLoanAgreementURL(_cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Unable to refetch Loan Agreement URL. Contact Support.",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     } else {
//       setState(() {
//         _currentUrl = response.data['url'];
//       });
//       _webViewController?.loadUrl(
//           urlRequest: URLRequest(url: WebUri(response.data['url'])));
//     }
//   }

//   void _handleNotificationBellPress() {
//     print("Notification Bell Pressed");
//   }

//   @override
//   initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       setState(() {
//         _currentUrl = widget.url;
//         _webViewController?.loadUrl(
//             urlRequest: URLRequest(url: WebUri(widget.url)));
//       });
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final borrowerAccountDetailsRef =
//         ref.watch(borrowerAccountDetailsStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           body: SizedBox(
//             height: height,
//             width: width,
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
//                 Container(
//                   padding:
//                       EdgeInsets.only(top: RelativeSize.height(20, height)),
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
//                               onTap: () async {
//                                 HapticFeedback.mediumImpact();
//                                 await showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                           backgroundColor: Theme.of(context)
//                                               .colorScheme
//                                               .primary,
//                                           title: Text(
//                                             'Confirm',
//                                             style: TextStyle(
//                                               fontFamily: fontFamily,
//                                               fontSize: AppFontSizes.h2,
//                                               fontWeight: AppFontWeights.bold,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .onPrimary,
//                                             ),
//                                           ),
//                                           content: Text(
//                                             'Have you signed the Loan Agreement successfully?',
//                                             style: TextStyle(
//                                               fontFamily: fontFamily,
//                                               fontSize: AppFontSizes.body,
//                                               fontWeight: AppFontWeights.medium,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .onPrimary,
//                                             ),
//                                           ),
//                                           actions: <Widget>[
//                                             TextButton(
//                                               onPressed: () {
//                                                 HapticFeedback.mediumImpact();
//                                                 context.go(AppRoutes
//                                                     .pc_new_loan_process);
//                                               },
//                                               child: Text('Go Back',
//                                                   style: TextStyle(
//                                                     fontFamily: fontFamily,
//                                                     fontSize: AppFontSizes.h3,
//                                                     fontWeight:
//                                                         AppFontWeights.bold,
//                                                     color: Theme.of(context)
//                                                         .colorScheme
//                                                         .onPrimary,
//                                                   )),
//                                             ),
//                                             TextButton(
//                                               onPressed: () {
//                                                 HapticFeedback.mediumImpact();
//                                                 Navigator.of(context).pop(true);
//                                               },
//                                               child: Text('No',
//                                                   style: TextStyle(
//                                                     fontFamily: fontFamily,
//                                                     fontSize: AppFontSizes.h3,
//                                                     fontWeight:
//                                                         AppFontWeights.bold,
//                                                     color: Theme.of(context)
//                                                         .colorScheme
//                                                         .onPrimary,
//                                                   )),
//                                             ),
//                                             TextButton(
//                                               onPressed: () {
//                                                 HapticFeedback.mediumImpact();
//                                                 Navigator.of(context).pop(true);
//                                                 _checkLoanAgreementSuccess();
//                                               },
//                                               child: Text('Yes',
//                                                   style: TextStyle(
//                                                     fontFamily: fontFamily,
//                                                     fontSize: AppFontSizes.h3,
//                                                     fontWeight:
//                                                         AppFontWeights.bold,
//                                                     color: Theme.of(context)
//                                                         .colorScheme
//                                                         .onPrimary,
//                                                   )),
//                                             ),
//                                           ]);
//                                     });
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
//                         height: 20,
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
//                               GestureDetector(
//                                 onTap: () {
//                                   _checkLoanAgreementSuccess();
//                                 },
//                                 child: Text(
//                                   "Loan Agreement",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h1,
//                                     fontWeight: AppFontWeights.medium,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                   softWrap: true,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 30,
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: RelativeSize.width(15, width)),
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             clipBehavior: Clip.antiAlias,
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.background,
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 topRight: Radius.circular(20),
//                               ),
//                             ),
//                             child: ref
//                                     .watch(newLoanStateProvider)
//                                     .aadharKYCFailure
//                                 ? Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       const SpacerWidget(height: 50),
//                                       Lottie.asset(
//                                           "assets/animations/error.json",
//                                           height: 300,
//                                           width: 300),
//                                       const SpacerWidget(height: 35),
//                                       Text(
//                                         "Your Loan Agreement Sign Failed!",
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h2,
//                                           fontWeight: AppFontWeights.bold,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onBackground,
//                                         ),
//                                       ),
//                                       const SpacerWidget(
//                                         height: 30,
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           _refetchLoanAgreement();
//                                         },
//                                         child: Container(
//                                           height: 40,
//                                           width: 120,
//                                           decoration: BoxDecoration(
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary,
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               "Try Again?",
//                                               style: TextStyle(
//                                                 fontFamily: fontFamily,
//                                                 fontSize: AppFontSizes.h2,
//                                                 fontWeight:
//                                                     AppFontWeights.medium,
//                                                 color: Theme.of(context)
//                                                     .colorScheme
//                                                     .onPrimary,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SpacerWidget(
//                                         height: 30,
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           HapticFeedback.mediumImpact();
//                                           context.go(
//                                               AppRoutes.pc_new_loan_process);
//                                         },
//                                         child: Container(
//                                           height: 40,
//                                           width: 120,
//                                           decoration: BoxDecoration(
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary,
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               "Cancel?",
//                                               style: TextStyle(
//                                                 fontFamily: fontFamily,
//                                                 fontSize: AppFontSizes.h2,
//                                                 fontWeight:
//                                                     AppFontWeights.medium,
//                                                 color: Theme.of(context)
//                                                     .colorScheme
//                                                     .onPrimary,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   )
//                                 : _verifyingLoanAgreementSuccess
//                                     ? Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: <Widget>[
//                                           const SpacerWidget(height: 50),
//                                           Lottie.asset(
//                                               "assets/animations/loading_spinner.json",
//                                               height: 250,
//                                               width: 250),
//                                           const SpacerWidget(height: 35),
//                                           Text(
//                                             "Verifying Loan Agreement Success...",
//                                             style: TextStyle(
//                                               fontFamily: fontFamily,
//                                               fontSize: AppFontSizes.h2,
//                                               fontWeight: AppFontWeights.bold,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .onBackground,
//                                             ),
//                                           ),
//                                           Text(
//                                             "Please do not click back or close the app",
//                                             style: TextStyle(
//                                               fontFamily: fontFamily,
//                                               fontSize: AppFontSizes.body,
//                                               fontWeight: AppFontWeights.medium,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .onBackground,
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     : Stack(
//                                         children: [
//                                           _loadingAgreementURL
//                                               ? const LinearProgressIndicator()
//                                               : Container(),
//                                           ClipRRect(
//                                             borderRadius:
//                                                 const BorderRadius.only(
//                                               topLeft: Radius.circular(20),
//                                               topRight: Radius.circular(20),
//                                             ),
//                                             child: InAppWebView(
//                                               key: _loanAgreementWebviewKey,
//                                               gestureRecognizers: const <Factory<
//                                                   VerticalDragGestureRecognizer>>{},
//                                               initialSettings:
//                                                   InAppWebViewSettings(
//                                                 javaScriptEnabled: true,
//                                                 verticalScrollBarEnabled: true,
//                                                 disableHorizontalScroll: true,
//                                                 disableVerticalScroll: false,
//                                               ),
//                                               initialUrlRequest: URLRequest(
//                                                   url: WebUri(_currentUrl)),
//                                               onLoadStop: (_, __) {
//                                                 setState(() {
//                                                   _loadingAgreementURL = false;
//                                                 });
//                                               },
//                                               onWebViewCreated:
//                                                   (controller) async {
//                                                 _webViewController = controller;
//                                                 _webViewController!.loadUrl(
//                                                     urlRequest: URLRequest(
//                                                         url: WebUri(
//                                                             _currentUrl)));
//                                                 setState(() {
//                                                   _loadingAgreementURL = false;
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                           ),
//                         ),
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
