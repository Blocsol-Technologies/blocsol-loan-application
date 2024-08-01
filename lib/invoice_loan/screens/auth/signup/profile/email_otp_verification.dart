// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/auth/signup/utils/support_click.dart';
// import 'package:blocsol_invoice_based_credit/state/auth/signup/signup_state.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/utils/regex.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'dart:math' as math;
// import 'package:go_router/go_router.dart';

// class SignupEmailOtpValidation extends ConsumerStatefulWidget {
//   const SignupEmailOtpValidation({super.key});

//   @override
//   ConsumerState<SignupEmailOtpValidation> createState() =>
//       _SignupEmailOtpValidationState();
// }

// class _SignupEmailOtpValidationState
//     extends ConsumerState<SignupEmailOtpValidation> {
//   final _otpTextInputController = TextEditingController();
//   final _otpTextInputFocusNode = FocusNode();
//   final _cancelToken = CancelToken();

//   bool _otpVerificationError = false;
//   bool _verifyingOTP = false;
//   bool _resendingOTP = false;

//   Future<void> _verifyEmailOTP() async {
//     if (_verifyingOTP) return;

//     setState(() {
//       _verifyingOTP = true;
//     });

//     var response = await ref
//         .read(signupStateProvider.notifier)
//         .verifyEmailOTP(_otpTextInputController.text, _cancelToken);

//     setState(() {
//       _verifyingOTP = false;
//     });

//     if (!mounted) return;

//     if (response.success) {
//       context.go(AppRoutes.signup_email_validation);
//       return;
//     }

//     setState(() {
//       _otpVerificationError = true;
//     });

//     final snackBar = SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.transparent,
//       content: AwesomeSnackbarContent(
//         title: 'Error!',
//         message: response.message,
//         contentType: ContentType.failure,
//       ),
//       duration: const Duration(seconds: 5),
//     );

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);

//     return;
//   }

//   Future<void> _resendEmailOTP() async {
//     if (_resendingOTP) return;

//     setState(() {
//       _resendingOTP = true;
//     });

//     var response = await ref
//         .read(signupStateProvider.notifier)
//         .sendEmailOTP(ref.read(signupStateProvider).email, _cancelToken);

//     setState(() {
//       _resendingOTP = false;
//     });

//     if (!mounted) return;

