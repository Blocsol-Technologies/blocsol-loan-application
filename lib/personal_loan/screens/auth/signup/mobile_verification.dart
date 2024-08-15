// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_personal_credit/state/auth/signup_state/signup_state.dart';
// import 'package:blocsol_personal_credit/utils/regex.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'package:go_router/go_router.dart';

// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:sms_autofill/sms_autofill.dart';

// class PCSignupMobileAuth extends ConsumerStatefulWidget {
//   const PCSignupMobileAuth({super.key});

//   @override
//   ConsumerState<PCSignupMobileAuth> createState() => _PCSignupMobileAuthState();
// }

// class _PCSignupMobileAuthState extends ConsumerState<PCSignupMobileAuth> {
//   final _phoneTextInputController = TextEditingController();
//   final _phoneTextInputFocusNode = FocusNode();
//   final _cancelToken = CancelToken();

//   String _deviceSignature = "";
//   bool _phoneVerificationError = false;
//   bool _sendingOTP = false;

//   Future<void> _sendMobileOTP() async {
//     if (_sendingOTP) return;

//     setState(() {
//       _sendingOTP = true;
//     });

//     var response = await ref.read(signupStateProvider.notifier).sendMobileOTP(
//         _phoneTextInputController.text, _deviceSignature, _cancelToken);

//     setState(() {
//       _sendingOTP = false;
//     });

//     if (!mounted) return;

//     if (response.success) {
//       context.go(AppRoutes.pc_signup_mobile_otp_auth);
//       return;
//     }

//     setState(() {
//       _phoneVerificationError = true;
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

//   void addSignature() async {
//     String sign = await SmsAutoFill().getAppSignature;
//     setState(() {
//       _deviceSignature = sign;
//     });
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       addSignature();
//     });
//     _phoneTextInputFocusNode.requestFocus();
//     _phoneTextInputController.addListener(() {
//       if (RegexProvider.phoneRegex.hasMatch(_phoneTextInputController.text)) {
//         _phoneTextInputFocusNode.unfocus();
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _phoneTextInputController.dispose();
//     _phoneTextInputFocusNode.dispose();
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;

//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         body: Container(
//           padding: EdgeInsets.fromLTRB(
//             RelativeSize.width(25, width),
//             RelativeSize.height(30, height),
//             RelativeSize.width(35, width),
//             RelativeSize.height(30, height),
//           ),
//           height: height,
//           width: width,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(
//                 width: width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(
//                         Icons.arrow_back_rounded,
//                         color: Theme.of(context).colorScheme.onBackground,
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         HapticFeedback.mediumImpact();
//                         context.go(AppRoutes.pc_signup_home);
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         Icons.support_agent_outlined,
//                         color: Theme.of(context).colorScheme.onBackground,
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         // TODO: Implement Support Click
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SpacerWidget(height: 45),
//               Text(
//                 "Verify your Mobile Number",
//                 style: TextStyle(
//                   fontFamily: fontFamily,
//                   fontSize: AppFontSizes.h1,
//                   fontWeight: AppFontWeights.medium,
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               const SpacerWidget(height: 20),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 textAlign: TextAlign.start,
//                 maxLength: 10,
//                 controller: _phoneTextInputController,
//                 onChanged: (val) {
//                   setState(() {
//                     _phoneVerificationError = false;
//                   });
//                 },
//                 style: TextStyle(
//                   fontFamily: fontFamily,
//                   fontSize: AppFontSizes.body,
//                   fontWeight: AppFontWeights.bold,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 textDirection: TextDirection.ltr,
//                 focusNode: _phoneTextInputFocusNode,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 decoration: InputDecoration(
//                   counterText: "",
//                   hintText: 'Phone Number',
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//                   hintStyle: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.normal,
//                     color: Theme.of(context).colorScheme.scrim,
//                   ),
//                   fillColor:
//                       Theme.of(context).colorScheme.scrim.withOpacity(0.1),
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: _phoneVerificationError
//                           ? Theme.of(context).colorScheme.error
//                           : Theme.of(context).colorScheme.primary,
//                     ),
//                   ),
//                 ),
//               ),
//               const SpacerWidget(height: 5),
//               _sendingOTP
//                   ? Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Lottie.asset('assets/animations/loading_spinner.json',
//                             height: 60, width: 60),
//                         const SpacerWidget(width: 5),
//                         Text(
//                           "Sending OTP...",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.normal,
//                             color: Theme.of(context).colorScheme.onBackground,
//                           ),
//                         ),
//                       ],
//                     )
//                   : const SizedBox(),
//               const Expanded(child: SizedBox()),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       HapticFeedback.heavyImpact();
//                       _sendMobileOTP();
//                     },
//                     child: Container(
//                       width: RelativeSize.width(250, width),
//                       height: RelativeSize.height(40, height),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.primary,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Verify Number",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.medium,
//                             color: Theme.of(context).colorScheme.onPrimary,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
