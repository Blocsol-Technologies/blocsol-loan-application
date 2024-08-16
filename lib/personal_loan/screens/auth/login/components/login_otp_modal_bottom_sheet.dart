// import 'dart:io';

// import 'package:blocsol_personal_credit/state/auth/auth_state.dart';
// import 'package:blocsol_personal_credit/state/auth/login_state/login_state.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:blocsol_personal_credit/utils/regex.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:go_router/go_router.dart';

// class LoginOTPModalBottomSheet extends ConsumerStatefulWidget {
//   final String phoneNumber;

//   const LoginOTPModalBottomSheet({super.key, required this.phoneNumber});

//   @override
//   ConsumerState<LoginOTPModalBottomSheet> createState() =>
//       _LoginOTPModalBottomSheetState();
// }

// class _LoginOTPModalBottomSheetState
//     extends ConsumerState<LoginOTPModalBottomSheet> with CodeAutoFill {
//   bool _isAndroid = false;
//   bool _codeAutoFilled = false;
//   String _signature = "";

//   bool _verifyingOTP = false;
//   bool _errorOccured = false;
//   String _errorString = "";

//   final _otpTextInputController = TextEditingController();
//   final _textInputFocusNode = FocusNode();
//   final _otpCancelToken = CancelToken();

//   bool _resendingOTP = false;
//   String _resendingOtpString = "Resend OTP?";

//   Future<void> _validateOTP() async {
//     if (_verifyingOTP || _resendingOTP) {
//       return;
//     }

//     setState(() {
//       _verifyingOTP = true;
//       _errorOccured = false;
//       _errorString = "";
//       _codeAutoFilled = true;
//     });

//     var response = await ref
//         .read(loginStateProvider.notifier)
//         .verifyMobileOTP(_otpTextInputController.text, _otpCancelToken);

//     if (mounted) {
//       if (response.success) {
//         await ref
//             .read(authStateProvider.notifier)
//             .setAuthToken(response.data['token']);
//         if (mounted) {
//           context.go(AppRoutes.pc_home_screen);
//         }
//       } else {
//         setState(() {
//           _verifyingOTP = false;
//           _errorOccured = true;
//           _errorString = response.message;
//         });
//       }
//     }
//   }

//   void _resendOTP() async {
//     if (_resendingOTP || _verifyingOTP) {
//       return;
//     }

//     setState(() {
//       _resendingOTP = true;
//       _resendingOtpString = "Sending OTP ...";
//       _errorOccured = false;
//       _errorString = "";
//       _codeAutoFilled = true;
//     });

//     var response = await ref
//         .read(loginStateProvider.notifier)
//         .resendOTP(_signature, _otpCancelToken);

//     if (!context.mounted) return;

//     if (response.success) {
//       setState(() {
//         _resendingOTP = false;
//         _resendingOtpString = "OTP Sent ...";
//       });

//       Future.delayed(const Duration(seconds: 3), () {
//         if (!context.mounted) return;
//         setState(() {
//           _resendingOtpString = "Resend OTP?";
//         });
//       });

//       return;
//     } else {
//       setState(() {
//         _resendingOTP = false;
//         _resendingOtpString = "Resend OTP?";
//         _errorOccured = true;
//         _errorString = response.message;
//       });
//       return;
//     }
//   }

//   void _addSignature() async {
//     String sign = await SmsAutoFill().getAppSignature;
//     if (Platform.isAndroid) {
//       setState(() {
//         _isAndroid = true;
//         _signature = sign;
//       });
//     } else {
//       setState(() {
//         _isAndroid = false;
//         _signature = sign;
//       });
//     }

//     await SmsAutoFill().listenForCode();
//   }

//   @override
//   void codeUpdated() {
//     _otpTextInputController.text = code!;
//     setState(() {
//       _codeAutoFilled = true;
//     });
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _addSignature();
//     });
//     _textInputFocusNode.requestFocus();
//     _otpTextInputController.addListener(() {
//       if (RegexProvider.otpRegex.hasMatch(_otpTextInputController.text)) {
//         _textInputFocusNode.unfocus();
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     SmsAutoFill().unregisterListener();
//     _otpCancelToken.cancel();
//     _textInputFocusNode.dispose();
//     _otpTextInputController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 310,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.fromLTRB(25, 25, 25, 40),
//       color: Theme.of(context).colorScheme.primary,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "OTP sent to mobile number ${widget.phoneNumber}",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.body,
//               fontWeight: AppFontWeights.normal,
//               color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
//               letterSpacing: 0.14,
//             ),
//           ),
//           const SpacerWidget(
//             height: 10,
//           ),
//           Text(
//             "VERIFY ACCOUNT",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h2,
//               fontWeight: AppFontWeights.bold,
//               color: Theme.of(context).colorScheme.onPrimary,
//               letterSpacing: 0.14,
//             ),
//           ),
//           const SizedBox(
//             height: 13,
//           ),
//           TextField(
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.start,
//             controller: _otpTextInputController,
//             maxLength: 6,
//             onChanged: (val) {
//               setState(() {
//                 _codeAutoFilled = true;
//                 _errorOccured = false;
//               });
//             },
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.body,
//               fontWeight: AppFontWeights.bold,
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//             textDirection: TextDirection.ltr,
//             focusNode: _textInputFocusNode,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             cursorColor: Theme.of(context).colorScheme.onPrimary,
//             decoration: InputDecoration(
//               counterText: "",
//               hintText: '6 digit OTP',
//               contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//               hintStyle: TextStyle(
//                 fontFamily: fontFamily,
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.normal,
//                 color: Theme.of(context).colorScheme.scrim,
//               ),
//               fillColor: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
//               filled: true,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: _errorOccured
//                       ? Theme.of(context).colorScheme.error
//                       : Theme.of(context).colorScheme.onPrimary,
//                 ),
//               ),
//             ),
//           ),
//           const SpacerWidget(
//             height: 10,
//           ),
//           GestureDetector(
//             onTap: () {
//               _resendOTP();
//             },
//             child: Text(
//               _resendingOtpString,
//               style: TextStyle(
//                 fontFamily: fontFamily,
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.medium,
//                 color: Theme.of(context).colorScheme.onPrimary,
//               ),
//             ),
//           ),
//           const SpacerWidget(
//             height: 5,
//           ),
//           SizedBox(
//             height: 50,
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 _isAndroid && !_codeAutoFilled
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Lottie.asset('assets/animations/loading_spinner.json',
//                               height: 50, width: 50),
//                           Text(
//                             "Auto Reading OTP...",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onPrimary
//                                   .withOpacity(0.5),
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.medium,
//                             ),
//                           ),
//                         ],
//                       )
//                     : const SizedBox(),
//                 _errorOccured
//                     ? Text(
//                         _errorString,
//                         softWrap: true,
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.normal,
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       )
//                     : const SizedBox(),
//               ],
//             ),
//           ),
//           const SpacerWidget(
//             height: 5,
//           ),
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.heavyImpact();
//               _validateOTP();
//             },
//             child: Container(
//               height: 40,
//               width: RelativeSize.width(230, MediaQuery.of(context).size.width),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.onPrimary,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Center(
//                 child: _verifyingOTP
//                     ? Lottie.asset('assets/animations/loading_spinner.json',
//                         height: 50, width: 50)
//                     : Text(
//                         "VERIFY OTP",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }