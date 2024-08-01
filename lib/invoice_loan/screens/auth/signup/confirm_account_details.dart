// import 'package:blocsol_invoice_based_credit/screens/user/auth/signup/utils/support_click.dart';
// import 'package:blocsol_invoice_based_credit/state/auth/signup/signup_state.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class SignupConfirmAccountDetails extends ConsumerWidget {
//   const SignupConfirmAccountDetails({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return SafeArea(
//         child: Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: SizedBox(
//         height: height,
//         width: width,
//         child: Container(
//           height: height,
//           width: width,
//           padding: EdgeInsets.fromLTRB(
//               RelativeSize.width(20, width),
//               RelativeSize.height(30, height),
//               RelativeSize.width(20, width),
//               RelativeSize.height(30, height)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Expanded(
//                     child: SizedBox(),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       HapticFeedback.mediumImpact();
//                       handleSupportClick(context);
//                     },
//                     icon: Icon(
//                       Icons.support_agent,
//                       size: 25,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                 ],
//               ),
//               const SpacerWidget(
//                 height: 35,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: RelativeSize.width(22, width)),
//                 child: Text(
//                   "Confirm Details",
//                   style: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.h1,
//                     fontWeight: AppFontWeights.medium,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//               ),
//               const SpacerWidget(
//                 height: 10,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: RelativeSize.width(22, width)),
//                 child: Text(
//                   "Please confirm if the business details mentioned are correct",
//                   style: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.normal,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//               ),
//               const SpacerWidget(
//                 height: 25,
//               ),
//               ClipPath(
//                 clipper: BottomClipper(),
//                 child: Container(
//                   width: width,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: RelativeSize.width(27, width),
//                       vertical: RelativeSize.height(30, height)),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.secondary,
//                   ),
//                   child: Column(
//                     children: [
//                       // Legal Name
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Legal Business Name:",
//                               softWrap: true,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: AppFontWeights.normal,
//                                 fontSize: AppFontSizes.body,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               ref.read(signupStateProvider).companyLegalName,
//                               softWrap: true,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontSize: AppFontSizes.body,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),

//                       // Place of Business
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Place of Registration:",
//                               softWrap: true,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: AppFontWeights.normal,
//                                 fontSize: AppFontSizes.body,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               ref.read(signupStateProvider).companyLegalName,
//                               softWrap: true,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontSize: AppFontSizes.body,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),

//                       // GST
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "GSTIN:",
//                               softWrap: true,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: AppFontWeights.normal,
//                                 fontSize: AppFontSizes.body,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               ref.read(signupStateProvider).gstNumber,
//                               softWrap: true,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontSize: AppFontSizes.body,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       // GST Registration Date
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Registration Date:",
//                               softWrap: true,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: AppFontWeights.normal,
//                                 fontSize: AppFontSizes.body,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               ref.read(signupStateProvider).gstRegistrationDate,
//                               softWrap: true,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: AppFontWeights.bold,
//                                 fontSize: AppFontSizes.body,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               ClipPath(
//                 clipper: TopClipper(),
//                 child: Container(
//                   padding: EdgeInsets.fromLTRB(
//                       RelativeSize.width(42.5, width),
//                       RelativeSize.height(60, width),
//                       RelativeSize.width(42.5, width),
//                       RelativeSize.height(45, width)),
//                   width: width,
//                   height: RelativeSize.height(250, height),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         color: Theme.of(context).colorScheme.onPrimary,
//                         height: 2,
//                         width: width,
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       Container(
//                         color: Theme.of(context).colorScheme.onPrimary,
//                         height: 2,
//                         width: width,
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       Container(
//                         color: Theme.of(context).colorScheme.onPrimary,
//                         height: 2,
//                         width: width,
//                       ),
//                       const Expanded(
//                         child: SizedBox(),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           HapticFeedback.heavyImpact();
//                           context.go(AppRoutes.msme_home_screen);
//                         },
//                         child: Container(
//                           width: RelativeSize.width(250, width),
//                           height: RelativeSize.height(40, height),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.onPrimary,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Confirm",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }

// class BottomClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();

//     double sideRadius = 15.0;
//     double midPoint = size.height;
//     double cornerRadius = 15.0;

//     path.moveTo(0, cornerRadius);
//     path.lineTo(0, (midPoint - sideRadius));

//     //LEFT ARC
//     path.quadraticBezierTo(
//         sideRadius, midPoint - sideRadius, sideRadius, midPoint);
//     path.quadraticBezierTo(
//         sideRadius, midPoint + sideRadius, 0, midPoint + sideRadius);

//     path.lineTo(size.width, (midPoint + sideRadius));

//     //RIGHT ARC
//     path.quadraticBezierTo((size.width - sideRadius), (midPoint + sideRadius),
//         (size.width - sideRadius), (midPoint));
//     path.quadraticBezierTo((size.width - sideRadius), (midPoint - sideRadius),
//         size.width, midPoint - sideRadius);

//     path.lineTo(size.width, cornerRadius);

//     //TopRight
//     path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);

//     path.lineTo(cornerRadius, 0);

//     //TopLeft
//     path.quadraticBezierTo(0, 0, 0, cornerRadius);

//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// class TopClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();

//     double sideRadius = 15.0;
//     double midPoint = 0;
//     double cornerRadius = 15.0;

//     path.moveTo(cornerRadius, 0);

//     // LEFT ARC
//     path.quadraticBezierTo(
//         0 + sideRadius, (midPoint + sideRadius), 0, sideRadius);
//     // path.quadraticBezierTo(
//     //     sideRadius, midPoint - sideRadius, 0, midPoint - sideRadius);

//     path.lineTo(0, size.height - cornerRadius);

//     //BottomLeft
//     path.quadraticBezierTo(0, size.height, cornerRadius, size.height);

//     path.lineTo(size.width - cornerRadius, size.height);

//     //BottomRight
//     path.quadraticBezierTo(
//         size.width, size.height, size.width, size.height - cornerRadius);

//     path.lineTo(size.width, (midPoint + sideRadius));

//     //RIGHT ARC
//     path.quadraticBezierTo((size.width - sideRadius), (midPoint + sideRadius),
//         (size.width - sideRadius), (midPoint));
//     // path.quadraticBezierTo((size.width - sideRadius), (midPoint - sideRadius),
//     //     size.width, midPoint - sideRadius);

//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
