// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/new_loan/init/loan_agreement/otp_modal_bottom_sheet.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/lender_utils.dart';
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

// class NewLoanAgreement extends ConsumerStatefulWidget {
//   const NewLoanAgreement({super.key});

//   @override
//   ConsumerState<NewLoanAgreement> createState() => _NewLoanAgreementState();
// }

// class _NewLoanAgreementState extends ConsumerState<NewLoanAgreement> {
//   final _cancelToken = CancelToken();
//   final GlobalKey _agreementWebviewKey = GlobalKey();

//   InAppWebViewController? _webViewController;

//   Future<void> _iAgreeClickHandler(BuildContext context) async {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(20),
//           ),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         context: context,
//         builder: (context) {
//           return Padding(
//             padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom),
//             child: LoanAgreementOTPModalBottomSheet(
//               onSubmit: (String otp) {
//                 _submitAndVerifyLoanAgreementSuccess(otp);
//               },
//             ),
//           );
//         });
//   }

//   void _submitAndVerifyLoanAgreementSuccess(String otp) async {
//     if (ref.read(newLoanStateProvider).verifyingAadharKYC) {
//       return;
//     }

//     ref
//         .read(newLoanStateProvider.notifier)
//         .setVerifyingLoanAgreementSuccess(true);

//     var submitForm07Response = await ref
//         .read(newLoanStateProvider.notifier)
//         .submitLoanAgreementForm(otp, _cancelToken);

//     if (!mounted) return;

//     if (!submitForm07Response.success) {
//       ref.read(newLoanStateProvider.notifier).setVerifyingAadharKYC(false);
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Unable to submit OTP. Contact Support",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 15),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//       return;
//     }

//     ref
//         .read(newLoanStateProvider.notifier)
//         .setVerifyingLoanAgreementSuccess(false);
//   }

//   void _fetchLoanAgreementURL() async {
//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .fetchLoanAgreementUrl(_cancelToken);

//     if (!mounted) return;

//     if (response.success) {
//       if (response.data['redirect_form']) {
//         context.go(AppRoutes.msme_new_loan_agreement_webview,
//             extra: response.data['url']);
//         return;
//       }

//       _webViewController?.loadUrl(
//           urlRequest: URLRequest(url: WebUri(response.data['url'])));
//     } else {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Unable to fetch Loan Agreement URL. Contact Support.",
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

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchLoanAgreementURL();
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
//     final selectedOffer = newLoanStateRef.selectedOffer;
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
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () async {
//                           HapticFeedback.mediumImpact();
//                           context.go(AppRoutes.msme_new_loan_process);
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
//                           context.go(AppRoutes.msme_raise_new_ticket);
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
//                 ),
//                 const SpacerWidget(
//                   height: 32,
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 40,
//                         child: getLenderDetailsAssetURL(
//                             selectedOffer.bankName, selectedOffer.bankLogoURL),
//                       ),
//                       const SpacerWidget(
//                         width: 10,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 20,
//                 ),
//                 Text(
//                   "Loan Agreement",
//                   style: TextStyle(
//                       fontFamily: fontFamily,
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontSize: AppFontSizes.h1,
//                       fontWeight: AppFontWeights.bold,
//                       letterSpacing: 0.4),
//                   softWrap: true,
//                 ),
//                 const SpacerWidget(
//                   height: 16,
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Deposit A/c :",
//                       style: TextStyle(
//                           fontFamily: fontFamily,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.normal,
//                           letterSpacing: 0.14),
//                       softWrap: true,
//                     ),
//                     const SpacerWidget(
//                       width: 8,
//                     ),
//                     SizedBox(
//                       height: 25,
//                       child: getLenderDetailsAssetURL(newLoanStateRef.bankName,
//                           newLoanStateRef.selectedOffer.bankLogoURL),
//                     ),
//                     const SpacerWidget(
//                       width: 8,
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             newLoanStateRef.bankName,
//                             style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.medium,
//                                 letterSpacing: 0.165),
//                           ),
//                           Text(
//                             "Acc No - ${newLoanStateRef.bankAccountNumber}",
//                             style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurface
//                                     .withOpacity(0.35),
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 letterSpacing: 0.15),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SpacerWidget(
//                   height: 35,
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 20, horizontal: 10),
//                     width: MediaQuery.of(context).size.width,
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onSurface
//                         .withOpacity(0.03),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         GestureDetector(
//                           onTap: () async {
//                             HapticFeedback.mediumImpact();
//                             // TODO: Implement loan agreement download functionality
//                           },
//                           child: Container(
//                             height: 35,
//                             width: 150,
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.surface,
//                               border: Border.all(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.download,
//                                   color: Theme.of(context).colorScheme.primary,
//                                   size: 25,
//                                 ),
//                                 const SpacerWidget(
//                                   width: 5,
//                                 ),
//                                 Text(
//                                   "Download",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     fontSize: AppFontSizes.h2,
//                                     fontWeight: AppFontWeights.extraBold,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SpacerWidget(
//                           height: 25,
//                         ),
//                         Expanded(
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: newLoanStateRef.verifyingLoanAgreementSuccess
//                                 ? Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Lottie.asset(
//                                           "assets/animations/loading_spinner.json",
//                                           height: 150,
//                                           width: 150),
//                                       const SpacerWidget(height: 35),
//                                       Text(
//                                         "Verifying...",
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.h2,
//                                           fontWeight: AppFontWeights.bold,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onSurface,
//                                         ),
//                                       ),
//                                       Text(
//                                         "Please do not click back or close the app",
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           fontSize: AppFontSizes.body,
//                                           fontWeight: AppFontWeights.medium,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onSurface,
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : InAppWebView(
//                                     key: _agreementWebviewKey,
//                                     gestureRecognizers: const <Factory<
//                                         VerticalDragGestureRecognizer>>{},
//                                     initialSettings: InAppWebViewSettings(
//                                       javaScriptEnabled: true,
//                                       verticalScrollBarEnabled: true,
//                                       disableHorizontalScroll: true,
//                                       disableVerticalScroll: false,
//                                     ),
//                                     initialUrlRequest:
//                                         URLRequest(url: WebUri("")),
//                                     onWebViewCreated: (controller) async {
//                                       _webViewController = controller;
//                                     },
//                                   ),
//                           ),
//                         ),
//                       ],
//                     ),
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
