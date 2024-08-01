// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'package:go_router/go_router.dart';

// class GstConsentModalBottomSheet extends ConsumerStatefulWidget {
//   const GstConsentModalBottomSheet({
//     super.key,
//   });

//   @override
//   ConsumerState<GstConsentModalBottomSheet> createState() =>
//       _GstConsentModalBottomSheetState();
// }

// class _GstConsentModalBottomSheetState
//     extends ConsumerState<GstConsentModalBottomSheet> {
//   final _cancelToken = CancelToken();

//   bool _consentAccepted = false;
//   bool _acceptingConsent = false;

//   Future<void> _provideGstConsent() async {
//     if (!_consentAccepted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please accept the conditions"),
//         ),
//       );
//       return;
//     }

//     if (_acceptingConsent) return;

//     setState(() {
//       _acceptingConsent = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .provideGstConsent(_cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _acceptingConsent = false;
//     });

//     if (response.success) {
//       // if (response.data?['validationRequired']) {
//       //   context.go(AppRoutes.msme_new_loan_gst_otp);
//       // } else {
//       //    context.go(AppRoutes.msme_new_loan_gst_data_downloading);
//       // }

//       context.go(AppRoutes.msme_new_loan_gst_data_downloading);
//       return;
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
//       return;
//     }
//   }

//   @override
//   void dispose() {
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final widdth = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Container(
//       height: 500,
//       width: height,
//       padding: const EdgeInsets.fromLTRB(25, 30, 25, 15),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.primary,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(15.0),
//           topRight: Radius.circular(15.0),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "Share Consent",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h1,
//               fontWeight: AppFontWeights.bold,
//               color: Theme.of(context).colorScheme.onPrimary,
//               letterSpacing: 0.4,
//             ),
//           ),
//           const SpacerWidget(
//             height: 3,
//           ),
//           Text(
//             "Provide consent to share your GST Data. Allow lenders to fetch CIC data",
//             softWrap: true,
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.body,
//               fontWeight: AppFontWeights.normal,
//               color: Theme.of(context).colorScheme.onPrimary,
//               letterSpacing: 0.14,
//             ),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           SizedBox(
//             height: 230,
//             width: widdth,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 20),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.onPrimary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "GST Data Consent",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                         const SpacerWidget(
//                           height: 5,
//                         ),
//                         Text(
//                           "You hereby undertake and confirm that you have permitted and allowed buyer application to pull your GST records - GSTR1, GSTR3B - for the last 12 months from the date of providing consent. You acknowledge and confirm that you have consented to the sharing of your GST Data with the lenders in the platform for the purpose of generating credit offers.",
//                           softWrap: true,
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body2,
//                             fontWeight: AppFontWeights.normal,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SpacerWidget(
//                     height: 15,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 20),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.onPrimary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Credit information company Consent",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                         const SpacerWidget(
//                           height: 5,
//                         ),
//                         Text(
//                           "You hereby undertake and confirm that the information and data furnished by you to the platform is true and correct. The platform has been integrated with lenders who use Credit Information Companies (CIC) to conduct credit checks on body corporates/MSME and Individuals. You acknowledge and confirm that you have consented to the sharing of sensitive data provided by you with such lenders and CICs for the purposes of obtaining the name and account number of banks with whom you have an open cash credit or overdraft account. In addition, you consent to the data being used to facilitate the creation of a credit offer which may include the account to which the funds may be disbursed as per prevailing RBI norms.",
//                           softWrap: true,
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body2,
//                             fontWeight: AppFontWeights.normal,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           const SpacerWidget(
//             height: 20,
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Checkbox(
//                 fillColor: WidgetStateProperty.resolveWith<Color>(
//                     (Set<WidgetState> states) {
//                   if (!states.contains(WidgetState.selected)) {
//                     return Colors.red;
//                   }
//                   // Color when not selected
//                   return Theme.of(context)
//                       .colorScheme
//                       .primary; // Default or any color when selected
//                 }),
//                 checkColor: Theme.of(context).colorScheme.onPrimary,
//                 value: _consentAccepted,
//                 onChanged: (_) {
//                   setState(() {
//                     _consentAccepted = !_consentAccepted;
//                   });
//                 },
//               ),
//               const SizedBox(
//                 width: 2,
//               ),
//               Expanded(
//                 child: Text(
//                   'I understand and agree to buyer app’s Terms',
//                   style: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.normal,
//                     color: Theme.of(context).colorScheme.onPrimary,
//                   ),
//                   softWrap: true,
//                 ),
//               ),
//             ],
//           ),
//           const SpacerWidget(
//             height: 17,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   HapticFeedback.heavyImpact();
//                   _provideGstConsent();
//                 },
//                 child: Container(
//                   height: 40,
//                   width: RelativeSize.width(
//                       252, MediaQuery.of(context).size.width),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.onPrimary,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Center(
//                     child: _acceptingConsent
//                         ? Lottie.asset('assets/animations/loading_spinner.json',
//                             height: 50, width: 50)
//                         : Text(
//                             "Provide Consent",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
