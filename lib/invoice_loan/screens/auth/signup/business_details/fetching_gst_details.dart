// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/auth/signup/utils/support_click.dart';
// import 'package:blocsol_invoice_based_credit/state/auth/signup/signup_state.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'dart:math' as math;
// import 'package:go_router/go_router.dart';

// class SignupFetchingGSTDetails extends ConsumerStatefulWidget {
//   const SignupFetchingGSTDetails({super.key});

//   @override
//   ConsumerState<SignupFetchingGSTDetails> createState() =>
//       _SignupFetchingGSTDetailsState();
// }

// class _SignupFetchingGSTDetailsState
//     extends ConsumerState<SignupFetchingGSTDetails> {
//   Future<void> _pollForGstDataDownloadSuccess() async {
//     var response = await ref
//         .read(signupStateProvider.notifier)
//         .pollForGSTVerificationCompletion();

//     if (!mounted) return;

//     if (response.success) {
//       context.go(AppRoutes.signup_confirm_account);
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
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _pollForGstDataDownloadSuccess();
//     });
//     super.initState();
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
//                       color: Theme.of(context).colorScheme.tertiary,
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
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
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
//                     const SpacerWidget(
//                       height: 20,
//                     ),
//                     Lottie.asset(
//                       'assets/animations/downloading_data.json',
//                       height: 350,
//                       width: 350,
//                     ),
//                     const SpacerWidget(height: 50),
//                     Text(
//                       "Fetching your",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h2,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         letterSpacing: 0.4,
//                       ),
//                     ),
//                     Text(
//                       "GST Details...",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h2,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         letterSpacing: 0.4,
//                       ),
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
