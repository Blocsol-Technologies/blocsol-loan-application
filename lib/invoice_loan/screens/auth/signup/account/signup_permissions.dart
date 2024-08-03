// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/auth/signup/utils/support_click.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';

// class SignupPermissions extends StatefulWidget {
//   const SignupPermissions({super.key});

//   @override
//   State<SignupPermissions> createState() => _PCSignupMobilePermissionsState();
// }

// class _PCSignupMobilePermissionsState extends State<SignupPermissions> {
//   Future<void> _requestPermissions() async {
//     Map<Permission, PermissionStatus> statuses =
//         await [Permission.locationWhenInUse, Permission.camera].request();

//     var allGranted = true;
//     statuses.forEach((permission, status) {
//       if (!status.isGranted) {
//         allGranted = false;
//       }
//     });

//     if (!allGranted && mounted) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: "Please allow all permissions to continue.",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 5),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);

//       return;
//     }

//     if (mounted) context.go(AppRoutes.signup_mobile_validation);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: SingleChildScrollView(
//           padding: EdgeInsets.fromLTRB(
//             RelativeSize.width(25, width),
//             RelativeSize.height(30, height),
//             RelativeSize.width(35, width),
//             RelativeSize.height(30, height),
//           ),
//           physics: const BouncingScrollPhysics(),
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
//                         color: Theme.of(context).colorScheme.onSurface,
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         HapticFeedback.mediumImpact();
//                         context.go(AppRoutes.signup_intro);
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         Icons.support_agent_outlined,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         HapticFeedback.mediumImpact();
//                         handleSupportClick(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SpacerWidget(height: 45),
//               Text(
//                 "App Permissions",
//                 style: TextStyle(
//                   fontFamily: fontFamily,
//                   fontSize: AppFontSizes.h1,
//                   fontWeight: AppFontWeights.medium,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SpacerWidget(height: 5),
//               Text(
//                 "For the purpose of sharing relevant information with the lenders, we need the following permissions from you.",
//                 softWrap: true,
//                 style: TextStyle(
//                   fontFamily: fontFamily,
//                   fontSize: AppFontSizes.body,
//                   fontWeight: AppFontWeights.normal,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SpacerWidget(height: 40),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Icon(
//                     Icons.message,
//                     size: 30,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   const SpacerWidget(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "SMS",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                         const SpacerWidget(height: 5),
//                         Text(
//                           "Our app reads your SMS inbox in order to auto-verify OTP's. We also send you relavant messages and updates via SMS. We do not read any personal messages.",
//                           softWrap: true,
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.normal,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SpacerWidget(height: 30),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Icon(
//                     Icons.location_on_outlined,
//                     size: 30,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   const SpacerWidget(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "Location",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                         const SpacerWidget(height: 5),
//                         Text(
//                           "Our app reads your current location to provide you with the best offers and services available in your area. This information is shared with the lenders",
//                           softWrap: true,
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.normal,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SpacerWidget(height: 30),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Icon(
//                     Icons.camera_alt,
//                     size: 30,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   const SpacerWidget(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "Camera",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.h3,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                         const SpacerWidget(height: 5),
//                         Text(
//                           "Our app uses your camera to scan your documents and verify your identity during the KYC process. We do not store any images or videos from your camera.",
//                           softWrap: true,
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.normal,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SpacerWidget(height: 60),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     width: RelativeSize.width(252, width),
//                     height: RelativeSize.height(40, height),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: TextButton(
//                       onPressed: () {
//                         HapticFeedback.heavyImpact();
//                         _requestPermissions();
//                       },
//                       child: Text(
//                         "Allow Permissions",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onPrimary,
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
