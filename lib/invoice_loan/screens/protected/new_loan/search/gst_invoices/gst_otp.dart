// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/new_loan/components/continue_button.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/regex.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class GstOtpValidation extends ConsumerStatefulWidget {
//   const GstOtpValidation({super.key});

//   @override
//   ConsumerState<GstOtpValidation> createState() => _GstOtpValidationState();
// }

// class _GstOtpValidationState extends ConsumerState<GstOtpValidation> {
//   final _cancelToken = CancelToken();
//   final _otpTextController = TextEditingController();
//   final _textInputFocusNode = FocusNode();

//   bool _verifyingOTP = false;
//   bool _otpVerificationError = false;

//   Future<void> verifyGSTOTP() async {
//     if (!RegexProvider.otpRegex.hasMatch(_otpTextController.text)) {
//       setState(() {
//         _otpVerificationError = true;
//       });
//       return;
//     }

//     if (_verifyingOTP) {
//       return;
//     }

//     setState(() {
//       _verifyingOTP = true;
//       _otpVerificationError = false;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .verifyGstOtp(_otpTextController.text, _cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _verifyingOTP = false;
//     });

//     if (response.success) {
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
//         duration: const Duration(seconds: 5),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }
//   }

//   @override
//   void initState() {
//     _otpTextController.addListener(() {
//       if (RegexProvider.otpRegex.hasMatch(_otpTextController.text)) {
//         _textInputFocusNode.unfocus();
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _otpTextController.dispose();
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final newLoanStateRef = ref.watch(newLoanStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           backgroundColor: Theme.of(context).colorScheme.surface,
//           body: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             padding: EdgeInsets.fromLTRB(
//                 RelativeSize.width(30, width),
//                 RelativeSize.height(30, height),
//                 RelativeSize.width(30, width),
//                 RelativeSize.height(50, height)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       HapticFeedback.mediumImpact();
//                       context.go(AppRoutes.msme_new_loan_process);
//                     },
//                     child: Icon(
//                       Icons.arrow_back_rounded,
//                       size: 25,
//                       color: Theme.of(context)
//                           .colorScheme
//                           .onSurface
//                           .withOpacity(0.65),
//                     ),
//                   ),
//                 ),
//                 const SpacerWidget(height: 32),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: RelativeSize.width(15, width)),
//                   child: Text(
//                     "GST OTP Verification",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h1,
//                       fontWeight: AppFontWeights.extraBold,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     softWrap: true,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Lottie.asset(
//                       "assets/animations/clock.json",
//                       height: 220,
//                       width: 220,
//                     ),
//                   ],
//                 ),
//                 const SpacerWidget(
//                   height: 5,
//                 ),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 25,
//                   ),
//                   decoration: BoxDecoration(
//                     color:
//                         Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(5),
//                     border: Border.all(
//                       color: Theme.of(context).colorScheme.primary,
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Expanded(
//                         child: RichText(
//                           softWrap: true,
//                           textAlign: TextAlign.center,
//                           text: TextSpan(
//                             text: "We have your Invoice Data Till :",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               color: Theme.of(context).colorScheme.primary,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.bold,
//                               letterSpacing: 0.14,
//                             ),
//                             children: [
//                               TextSpan(
//                                 text:
//                                     " ${newLoanStateRef.gstDataDownloadTime} ",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   letterSpacing: 0.14,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.bold,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text:
//                                     "Provide OTP sent to your GST registered phone number.",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   color: Theme.of(context).colorScheme.primary,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.bold,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text:
//                                     "We will fetch latest invoices and send them to the lenders",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   color: Theme.of(context).colorScheme.primary,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.bold,
//                                   letterSpacing: 0.14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 20,
//                 ),
//                 Text(
//                   "Confirm OTP",
//                   style: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.h2,
//                     fontWeight: AppFontWeights.bold,
//                     color: Theme.of(context).colorScheme.onSurface,
//                     letterSpacing: 0.14,
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 13,
//                 ),
//                 TextField(
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.start,
//                   maxLength: 10,
//                   controller: _otpTextController,
//                   onChanged: (val) {
//                     setState(() {
//                       _otpVerificationError = false;
//                     });
//                   },
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   style: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.bold,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   textDirection: TextDirection.ltr,
//                   focusNode: _textInputFocusNode,
//                   decoration: InputDecoration(
//                     counterText: "",
//                     hintText: 'OTP',
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//                     hintStyle: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.body,
//                       fontWeight: AppFontWeights.normal,
//                       color: Theme.of(context).colorScheme.scrim,
//                     ),
//                     fillColor:
//                         Theme.of(context).colorScheme.scrim.withOpacity(0.1),
//                     filled: true,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: _otpVerificationError
//                             ? Theme.of(context).colorScheme.error
//                             : Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 25,
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ContinueButton(
//                         onPressed: () async {
//                           await verifyGSTOTP();
//                         },
//                         text: "Verify OTP",
//                       )
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
