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
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:lottie/lottie.dart';

// class PCNewLoanAAWebview extends ConsumerStatefulWidget {
//   final String url;
//   const PCNewLoanAAWebview({super.key, required this.url});

//   @override
//   ConsumerState<PCNewLoanAAWebview> createState() => _PCNewLoanAAWebviewState();
// }

// class _PCNewLoanAAWebviewState extends ConsumerState<PCNewLoanAAWebview> {
//   final GlobalKey _webViewKey = GlobalKey();
//   final _cancelToken = CancelToken();
//   final _urlController = TextEditingController();

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
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'On Snap!',
//           message: "Unable to confirm consent creation.",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 10),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       setState(() {
//         _checkingConsentSuccess = false;
//         _checkConsentError = true;
//       });
//     }

//     var checkConsentResponse = await ref
//         .read(newLoanStateProvider.notifier)
//         .checkConsentSuccess(ecres!, resdate!, _cancelToken);

//     if (!mounted) return;

//     if (!checkConsentResponse.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'On Snap!',
//           message: "Unable to confirm consent creation.",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 20),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       setState(() {
//         _checkingConsentSuccess = false;
//         _checkConsentError = true;
//       });

//       return;
//     }

//     ref
//         .read(newLoanStateProvider.notifier)
//         .updateState(NewLoanProgress.bankConsent);

//     setState(() {
//       _checkingConsentSuccess = false;
//     });

//     context.go(AppRoutes.pc_new_loan_process);
//   }

//   void _handleNotificationBellPress() {
//     print("Notification Bell Pressed");
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _webViewController?.loadUrl(
//         urlRequest: URLRequest(
//           url: WebUri(_currentUrl),
//         ),
//       );
//     });

//     setState(() {
//       _currentUrl = widget.url;
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final borrowerAccountDetailsRef =
//         ref.watch(borrowerAccountDetailsStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           body: Stack(
//             children: [
//               Container(
//                 width: width,
//                 height: RelativeSize.height(235, height),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primary,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(40),
//                     bottomRight: Radius.circular(40),
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(
//                     vertical: RelativeSize.height(20, height)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(30, width)),
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
//                         child: Center(
//                           child: Text(
//                             "Account Aggregator Consent",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.h1,
//                               fontWeight: AppFontWeights.medium,
//                               color: Theme.of(context).colorScheme.onPrimary,
//                             ),
//                             textAlign: TextAlign.center,
//                             softWrap: true,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 30,
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(15, width),
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Theme.of(context).colorScheme.background),
//                           padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
//                           child: _checkConsentError
//                               ? Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 20),
//                                   height: height,
//                                   width: width,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Lottie.asset(
//                                           "assets/animations/error.json",
//                                           height: 200,
//                                           width: 200),
//                                       const SpacerWidget(height: 20),
//                                       Text(
//                                         "You did not provide AA consent for the lenders. You need to restart the loan process",
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h3,
//                                           fontWeight: AppFontWeights.bold,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onBackground,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                         softWrap: true,
//                                       ),
//                                       const SpacerWidget(
//                                         height: 70,
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           HapticFeedback.mediumImpact();
//                                           ref
//                                               .read(
//                                                   newLoanStateProvider.notifier)
//                                               .reset();
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
//                                               "Restart",
//                                               style: TextStyle(
//                                                 fontFamily: fontFamily,
//                                                 fontSize: AppFontSizes.h3,
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
//                                   ))
//                               : _checkingConsentSuccess
//                                   ? Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 20, vertical: 20),
//                                       height: height,
//                                       width: width,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: <Widget>[
//                                           Lottie.asset(
//                                               "assets/animations/loading_spinner.json",
//                                               height: 250,
//                                               width: 250),
//                                           const SpacerWidget(height: 35),
//                                           Text(
//                                             "Verifying Consent Success...",
//                                             style: TextStyle(
//                                               fontFamily: fontFamily,
//                                               fontSize: AppFontSizes.h3,
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
//                                       ))
//                                   : Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Expanded(
//                                           child: SizedBox(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             child: Stack(
//                                               children: [
//                                                 _loading
//                                                     ? const LinearProgressIndicator()
//                                                     : Container(),
//                                                 InAppWebView(
//                                                   key: _webViewKey,
//                                                   gestureRecognizers: const <Factory<
//                                                       VerticalDragGestureRecognizer>>{},
//                                                   initialSettings:
//                                                       InAppWebViewSettings(
//                                                     javaScriptEnabled: true,
//                                                     verticalScrollBarEnabled:
//                                                         true,
//                                                     disableHorizontalScroll:
//                                                         true,
//                                                     disableVerticalScroll:
//                                                         false,
//                                                   ),
//                                                   onWebViewCreated:
//                                                       (controller) {
//                                                     _webViewController =
//                                                         controller;
//                                                   },
//                                                   onLoadStop:
//                                                       (controller, url) {
//                                                     setState(() {
//                                                       _loading = false;
//                                                       _currentUrl =
//                                                           url.toString();
//                                                       _urlController.text =
//                                                           _currentUrl;
//                                                     });
//                                                   },
//                                                   initialUrlRequest: URLRequest(
//                                                     url: WebUri(_currentUrl),
//                                                   ),
//                                                   shouldOverrideUrlLoading:
//                                                       (controller,
//                                                           navigationAction) async {
//                                                     var uri = navigationAction
//                                                         .request.url;

//                                                     if (uri != null &&
//                                                         uri.toString().contains(
//                                                             'https://ondc.invoicepe.in/aa-redirect')) {
//                                                       // Extract query parameters
//                                                       String? ecres =
//                                                           uri.queryParameters[
//                                                               'ecres'];
//                                                       String? resdate =
//                                                           uri.queryParameters[
//                                                               'resdate'];

//                                                       _checkConsentSuccess(
//                                                           ecres, resdate);
//                                                     }
//                                                     return NavigationActionPolicy
//                                                         .ALLOW;
//                                                   },
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
