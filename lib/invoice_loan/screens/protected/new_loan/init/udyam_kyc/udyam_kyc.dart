// import 'dart:async';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:lottie/lottie.dart';

// class NewLoanUdyamKYCScreen extends ConsumerStatefulWidget {
//   const NewLoanUdyamKYCScreen({super.key});

//   @override
//   ConsumerState<NewLoanUdyamKYCScreen> createState() =>
//       _NewLoanUdyamKYCScreenState();
// }

// class _NewLoanUdyamKYCScreenState extends ConsumerState<NewLoanUdyamKYCScreen> {
//   final _cancelToken = CancelToken();
//   final GlobalKey _webViewKey = GlobalKey();

//   InAppWebViewController? _webViewController;
//   String _currentUrl = "";
//   bool _verifyingUdyamKYC = false;

//   void _checkUdyamKYCSuccess() async {
//     if (ref.read(newLoanStateProvider).udyamKYCFailure) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Udyam KYC Unsuccessful. Refetch the KYC URL",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }

//     if (_verifyingUdyamKYC) {
//       return;
//     }

//     setState(() {
//       _verifyingUdyamKYC = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .checkUdyamKycFormSuccess(_cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _verifyingUdyamKYC = false;
//     });

//     if (!response.success) {
//       ref.read(newLoanStateProvider.notifier).setVerifyingUdyamKYC(false);
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Udyam KYC Unsuccessful. Contact Support",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }

//     return;
//   }

//   void _fetchUdyamKYCURL() async {
//     if (ref.read(newLoanStateProvider).fetchingUdyamKYCURl) return;

//     ref.read(newLoanStateProvider.notifier).setFetchingUdyamKYCUrl(true);

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .fetchUdyamKycForm(_cancelToken);

//     ref.read(newLoanStateProvider.notifier).setFetchingUdyamKYCUrl(false);

//     if (!mounted) return;

//     if (response.success) {
//       _webViewController?.loadUrl(
//           urlRequest: URLRequest(url: WebUri(response.data['url'])));
//       setState(() {
//         _currentUrl = response.data['url'];
//       });
//     } else {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Unable to fetch UDYAM KYC URL. Contact Support.",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//     }
//   }

//   Future<void> _refetchKYCURL() async {
//     if (!ref.read(newLoanStateProvider).udyamKYCFailure) {
//       return;
//     }

//     ref.read(newLoanStateProvider.notifier).setUdyamKYCFailure(false);
//     ref.read(newLoanStateProvider.notifier).setFetchingAadharKYCUrl(true);

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .refetchUdyamKycForm(_cancelToken);

//     ref.read(newLoanStateProvider.notifier).setFetchingAadharKYCUrl(false);

//     if (mounted) {
//       if (!response.success) {
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: 'Error!',
//             message: "Unable to refetch Udyam Aadhar KYC URL. Contact Support.",
//             contentType: ContentType.failure,
//           ),
//           duration: const Duration(seconds: 15),
//         );

