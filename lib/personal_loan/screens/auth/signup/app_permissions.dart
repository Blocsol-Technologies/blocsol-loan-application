// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PCSignupMobilePermissions extends StatefulWidget {
//   const PCSignupMobilePermissions({super.key});

//   @override
//   State<PCSignupMobilePermissions> createState() =>
//       _PCSignupMobilePermissionsState();
// }

// class _PCSignupMobilePermissionsState extends State<PCSignupMobilePermissions> {
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

//     if (mounted) context.go(AppRoutes.pc_signup_personal_details);
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
//                         color: Theme.of(context).colorScheme.onBackground,
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         HapticFeedback.mediumImpact();
//                         context.go(AppRoutes.pc_signup_mobile_auth);
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
//                 "App Permissions",
//                 style: TextStyle(
//                   fontFamily: fontFamily,
//                   fontSize: AppFontSizes.h1,
//                   fontWeight: AppFontWeights.medium,
//                   color: Theme.of(context).colorScheme.onBackground,
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
//                   color: Theme.of(context).colorScheme.onBackground,
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
//                             color: Theme.of(context).colorScheme.onBackground,
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
//                             color: Theme.of(context).colorScheme.onBackground,
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
//                             color: Theme.of(context).colorScheme.onBackground,
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
//                             color: Theme.of(context).colorScheme.onBackground,
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
//                             color: Theme.of(context).colorScheme.onBackground,
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
//                             color: Theme.of(context).colorScheme.onBackground,
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
