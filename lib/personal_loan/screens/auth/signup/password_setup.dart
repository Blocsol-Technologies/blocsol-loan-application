// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_personal_credit/state/auth/auth_state.dart';
// import 'package:blocsol_personal_credit/state/auth/signup_state/signup_state.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class PCSignupPasswordSetup extends ConsumerStatefulWidget {
//   const PCSignupPasswordSetup({super.key});

//   @override
//   ConsumerState<PCSignupPasswordSetup> createState() =>
//       _PCSignupPasswordSetupState();
// }

// class _PCSignupPasswordSetupState extends ConsumerState<PCSignupPasswordSetup> {
//   final _enterPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _enterPasswordFocusNode = FocusNode();
//   final _confirmPasswordFocusNode = FocusNode();
//   final _cancelToken = CancelToken();

//   bool _enterPasswordVisible = false;
//   bool _confirmPasswordVisible = false;
//   bool _creatingAccount = false;

//   Future<void> _createAccount() async {
//     setState(() {
//       _creatingAccount = true;
//     });

//     if (_confirmPasswordFocusNode.hasFocus) _confirmPasswordFocusNode.unfocus();
//     if (_enterPasswordFocusNode.hasFocus) _enterPasswordFocusNode.unfocus();

//     if (_confirmPasswordController.text != _enterPasswordController.text) {
//       setState(() {
//         _creatingAccount = false;
//       });

//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Passwords do not match",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 5),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }

//     var response = await ref
//         .read(signupStateProvider.notifier)
//         .setPassword(_confirmPasswordController.text, _cancelToken);

//     if (!mounted) return;

//     setState(() {
//       _creatingAccount = false;
//     });

//     if (response.success) {
//       await ref
//           .read(authStateProvider.notifier)
//           .setAuthToken(response.data['token']);

//       if (!mounted) return;

//       context.go(AppRoutes.pc_home_screen);
//       return;
//     }

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
//     _enterPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     _enterPasswordFocusNode.dispose();
//     _confirmPasswordFocusNode.dispose();
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
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(
//                 width: width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
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
//                 "Password Setup",
//                 style: TextStyle(
//                   fontFamily: fontFamily,
//                   fontSize: AppFontSizes.h1,
//                   fontWeight: AppFontWeights.medium,
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               const SpacerWidget(height: 5),
//               Text(
//                 "Your account password must be atleast 8 characters and have 1 Uppercase, 1 Number and 1 Special Character.",
//                 softWrap: true,
//                 style: TextStyle(
//                   fontFamily: fontFamily,
//                   fontSize: AppFontSizes.body,
//                   fontWeight: AppFontWeights.normal,
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               const SpacerWidget(height: 30),
//               // Enter Password
//               Container(
//                 height: 40,
//                 width: width,
//                 padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     SizedBox(
//                       height: 30,
//                       width: RelativeSize.width(250, width),
//                       child: Center(
//                         child: TextField(
//                           obscureText: !_enterPasswordVisible,
//                           keyboardType: TextInputType.text,
//                           textAlign: TextAlign.start,
//                           maxLength: 20,
//                           controller: _enterPasswordController,
//                           focusNode: _enterPasswordFocusNode,
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                           textDirection: TextDirection.ltr,
//                           decoration: InputDecoration(
//                             counterText: "",
//                             hintText: 'Password',
//                             contentPadding:
//                                 const EdgeInsets.symmetric(horizontal: 0),
//                             hintStyle: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.normal,
//                               color: Theme.of(context).colorScheme.scrim,
//                             ),
//                             border: const OutlineInputBorder(
//                                 borderSide: BorderSide.none),
//                           ),
//                         ),
//                       ),
//                     ),
//                     _enterPasswordVisible
//                         ? IconButton(
//                             icon: Icon(
//                               Icons.visibility,
//                               size: 20,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _enterPasswordVisible = false;
//                               });
//                             },
//                           )
//                         : IconButton(
//                             icon: Icon(
//                               Icons.visibility_off,
//                               size: 20,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _enterPasswordVisible = true;
//                               });
//                             },
//                           )
//                   ],
//                 ),
//               ),
//               const SpacerWidget(height: 30),

//               // Confirm Password
//               Container(
//                 height: 40,
//                 width: width,
//                 padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     SizedBox(
//                       height: 30,
//                       width: RelativeSize.width(250, width),
//                       child: Center(
//                         child: TextField(
//                           keyboardType: TextInputType.text,
//                           textAlign: TextAlign.start,
//                           maxLength: 20,
//                           obscureText: !_confirmPasswordVisible,
//                           controller: _confirmPasswordController,
//                           focusNode: _confirmPasswordFocusNode,
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                           textDirection: TextDirection.ltr,
//                           decoration: InputDecoration(
//                             counterText: "",
//                             hintText: 'Confirm Password',
//                             contentPadding:
//                                 const EdgeInsets.symmetric(horizontal: 0),
//                             hintStyle: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.normal,
//                               color: Theme.of(context).colorScheme.scrim,
//                             ),
//                             border: const OutlineInputBorder(
//                                 borderSide: BorderSide.none),
//                           ),
//                         ),
//                       ),
//                     ),
//                     _confirmPasswordVisible
//                         ? IconButton(
//                             icon: Icon(
//                               Icons.visibility,
//                               size: 20,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _confirmPasswordVisible = false;
//                               });
//                             },
//                           )
//                         : IconButton(
//                             icon: Icon(
//                               Icons.visibility_off,
//                               size: 20,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _confirmPasswordVisible = true;
//                               });
//                             },
//                           )
//                   ],
//                 ),
//               ),

//               const Expanded(child: SizedBox()),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: () {
//                       HapticFeedback.heavyImpact();
//                       _createAccount();
//                     },
//                     child: Container(
//                       width: RelativeSize.width(250, width),
//                       height: RelativeSize.height(40, height),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.primary,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Center(
//                         child: _creatingAccount
//                             ? Lottie.asset(
//                                 'assets/animations/loading_spinner.json',
//                                 height: 50,
//                                 width: 50)
//                             : Text(
//                                 "Continue",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.medium,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                 ),
//                               ),
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
