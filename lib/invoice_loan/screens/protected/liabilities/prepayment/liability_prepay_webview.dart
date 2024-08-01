// import 'dart:async';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/liabilities/liabilities_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class LiabilityPrepaymentWebview extends ConsumerStatefulWidget {
//   final String url;
//   const LiabilityPrepaymentWebview({super.key, required this.url});

//   @override
//   ConsumerState<LiabilityPrepaymentWebview> createState() =>
//       _LiabilityPrepaymentWebviewState();
// }

// class _LiabilityPrepaymentWebviewState
//     extends ConsumerState<LiabilityPrepaymentWebview> {
//   final GlobalKey _prepaymentWebviewKey = GlobalKey();
//   final _cancelToken = CancelToken();
//   final _interval = 5;

//   InAppWebViewController? _webViewController;
//   bool _fetchingURL = false;
//   bool _verifyingPrepayment = false;
//   Timer? _prepaymentSuccessTimer;
//   String _currentURL = "";

//   Future<void> _checkPrepaymentSuccess() async {
//     if (ref.read(liabilitiesStateProvider).prepaymentFailed ||
//         _verifyingPrepayment) {
//       return;
//     }

//     setState(() {
//       _verifyingPrepayment = true;
//     });

//     bool success = false;
//     int tries = 0;

//     while (!success && tries < 5) {
//       var response = await ref
//           .read(liabilitiesStateProvider.notifier)
//           .checkPrepaymentSuccess(_cancelToken);

//       if (response.success) {
//         success = true;
//       } else {
//         tries++;
//         await Future.delayed(const Duration(seconds: 15));
//       }
//     }

//     if (!mounted) return;

//     if (!success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Prepayment Unsuccessful. Contact Support",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//       return;
//     }

//     setState(() {
//       _verifyingPrepayment = false;
//     });

//     final snackBar = SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.transparent,
//       content: AwesomeSnackbarContent(
//         title: 'Success!',
//         message: "Prepayment Successful",
//         contentType: ContentType.success,
//       ),
//       duration: const Duration(seconds: 5),
//     );

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);

//     var _ = await ref
//         .read(liabilitiesStateProvider.notifier)
//         .fetchLiabilities(_cancelToken);

//     await Future.delayed(const Duration(seconds: 5));

//     if (!mounted) return;

//     context.go(AppRoutes.msme_home_screen);

//     return;
//   }

//   Future<void> _checkPrepaymentSuccessBackground() async {
//     if (ref.read(liabilitiesStateProvider).prepaymentFailed) {
//       return;
//     }

//     bool success = false;
//     int tries = 0;
//     bool hasErrored = false;

//     while (!success && tries < 5) {
//       var response = await ref
//           .read(liabilitiesStateProvider.notifier)
//           .checkPrepaymentSuccess(_cancelToken);

//       if (response.success) {
//         success = true;
//       } else {
//         if (response.data?['error'] ?? false) {
//           hasErrored = true;
//           break;
//         }
//         tries++;
//         await Future.delayed(const Duration(seconds: 15));
//       }
//     }

//     if (!mounted) return;

//     if (hasErrored) {
//       _prepaymentSuccessTimer?.cancel();
//     }

//     if (!success) {
//       return;
//     }

//     final snackBar = SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.transparent,
//       content: AwesomeSnackbarContent(
//         title: 'Success!',
//         message: "Prepayment Successful",
//         contentType: ContentType.success,
//       ),
//       duration: const Duration(seconds: 5),
//     );

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);

//     var _ = await ref
//         .read(liabilitiesStateProvider.notifier)
//         .fetchLiabilities(_cancelToken);

//     await Future.delayed(const Duration(seconds: 5));

//     if (!mounted) return;

//     context.go(AppRoutes.msme_home_screen);
//   }

//   void _startPollingForSuccess() {
//     _prepaymentSuccessTimer =
//         Timer.periodic(Duration(seconds: _interval), (timer) async {
//       await _checkPrepaymentSuccessBackground();
//     });
//   }

//   void _handleNotificationBellPress() {
//     print("Notification Bell Pressed");
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       _webViewController?.loadUrl(
//           urlRequest: URLRequest(url: WebUri(widget.url)));
//       _startPollingForSuccess();
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _prepaymentSuccessTimer?.cancel();
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
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
//                                             'Have you completed the Loan Prepayment successfully?',
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
//                                                     .msme_liability_details);
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
//                                                 _checkPrepaymentSuccess();
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
//                                   // GestureDetector(
//                                   //   onTap: () {
//                                   //     HapticFeedback.mediumImpact();
//                                   //   },
//                                   //   child: Container(
//                                   //     height: 28,
//                                   //     width: 28,
//                                   //     clipBehavior: Clip.antiAlias,
//                                   //     decoration: BoxDecoration(
//                                   //       color: Theme.of(context)
//                                   //           .colorScheme
//                                   //           .onPrimary,
//                                   //       shape: BoxShape.circle,
//                                   //     ),
//                                   //     child: Center(
//                                   //       child: Image.network(
//                                   //         borrowerAccountDetailsRef
//                                   //                 .imageURL.isEmpty
//                                   //             ? "https://placehold.co/30x30/000000/FFFFFF.png"
//                                   //             : borrowerAccountDetailsRef
//                                   //                 .imageURL,
//                                   //         fit: BoxFit.cover,
//                                   //       ),
//                                   //     ),
//                                   //   ),
//                                   // )
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
//                               Text(
//                                 "Loan Prepayment",
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
//                               color: Theme.of(context).colorScheme.surface,
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 topRight: Radius.circular(20),
//                               ),
//                             ),
//                             child: ref
//                                     .watch(liabilitiesStateProvider)
//                                     .prepaymentFailed
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
//                                         "Your Loan Prepayment Failed!",
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h2,
//                                           fontWeight: AppFontWeights.bold,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onSurface,
//                                         ),
//                                       ),
//                                       const SpacerWidget(
//                                         height: 30,
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           HapticFeedback.mediumImpact();
//                                           context.go(
//                                               AppRoutes.msme_liability_details);
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
//                                               "Go Back?",
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
//                                     ],
//                                   )
//                                 : _verifyingPrepayment
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
//                                             "Verifying Prepayment Success...",
//                                             style: TextStyle(
//                                               fontFamily: fontFamily,
//                                               fontSize: AppFontSizes.h2,
//                                               fontWeight: AppFontWeights.bold,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .onSurface,
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
//                                                   .onSurface,
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     : Stack(
//                                         children: [
//                                           _fetchingURL
//                                               ? const LinearProgressIndicator()
//                                               : Container(),
//                                           ClipRRect(
//                                             borderRadius:
//                                                 const BorderRadius.only(
//                                               topLeft: Radius.circular(20),
//                                               topRight: Radius.circular(20),
//                                             ),
//                                             child: InAppWebView(
//                                               key: _prepaymentWebviewKey,
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
//                                                   url: WebUri(_currentURL)),
//                                               onLoadStop: (controller, url) {
//                                                 setState(() {
//                                                   _fetchingURL = false;
//                                                 });
//                                               },
//                                               onWebViewCreated:
//                                                   (controller) async {
//                                                 _webViewController = controller;
//                                                 setState(() {
//                                                   _currentURL = widget.url;
//                                                   _fetchingURL = false;
//                                                 });
//                                                 _webViewController!.loadUrl(
//                                                     urlRequest: URLRequest(
//                                                         url: WebUri(
//                                                             _currentURL)));
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
