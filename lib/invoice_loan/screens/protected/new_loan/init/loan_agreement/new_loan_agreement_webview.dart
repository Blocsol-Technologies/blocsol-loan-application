// import 'dart:async';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
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

// class LoanAgreementWebview extends ConsumerStatefulWidget {
//   final String url;
//   const LoanAgreementWebview({super.key, required this.url});

//   @override
//   ConsumerState<LoanAgreementWebview> createState() =>
//       _NewLoanAgreementWebviewState();
// }

// class _NewLoanAgreementWebviewState
//     extends ConsumerState<LoanAgreementWebview> {
//   final _cancelToken = CancelToken();
//   final GlobalKey _agreementWebviewKey = GlobalKey();

//   final bool _loadingAgreementURL = false;

//   InAppWebViewController? _webViewController;

//   String _currentUrl = "";

//   bool _verifyingLoanAgreementSuccess = false;

//   void _checkLoanAgreementSuccess() async {
//     if (ref.read(newLoanStateProvider).loanAgreementFailure) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message:
//               "Loan Aggrement Signature Unsuccessful. Refetch the Agreement URL",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }

//     if (_verifyingLoanAgreementSuccess) {
//       return;
//     }

//     setState(() {
//       _verifyingLoanAgreementSuccess = true;
//     });

//     var loanAgreementSuccessResponse = await ref
//         .read(newLoanStateProvider.notifier)
//         .checkLoanAgreementSuccess(_cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _verifyingLoanAgreementSuccess = true;
//     });

//     if (!loanAgreementSuccessResponse.success) {
//       ref
//           .read(newLoanStateProvider.notifier)
//           .setVerifyingLoanAgreementSuccess(false);
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Loan Repayment Setup Unsuccessful. Contact Support",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }
//   }

//   Future<void> _refetchLoanAgreementURL() async {
//     if (!ref.read(newLoanStateProvider).loanAgreementFailure) {
//       return;
//     }

//     ref.read(newLoanStateProvider.notifier).setLoanAgreementFailure(false);

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .refetchLoanAgreementForm(_cancelToken);

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
//     } else {
//       setState(() {
//         _currentUrl = response.data['url'];
//       });
//       _webViewController?.loadUrl(
//           urlRequest: URLRequest(url: WebUri(response.data)));
//     }
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
//                 RelativeSize.height(0, height)),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () async {
//                           HapticFeedback.mediumImpact();
//                           await showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 backgroundColor:
//                                     Theme.of(context).colorScheme.surface,
//                                 title: Text(
//                                   'Confirm',
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h1,
//                                     fontWeight: AppFontWeights.bold,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface,
//                                   ),
//                                 ),
//                                 content: Text(
//                                   'Have you successfully signed the Agreement?',
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h3,
//                                     fontWeight: AppFontWeights.medium,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface,
//                                   ),
//                                 ),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     onPressed: () {
//                                       context
//                                           .go(AppRoutes.msme_new_loan_process);
//                                     },
//                                     child: Text('Go Back',
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h1,
//                                           fontWeight: AppFontWeights.bold,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .primary,
//                                         )),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(true);
//                                     },
//                                     child: Text('No',
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h1,
//                                           fontWeight: AppFontWeights.bold,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .primary,
//                                         )),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(true);
//                                       _checkLoanAgreementSuccess();
//                                     },
//                                     child: Text('Yes',
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h1,
//                                           fontWeight: AppFontWeights.bold,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .primary,
//                                         )),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         child: Icon(
//                           Icons.arrow_back_outlined,
//                           size: 25,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.65),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           HapticFeedback.mediumImpact();
//                           // context.go(AppRoutes.msmeRaiseNewTicket);
//                           _checkLoanAgreementSuccess();
//                         },
//                         child: Container(
//                           height: 25,
//                           width: 65,
//                           clipBehavior: Clip.antiAlias,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(18),
//                             border: Border.all(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .primary
//                                   .withOpacity(0.75),
//                               width: 1,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Help?",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.extraBold,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SpacerWidget(
//                     height: 35,
//                   ),
//                   Text(
//                     "Loan Agreement",
//                     style: TextStyle(
//                         fontFamily: fontFamily,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         fontSize: AppFontSizes.h1,
//                         fontWeight: AppFontWeights.bold,
//                         letterSpacing: 0.4),
//                     softWrap: true,
//                   ),
//                   const SpacerWidget(
//                     height: 16,
//                   ),
//                   Expanded(
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: ref
//                               .watch(newLoanStateProvider)
//                               .loanAgreementFailure
//                           ? Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 const SpacerWidget(height: 0),
//                                 Lottie.asset("assets/animations/error.json",
//                                     height: 200, width: 200),
//                                 const SpacerWidget(height: 35),
//                                 Text(
//                                   "Your Loan Agreement Failed!",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h2,
//                                     fontWeight: AppFontWeights.bold,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface,
//                                   ),
//                                 ),
//                                 const SpacerWidget(
//                                   height: 30,
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     HapticFeedback.heavyImpact();
//                                     _refetchLoanAgreementURL();
//                                   },
//                                   child: Container(
//                                     height: 30,
//                                     width: 120,
//                                     decoration: BoxDecoration(
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         "Try Again?",
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h3,
//                                           fontWeight: AppFontWeights.medium,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onPrimary,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SpacerWidget(
//                                   height: 30,
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     HapticFeedback.mediumImpact();
//                                     context.go(AppRoutes.msme_new_loan_process);
//                                   },
//                                   child: Container(
//                                     height: 30,
//                                     width: 120,
//                                     decoration: BoxDecoration(
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         "Cancel?",
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h3,
//                                           fontWeight: AppFontWeights.medium,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onPrimary,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             )
//                           : _verifyingLoanAgreementSuccess
//                               ? Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: <Widget>[
//                                     const SpacerWidget(height: 50),
//                                     Lottie.asset(
//                                         "assets/animations/loading_spinner.json",
//                                         height: 250,
//                                         width: 250),
//                                     const SpacerWidget(height: 35),
//                                     Text(
//                                       "Verifying Agreement Success...",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.h2,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface,
//                                       ),
//                                     ),
//                                     Text(
//                                       "Please do not click back or close the app",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.medium,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : Stack(
//                                   children: [
//                                     _loadingAgreementURL
//                                         ? const LinearProgressIndicator()
//                                         : Container(),
//                                     InAppWebView(
//                                       key: _agreementWebviewKey,
//                                       gestureRecognizers: const <Factory<
//                                           VerticalDragGestureRecognizer>>{},
//                                       initialSettings: InAppWebViewSettings(
//                                         javaScriptEnabled: true,
//                                         verticalScrollBarEnabled: true,
//                                         disableHorizontalScroll: true,
//                                         disableVerticalScroll: false,
//                                       ),
//                                       initialUrlRequest:
//                                           URLRequest(url: WebUri(_currentUrl)),
//                                       onWebViewCreated: (controller) async {
//                                         _webViewController = controller;
//                                         _webViewController?.loadUrl(
//                                             urlRequest: URLRequest(
//                                                 url: WebUri(widget.url)));
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                     ),
//                   )
//                 ]),
//           ),
//         ),
//       ),
//     );
//   }
// }
