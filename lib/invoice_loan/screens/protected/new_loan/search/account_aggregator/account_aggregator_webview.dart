// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state_data.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:lottie/lottie.dart';

// class AccountAggregatorWebview extends ConsumerStatefulWidget {
//   final String url;
//   const AccountAggregatorWebview({super.key, required this.url});

//   @override
//   ConsumerState<AccountAggregatorWebview> createState() =>
//       _NewLoanAccountAggregatorWebviewScreenState();
// }

// class _NewLoanAccountAggregatorWebviewScreenState
//     extends ConsumerState<AccountAggregatorWebview> {
//   final _cancelToken = CancelToken();
//   final GlobalKey webViewKey = GlobalKey();

//   InAppWebViewController? _webViewController;
//   bool _loading = true;
//   String _currentUrl = "";
//   bool _checkingConsentSuccess = false;
//   bool _checkConsentError = false;

//   void _checkConsentSuccess(String? ecres, String? resdate) async {
//     if (_checkingConsentSuccess) return;

//     setState(() {
//       _checkingConsentSuccess = true;
//       _checkConsentError = false;
//     });

//     if (ecres == null || resdate == null) {
//       if (mounted) {
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: 'On Snap!',
//             message: "Unable to confirm consent creation.",
//             contentType: ContentType.failure,
//           ),
//           duration: const Duration(seconds: 10),
//         );

//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(snackBar);

//         setState(() {
//           _checkingConsentSuccess = false;
//           _checkConsentError = true;
//         });

//         return;
//       }
//     }

//     var checkConsentResponse = await ref
//         .read(newLoanStateProvider.notifier)
//         .checkConsentSuccess(ecres!, resdate!, _cancelToken);

//     if (!checkConsentResponse.success) {
//       if (mounted) {
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: 'On Snap!',
//             message: "Unable to confirm consent creation.",
//             contentType: ContentType.failure,
//           ),
//           duration: const Duration(seconds: 20),
//         );

//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(snackBar);

//         setState(() {
//           _checkingConsentSuccess = false;
//           _checkConsentError = true;
//         });

//         return;
//       }
//     }

//     ref
//         .read(newLoanStateProvider.notifier)
//         .updateState(NewLoanProgress.bankConsent);

//     if (!mounted) return;

//     setState(() {
//       _checkingConsentSuccess = true;
//     });

//     context.go(AppRoutes.msme_new_loan_process);
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _webViewController?.loadUrl(
//         urlRequest: URLRequest(
//           url: WebUri(widget.url),
//         ),
//       );
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final _ = ref.watch(serverSentEventStateProvider);

//     print("current url $_currentUrl");
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Theme.of(context).colorScheme.surface,
//           resizeToAvoidBottomInset: false,
//           body: Container(
//             padding: EdgeInsets.fromLTRB(
//                 RelativeSize.width(20, width),
//                 RelativeSize.height(20, height),
//                 RelativeSize.width(20, width),
//                 RelativeSize.height(20, height)),
//             child: _checkConsentError
//                 ? SizedBox(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         const SpacerWidget(height: 10),
//                         Lottie.asset("assets/animations/error.json",
//                             height: 200, width: 200),
//                         const SpacerWidget(height: 20),
//                         SizedBox(
//                           width: 300,
//                           child: Text(
//                             "You did not provide AA consent for the lenders. You need to restart the loan process",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.h3,
//                               fontWeight: AppFontWeights.bold,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                             softWrap: true,
//                           ),
//                         ),
//                         const SpacerWidget(
//                           height: 50,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             ref.read(newLoanStateProvider.notifier).reset();
//                             context.go(AppRoutes.msme_new_loan_process);
//                           },
//                           child: Container(
//                             height: 40,
//                             width: 120,
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.primary,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Restart",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.h2,
//                                   fontWeight: AppFontWeights.medium,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ))
//                 : _checkingConsentSuccess
//                     ? SizedBox(
//                         height: MediaQuery.of(context).size.height,
//                         width: MediaQuery.of(context).size.width,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             const SpacerWidget(height: 50),
//                             Lottie.asset(
//                                 "assets/animations/loading_spinner.json",
//                                 height: 300,
//                                 width: 300),
//                             const SpacerWidget(height: 35),
//                             Text(
//                               "Verifying Consent Success...",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h2,
//                                 fontWeight: AppFontWeights.bold,
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                             Text(
//                               "Please do not click back or close the app",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                           ],
//                         ))
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               GestureDetector(
//                                 onTap: () async {
//                                   HapticFeedback.mediumImpact();
//                                   context.go(AppRoutes.msme_new_loan_process);
//                                 },
//                                 child: Icon(
//                                   Icons.arrow_back_outlined,
//                                   size: 25,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface
//                                       .withOpacity(0.65),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Container(),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   HapticFeedback.mediumImpact();
//                                   context.go(AppRoutes.msme_raise_new_ticket);
//                                 },
//                                 child: Container(
//                                   height: 25,
//                                   width: 65,
//                                   clipBehavior: Clip.antiAlias,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(18),
//                                     border: Border.all(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .primary
//                                           .withOpacity(0.75),
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "Help?",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.extraBold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .primary,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SpacerWidget(height: 22),
//                           Text(
//                             "Provide consent",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.title,
//                               fontWeight: AppFontWeights.extraBold,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                             softWrap: true,
//                           ),
//                           const SpacerWidget(
//                             height: 10,
//                           ),
//                           Text(
//                             "You might be asked to create an account if it doesnt exist!",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.h3,
//                               fontWeight: AppFontWeights.normal,
//                               color: Theme.of(context).colorScheme.onSurface,
//                               letterSpacing: 0.14,
//                             ),
//                             softWrap: true,
//                           ),
//                           const SpacerWidget(
//                             height: 15,
//                           ),
//                           Expanded(
//                             child: SizedBox(
//                               width: MediaQuery.of(context).size.width,
//                               child: Stack(
//                                 children: [
//                                   _loading
//                                       ? const LinearProgressIndicator()
//                                       : Container(),
//                                   InAppWebView(
//                                     key: webViewKey,
//                                     gestureRecognizers: const <Factory<
//                                         VerticalDragGestureRecognizer>>{},
//                                     initialSettings: InAppWebViewSettings(
//                                       javaScriptEnabled: true,
//                                       verticalScrollBarEnabled: true,
//                                       disableHorizontalScroll: true,
//                                       disableVerticalScroll: false,
//                                     ),
//                                     onLoadStop: (controller, url) {
//                                       setState(() {
//                                         _loading = false;
//                                         _currentUrl = url.toString();
//                                       });
//                                     },
//                                     initialUrlRequest: URLRequest(
//                                       url: WebUri(widget.url),
//                                     ),
//                                     shouldOverrideUrlLoading:
//                                         (controller, navigationAction) async {
//                                       var uri = navigationAction.request.url;

//                                       if (uri != null &&
//                                           uri.toString().contains(
//                                               'https://ondc.invoicepe.in/aa-redirect')) {
//                                         // Extract query parameters
//                                         String? ecres =
//                                             uri.queryParameters['ecres'];
//                                         String? resdate =
//                                             uri.queryParameters['resdate'];

//                                         _checkConsentSuccess(ecres, resdate);
//                                       }
//                                       return NavigationActionPolicy.ALLOW;
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//           ),
//         ),
//       ),
//     );
//   }
// }
