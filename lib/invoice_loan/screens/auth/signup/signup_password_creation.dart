// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/auth/signup/utils/support_click.dart';
// import 'package:blocsol_invoice_based_credit/state/auth/signup/signup_state.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/utils/regex.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dart:math' as math;

// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class SignupPasswordCreation extends ConsumerStatefulWidget {
//   const SignupPasswordCreation({super.key});

//   @override
//   ConsumerState<SignupPasswordCreation> createState() =>
//       _SignupPasswordCreationState();
// }

// class _SignupPasswordCreationState
//     extends ConsumerState<SignupPasswordCreation> {
//   bool _creatingAccount = false;
//   bool _isError = false;

//   final _cancelToken = CancelToken();
//   final _passwordEditingController = TextEditingController();
//   final _textInputFocusNode = FocusNode();
//   bool _showPassword = false;

//   void _setPassword() async {
//     if (_creatingAccount) {
//       return;
//     }

//     await HapticFeedback.heavyImpact();

//     setState(() {
//       _creatingAccount = true;
//       _isError = false;
//     });

//     var response = await ref
//         .read(signupStateProvider.notifier)
//         .setAccountPassword(_cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _creatingAccount = false;
//       _isError = false;
//     });

//     if (response.success) {
//       setState(() {
//         _creatingAccount = false;
//         _isError = false;
//       });

//       context.go(AppRoutes.signup_confirm_account);
//       return;
//     }
//     setState(() {
//       _creatingAccount = false;
//       _isError = true;
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

//   @override
//   void dispose() {
//     _textInputFocusNode.dispose();
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
//                             context.go(AppRoutes.signup_intro);
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
//                         "Set Account Password",
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
//                         "Password must have atleast 1 uppercase, 1 lowercase, 1 number and 1 special character",
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
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(22, width)),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               keyboardType: TextInputType.visiblePassword,
//                               textAlign: TextAlign.start,
//                               maxLength: 50,
//                               obscureText: !_showPassword,
//                               controller: _passwordEditingController,
//                               onChanged: (val) {
//                                 setState(() {
//                                   _isError = false;
//                                 });
//                               },
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.bold,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                               textDirection: TextDirection.ltr,
//                               focusNode: _textInputFocusNode,
//                               decoration: InputDecoration(
//                                 counterText: "",
//                                 hintText: 'Password',
//                                 contentPadding:
//                                     const EdgeInsets.symmetric(horizontal: 15),
//                                 hintStyle: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.normal,
//                                   color: Theme.of(context).colorScheme.scrim,
//                                 ),
//                                 fillColor: Theme.of(context)
//                                     .colorScheme
//                                     .scrim
//                                     .withOpacity(0.1),
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: _isError
//                                         ? Theme.of(context).colorScheme.error
//                                         : Theme.of(context).colorScheme.primary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SpacerWidget(
//                             width: 5,
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               HapticFeedback.lightImpact();
//                               setState(() {
//                                 _showPassword = !_showPassword;
//                               });
//                             },
//                             icon: _showPassword
//                                 ? Icon(
//                                     Icons.visibility,
//                                     size: 25,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .surface,
//                                   )
//                                 : Icon(
//                                     Icons.visibility_off,
//                                     size: 25,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .surface,
//                                   ),
//                           )
//                         ],
//                       ),
//                     ),
//                     _creatingAccount
//                         ? Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Lottie.asset(
//                                   'assets/animations/loading_spinner.json',
//                                   height: 60,
//                                   width: 60),
//                               Text(
//                                 "Creating Account...",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   color: Theme.of(context).colorScheme.scrim,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.medium,
//                                 ),
//                               ),
//                             ],
//                           )
//                         : Container(),
//                     const Expanded(
//                       child: SizedBox(),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             HapticFeedback.heavyImpact();
//                             if (!RegexProvider.passwordRegex
//                                 .hasMatch(_passwordEditingController.text)) {
//                               return;
//                             }
//                             _setPassword();
//                           },
//                           child: Container(
//                             width: RelativeSize.width(250, width),
//                             height: RelativeSize.height(40, height),
//                             decoration: BoxDecoration(
//                               color: RegexProvider.passwordRegex
//                                       .hasMatch(_passwordEditingController.text)
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
//                                   color: RegexProvider.passwordRegex.hasMatch(
//                                           _passwordEditingController.text)
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
