// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';

// class SignupIntro extends StatelessWidget {
//   const SignupIntro({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       body: SizedBox(
//         height: height,
//         width: width,
//         child: ClipRRect(
//           clipBehavior: Clip.antiAlias,
//           child: Stack(
//             children: [
//               Positioned(
//                 top: RelativeSize.height(38, height),
//                 right: RelativeSize.width(10, width),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               Positioned(
//                 top: RelativeSize.height(60, height),
//                 right: RelativeSize.width(31, width),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               Positioned(
//                 top: RelativeSize.height(35, height),
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
//                 top: RelativeSize.height(55, height),
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
//                 bottom: -53,
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
//                 bottom: -58,
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
//                 padding: EdgeInsets.all(RelativeSize.width(20, width)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SpacerWidget(
//                       height: RelativeSize.height(110, height),
//                     ),
//                     Text(
//                       "Instant Loan on",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.emphasis,
//                         fontWeight: AppFontWeights.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     Text(
//                       "GST Invoices!",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.emphasis,
//                         fontWeight: AppFontWeights.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     SpacerWidget(
//                       height: RelativeSize.height(20, height),
//                     ),
//                     Text(
//                       "Get collateral-free loans against your",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h3,
//                         fontWeight: AppFontWeights.normal,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     Text(
//                       "GST Invoices in less than 5 minutes",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h3,
//                         fontWeight: AppFontWeights.normal,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     SpacerWidget(
//                       height: RelativeSize.height(30, height),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 19,
//                         vertical: 35,
//                       ),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.tertiary,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Image.asset(
//                                   'assets/images/auth/signup/unlocked.png',
//                                   height: 35,
//                                   width: 35),
//                               const SpacerWidget(
//                                 width: 18,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     "Enable GST API Access",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                       fontSize: AppFontSizes.h2,
//                                       fontWeight: AppFontWeights.bold,
//                                       letterSpacing: 0.14,
//                                     ),
//                                   ),
//                                   const SpacerWidget(),
//                                   RichText(
//                                     text: TextSpan(
//                                         text: "Visit",
//                                         style: TextStyle(
//                                           fontFamily: fontFamily,
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .scrim,
//                                           fontSize: AppFontSizes.body2,
//                                           fontWeight: AppFontWeights.medium,
//                                           letterSpacing: 0.14,
//                                         ),
//                                         children: [
//                                           TextSpan(
//                                             text: " GST-Settings ",
//                                             style: TextStyle(
//                                               fontFamily: fontFamily,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .primary,
//                                               fontSize: AppFontSizes.body2,
//                                               fontWeight: AppFontWeights.medium,
//                                               letterSpacing: 0.14,
//                                             ),
//                                           ),
//                                           TextSpan(
//                                             text: "to enable GST API access",
//                                             style: TextStyle(
//                                               fontFamily: fontFamily,
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .scrim,
//                                               fontSize: AppFontSizes.body2,
//                                               fontWeight: AppFontWeights.medium,
//                                               letterSpacing: 0.14,
//                                             ),
//                                           ),
//                                         ]),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SpacerWidget(
//                             height: 35,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Image.asset(
//                                   'assets/images/auth/signup/mobile.png',
//                                   height: 35,
//                                   width: 35),
//                               const SpacerWidget(
//                                 width: 18,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     "Enter Mobile and Email",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                       fontSize: AppFontSizes.h2,
//                                       fontWeight: AppFontWeights.bold,
//                                       letterSpacing: 0.14,
//                                     ),
//                                   ),
//                                   const SpacerWidget(),
//                                   Text(
//                                     "Mobile number linked to your GSTN account",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       color:
//                                           Theme.of(context).colorScheme.scrim,
//                                       fontSize: AppFontSizes.body2,
//                                       fontWeight: AppFontWeights.medium,
//                                       letterSpacing: 0.14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SpacerWidget(
//                             height: 35,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Image.asset('assets/images/auth/signup/gst.png',
//                                   height: 35, width: 35),
//                               const SpacerWidget(
//                                 width: 18,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     "Enter GST Username & GSTIN",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                       fontSize: AppFontSizes.h2,
//                                       fontWeight: AppFontWeights.bold,
//                                       letterSpacing: 0.14,
//                                     ),
//                                   ),
//                                   const SpacerWidget(),
//                                   Text(
//                                     "The GSTIN info will be verified via OTP",
//                                     style: TextStyle(
//                                       fontFamily: fontFamily,
//                                       color:
//                                           Theme.of(context).colorScheme.scrim,
//                                       fontSize: AppFontSizes.body2,
//                                       fontWeight: AppFontWeights.medium,
//                                       letterSpacing: 0.14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SpacerWidget(
//                       height: RelativeSize.height(40, height),
//                     ),
//                     Container(
//                       height: RelativeSize.height(70, height),
//                       width: RelativeSize.height(70, height),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Theme.of(context).colorScheme.primary,
//                           width: 1,
//                         ),
//                       ),
//                       child: Center(
//                         child: GestureDetector(
//                           onTap: () {
//                             HapticFeedback.mediumImpact();
//                             context.go(AppRoutes.signup_request_permissions);
//                           },
//                           child: Container(
//                             height: RelativeSize.height(60, height),
//                             width: RelativeSize.height(60, height),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                             child: Center(
//                               child: Icon(
//                                 Icons.arrow_forward,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                                 size: 30,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
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