//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(snackBar);
//       } else {
//         _webViewController?.loadUrl(
//             urlRequest: URLRequest(url: WebUri(response.data['url'])));
//       }
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       _fetchUdyamKYCURL();
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
//     final newLoanStateRef = ref.watch(newLoanStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);
//     ref.watch(loanEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.fromLTRB(
//                 RelativeSize.width(20, width),
//                 RelativeSize.height(20, height),
//                 RelativeSize.width(20, width),
//                 RelativeSize.height(50, height)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     GestureDetector(
//                       onTap: () async {
//                         HapticFeedback.mediumImpact();
//                         await showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.surface,
//                                   title: Text(
//                                     'Confirm',
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       fontSize: AppFontSizes.h1,
//                                       fontWeight: AppFontWeights.bold,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                     ),
//                                   ),
//                                   content: Text(
//                                     'Have you completed the KYC successfully?',
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       fontSize: AppFontSizes.h3,
//                                       fontWeight: AppFontWeights.medium,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                     ),
//                                   ),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () {
//                                         context.go(
//                                             AppRoutes.msme_new_loan_process);
//                                       },
//                                       child: Text('Go Back',
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.h1,
//                                             fontWeight: AppFontWeights.bold,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary,
//                                           )),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop(true);
//                                       },
//                                       child: Text('No',
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.h1,
//                                             fontWeight: AppFontWeights.bold,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary,
//                                           )),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop(true);
//                                         _checkUdyamKYCSuccess();
//                                       },
//                                       child: Text(
//                                         'Yes',
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h1,
//                                           fontWeight: AppFontWeights.bold,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .primary,
//                                         ),
//                                       ),
//                                     ),
//                                   ]);
//                             });
//                       },
//                       child: Icon(
//                         Icons.arrow_back_outlined,
//                         size: 25,
//                         color: Theme.of(context)
//                             .colorScheme
//                             .onSurface
//                             .withOpacity(0.65),
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         HapticFeedback.mediumImpact();
//                         context.go(AppRoutes.msme_raise_new_ticket);
//                       },
//                       child: Container(
//                         height: 25,
//                         width: 65,
//                         clipBehavior: Clip.antiAlias,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18),
//                           border: Border.all(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .primary
//                                 .withOpacity(0.75),
//                             width: 1,
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Help?",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.extraBold,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SpacerWidget(height: 22),
//                 Text(
//                   "Udyam KYC",
//                   style: TextStyle(
//                       fontFamily: fontFamily,
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontSize: AppFontSizes.h1,
//                       fontWeight: AppFontWeights.bold,
//                       letterSpacing: 0.4),
//                   softWrap: true,
//                 ),
//                 const SpacerWidget(
//                   height: 15,
//                 ),
//                 Expanded(
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: ref.watch(newLoanStateProvider).udyamKYCFailure
//                         ? Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               const SpacerWidget(height: 20),
//                               Lottie.asset("assets/animations/error.json",
//                                   height: 200, width: 200),
//                               const SpacerWidget(height: 35),
//                               Text(
//                                 "Your Udyam KYC Failed!",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.h2,
//                                   fontWeight: AppFontWeights.bold,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 height: 30,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   _refetchKYCURL();
//                                 },
//                                 child: Container(
//                                   height: 30,
//                                   width: 120,
//                                   decoration: BoxDecoration(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "Try Again?",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.medium,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onPrimary,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SpacerWidget(
//                                 height: 30,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   HapticFeedback.mediumImpact();
//                                   context.go(AppRoutes.msme_new_loan_process);
//                                 },
//                                 child: Container(
//                                   height: 30,
//                                   width: 120,
//                                   decoration: BoxDecoration(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "Cancel?",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.h3,
//                                         fontWeight: AppFontWeights.medium,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onPrimary,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                         : _verifyingUdyamKYC
//                             ? Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   const SpacerWidget(height: 50),
//                                   Lottie.asset(
//                                       "assets/animations/loading_spinner.json",
//                                       height: 250,
//                                       width: 250),
//                                   const SpacerWidget(height: 35),
//                                   Text(
//                                     "Verifying UDYAM Success...",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       fontSize: AppFontSizes.h2,
//                                       fontWeight: AppFontWeights.bold,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Please do not click back or close the app",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       fontSize: AppFontSizes.body,
//                                       fontWeight: AppFontWeights.medium,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : Stack(
//                                 children: [
//                                   newLoanStateRef.fetchingUdyamKYCURl
//                                       ? const LinearProgressIndicator()
//                                       : Container(),
//                                   InAppWebView(
//                                     key: _webViewKey,
//                                     gestureRecognizers: const <Factory<
//                                         VerticalDragGestureRecognizer>>{},
//                                     initialSettings: InAppWebViewSettings(
//                                       javaScriptEnabled: true,
//                                       verticalScrollBarEnabled: true,
//                                       disableHorizontalScroll: true,
//                                       disableVerticalScroll: false,
//                                     ),
//                                     initialUrlRequest:
//                                         URLRequest(url: WebUri(_currentUrl)),
//                                     onWebViewCreated: (controller) async {
//                                       _webViewController = controller;
//                                     },
//                                   ),
//                                 ],
//                               ),
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
