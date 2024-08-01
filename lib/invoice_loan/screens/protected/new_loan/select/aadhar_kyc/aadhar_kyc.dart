// import 'dart:async';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state_data.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class NewLoanAadharKYCScreen extends ConsumerStatefulWidget {
//   const NewLoanAadharKYCScreen({super.key});

//   @override
//   ConsumerState<NewLoanAadharKYCScreen> createState() =>
//       _NewLoanAadharKYCScreenState();
// }

// class _NewLoanAadharKYCScreenState
//     extends ConsumerState<NewLoanAadharKYCScreen> {
//   final _cancelToken = CancelToken();
//   final GlobalKey _aadharWebviewKey = GlobalKey();

//   bool _verifyingAadharKYC = false;

//   InAppWebViewController? _webViewController;

//   String currentUrl = "";

//   Future<void> _checkAadharKYCSuccess() async {
//     if (ref.read(newLoanStateProvider).aadharKYCFailure) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Aadhar KYC Unsuccessful. Refetch the KYC URL",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }

//     if (_verifyingAadharKYC) {
//       return;
//     }

//     setState(() {
//       _verifyingAadharKYC = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .checkAadharKycSuccess(_cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       ref.read(newLoanStateProvider.notifier).setVerifyingAadharKYC(false);
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Aadhar KYC Unsuccessful. Contact Support",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//     }

//     if (!mounted) return;

//     setState(() {
//       _verifyingAadharKYC = false;
//     });

//     if (response.data) {
//       ref
//           .read(newLoanStateProvider.notifier)
//           .updateState(NewLoanProgress.aadharKYC);
//       context.go(AppRoutes.msme_new_loan_process);
//     }

//     return;
//   }

//   void _fetchKYCURL() async {
//     if (ref.read(newLoanStateProvider).fetchingAadharKYCURl) return;

//     ref.read(newLoanStateProvider.notifier).setFetchingAadharKYCUrl(true);

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .fetchAadharKycUrl(_cancelToken);

//     ref.read(newLoanStateProvider.notifier).setFetchingAadharKYCUrl(false);

//     if (!mounted) return;

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Unable to fetch Aadhar KYC URL. Contact Support.",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//     } else {
//       _webViewController?.loadUrl(
//           urlRequest: URLRequest(url: WebUri(response.data['url'])));
//     }
//   }

//   Future<void> _refetchKYCURL() async {
//     if (!ref.read(newLoanStateProvider).aadharKYCFailure) {
//       return;
//     }

//     ref.read(newLoanStateProvider.notifier).setFetchingAadharKYCUrl(true);

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .refetchAadharKycUrl(_cancelToken);

//     ref.read(newLoanStateProvider.notifier).setFetchingAadharKYCUrl(false);

//     if (!mounted) return;

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Unable to refetch Aadhar KYC URL. Contact Support.",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//       return;
//     } else {
//       _webViewController?.loadUrl(
//           urlRequest: URLRequest(url: WebUri(response.data)));
//       return;
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       _fetchKYCURL();
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
//                                         _checkAadharKYCSuccess();
//                                       },
//                                       child: Text('Yes',
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: AppFontSizes.h1,
//                                             fontWeight: AppFontWeights.bold,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary,
//                                           )),
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
//                         // _checkAadharKYCSuccess();
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
//                   "Aadhaar KYC",
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
//                     child: ref.watch(newLoanStateProvider).aadharKYCFailure
//                         ? Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               const SpacerWidget(height: 20),
//                               Lottie.asset("assets/animations/error.json",
//                                   height: 200, width: 200),
//                               const SpacerWidget(height: 35),
//                               Text(
//                                 "Your Aadhar KYC Failed!",
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
//                         : _verifyingAadharKYC
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
//                                     "Verifying KYC Success...",
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
//                                   newLoanStateRef.fetchingAadharKYCURl
//                                       ? const LinearProgressIndicator()
//                                       : Container(),
//                                   InAppWebView(
//                                     key: _aadharWebviewKey,
//                                     gestureRecognizers: const <Factory<
//                                         VerticalDragGestureRecognizer>>{},
//                                     initialSettings: InAppWebViewSettings(
//                                       javaScriptEnabled: true,
//                                       verticalScrollBarEnabled: true,
//                                       disableHorizontalScroll: true,
//                                       disableVerticalScroll: false,
//                                     ),
//                                     initialUrlRequest:
//                                         URLRequest(url: WebUri(currentUrl)),
//                                     onWebViewCreated: (controller) async {
//                                       _webViewController = controller;
//                                     },
//                                   ),
//                                 ],
//                               ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