//     if (!response.success) {
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
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       if (RegexProvider.otpRegex.hasMatch(_otpTextInputController.text)) {
//         _otpTextInputFocusNode.unfocus();
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _otpTextInputController.dispose();
//     _otpTextInputFocusNode.dispose();
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return SafeArea(
//         child: Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       body: SizedBox(
//         height: height,
//         width: width,
//         child: ClipRRect(
//           clipBehavior: Clip.antiAlias,
//           child: Stack(
//             children: [
//               Positioned(
//                 top: RelativeSize.height(68, height),
//                 right: RelativeSize.width(10, width),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               Positioned(
//                 top: RelativeSize.height(90, height),
//                 right: RelativeSize.width(31, width),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               Positioned(
//                 top: RelativeSize.height(65, height),
//                 right: RelativeSize.width(15, width),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Theme.of(context).colorScheme.onPrimary,
//                       width: 1,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: RelativeSize.height(85, height),
//                 right: RelativeSize.width(38, width),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Theme.of(context).colorScheme.onPrimary,
//                       width: 1,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: -75,
//                 left: -30,
//                 child: Transform(
//                   alignment: Alignment.center,
//                   transform:
//                       Matrix4.rotationZ(math.pi / 20), // 30 degrees in radians
//                   child: Container(
//                     width: width * 2,
//                     height: RelativeSize.height(670, height),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Theme.of(context).colorScheme.onPrimary,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: -80,
//                 left: -30,
//                 child: Transform(
//                   alignment: Alignment.center,
//                   transform:
//                       Matrix4.rotationZ(math.pi / 20), // 30 degrees in radians
//                   child: Container(
//                     width: width * 2,
//                     height: RelativeSize.height(670, height),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.onPrimary,
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: height,
//                 width: width,
//                 padding: EdgeInsets.fromLTRB(
//                     RelativeSize.width(20, width),
//                     RelativeSize.height(20, height),
//                     RelativeSize.width(20, width),
//                     RelativeSize.height(55, height)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             HapticFeedback.mediumImpact();
//                             context.go(AppRoutes.signup_mobile_validation);
//                           },
//                           icon: Icon(
//                             Icons.arrow_back_rounded,
//                             size: 25,
//                             color: Theme.of(context).colorScheme.onPrimary,
//                           ),
//                         ),
//                         const Expanded(
//                           child: SizedBox(),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             HapticFeedback.mediumImpact();
//                             handleSupportClick(context);
//                           },
//                           icon: Icon(
//                             Icons.support_agent,
//                             size: 25,
//                             color: Theme.of(context).colorScheme.onPrimary,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SpacerWidget(
//                       height: 50,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(22, width)),
//                       child: Text(
//                         "Verify Email Address",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h1,
//                           fontWeight: AppFontWeights.medium,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 5,
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.only(left: RelativeSize.width(22, width)),
//                       child: Text(
//                         "OTP sent to email *****${ref.read(signupStateProvider).email.substring(5)}",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.normal,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(22, width)),
//                       child: TextField(
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.start,
//                         maxLength: 6,
//                         controller: _otpTextInputController,
//                         onChanged: (val) {
//                           setState(() {
//                             _otpVerificationError = false;
//                           });
//                         },
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                         textDirection: TextDirection.ltr,
//                         focusNode: _otpTextInputFocusNode,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                         decoration: InputDecoration(
//                           counterText: "",
//                           hintText: 'OTP',
//                           contentPadding:
//                               const EdgeInsets.symmetric(horizontal: 15),
//                           hintStyle: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.normal,
//                             color: Theme.of(context).colorScheme.scrim,
//                           ),
//                           fillColor: Theme.of(context)
//                               .colorScheme
//                               .scrim
//                               .withOpacity(0.1),
//                           filled: true,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: _otpVerificationError
//                                   ? Theme.of(context).colorScheme.error
//                                   : Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SpacerWidget(height: 8),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(22, width)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           RichText(
//                             text: TextSpan(
//                               text: "Didn't receive OTP?",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                                 fontSize: AppFontSizes.body2,
//                                 fontWeight: AppFontWeights.medium,
//                               ),
//                               children: [
//                                 TextSpan(
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//                                       HapticFeedback.lightImpact();
//                                       _resendEmailOTP();
//                                     },
//                                   text: " Resend OTP",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     fontSize: AppFontSizes.body2,
//                                     fontWeight: AppFontWeights.medium,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     _verifyingOTP
//                         ? Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Lottie.asset(
//                                   'assets/animations/loading_spinner.json',
//                                   height: 60,
//                                   width: 60),
//                               const SpacerWidget(width: 5),
//                               Text(
//                                 "Verifying OTP...",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.normal,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                 ),
//                               ),
//                             ],
//                           )
//                         : const SizedBox(),
//                     _resendingOTP
//                         ? Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Lottie.asset(
//                                   'assets/animations/loading_spinner.json',
//                                   height: 60,
//                                   width: 60),
//                               const SpacerWidget(width: 5),
//                               Text(
//                                 "Resending OTP...",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.normal,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurface,
//                                 ),
//                               ),
//                             ],
//                           )
//                         : const SizedBox(),
//                     const Expanded(child: SizedBox()),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             HapticFeedback.heavyImpact();

//                             if (!RegexProvider.otpRegex
//                                 .hasMatch(_otpTextInputController.text)) return;

//                             _verifyEmailOTP();
//                           },
//                           child: Container(
//                             width: RelativeSize.width(250, width),
//                             height: RelativeSize.height(40, height),
//                             decoration: BoxDecoration(
//                               color: RegexProvider.otpRegex
//                                       .hasMatch(_otpTextInputController.text)
//                                   ? Theme.of(context).colorScheme.primary
//                                   : Theme.of(context).colorScheme.secondary,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Verify",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.medium,
//                                   color: RegexProvider.otpRegex.hasMatch(
//                                           _otpTextInputController.text)
//                                       ? Theme.of(context).colorScheme.onPrimary
//                                       : Theme.of(context).colorScheme.scrim,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }
