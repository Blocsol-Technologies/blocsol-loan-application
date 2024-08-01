// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:lottie/lottie.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';

// class GstDataFetchingScreen extends ConsumerStatefulWidget {
//   const GstDataFetchingScreen({super.key});

//   @override
//   ConsumerState<GstDataFetchingScreen> createState() =>
//       _GstDataFetchingScreenState();
// }

// class _GstDataFetchingScreenState extends ConsumerState<GstDataFetchingScreen> {
//   final _cancelToken =
//       CancelToken(); // Not used: dont want to cancel data download even if the user navigates away

//   bool _gstDataDownloadError = false;

//   void downloadGSTData() async {
//     await Future.delayed(const Duration(seconds: 10), () {
//       context.go(AppRoutes.msme_new_loan_invoice_select);
//     });
//     // if (ref.read(newLoanStateProvider).downloadingGSTData) {
//     //   return;
//     // }

//     // ref.read(newLoanStateProvider.notifier).setDownloadingGSTData(true);

//     // var response = await ref
//     //     .read(newLoanStateProvider.notifier)
//     //     .downloadGSTData(_cancelToken);

//     // if (mounted) {
//     //   ref.read(newLoanStateProvider.notifier).setDownloadingGSTData(false);

//     //   if (response.success) {
//     //     context.go(AppRoutes.msmeNewLoansInvoiceSelect);
//     //   } else {

//     //     setState(() {
//     //       _gstDataDownloadError = true;
//     //     });

//     //     final snackBar = SnackBar(
//     //       elevation: 0,
//     //       behavior: SnackBarBehavior.floating,
//     //       backgroundColor: Colors.transparent,
//     //       content: AwesomeSnackbarContent(
//     //         title: 'On Snap!',
//     //         message: response.message,
//     //         contentType: ContentType.failure,
//     //       ),
//     //     );

//     //     ScaffoldMessenger.of(context)
//     //       ..hideCurrentSnackBar()
//     //       ..showSnackBar(snackBar);
//     //   }
//     // }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       downloadGSTData();
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _ = ref.watch(serverSentEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           backgroundColor: Theme.of(context).colorScheme.surface,
//           body: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.fromLTRB(
//                 20,
//                 RelativeSize.height(90, MediaQuery.of(context).size.height),
//                 20,
//                 50),
//             child: !_gstDataDownloadError
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Lottie.asset(
//                             'assets/animations/searching_data.json',
//                             // height: 300,
//                             width:
//                                 (MediaQuery.of(context).size.width - 40) * 0.85,
//                           ),
//                         ],
//                       ),
//                       const SpacerWidget(
//                         height: 60,
//                       ),
//                       Text(
//                         "Downloading Invoice Data",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           color: Theme.of(context).colorScheme.primary,
//                           fontSize: AppFontSizes.h2,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.14,
//                         ),
//                         textAlign: TextAlign.center,
//                         softWrap: true,
//                       ),
//                       const SpacerWidget(
//                         height: 10,
//                       ),
//                       Text(
//                         "Do not click back or close the App",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           color: Theme.of(context).colorScheme.primary,
//                           fontSize: AppFontSizes.h2,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.14,
//                         ),
//                         textAlign: TextAlign.center,
//                         softWrap: true,
//                       ),
//                     ],
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Lottie.asset(
//                         "assets/animations/error.json",
//                         height: 250,
//                         width: 250,
//                       ),
//                       const SpacerWidget(height: 20),
//                       Text(
//                         "Unable to Fetch Invoices from GSTIN Portal",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h1,
//                           fontWeight: AppFontWeights.bold,
//                           letterSpacing: 0.4,
//                           color: Theme.of(context).colorScheme.onPrimary,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               HapticFeedback.mediumImpact();
//                               setState(() {
//                                 _gstDataDownloadError = false;
//                               });
//                               downloadGSTData();
//                             },
//                             child: Container(
//                               height: 35,
//                               width: 110,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Retry",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h2,
//                                     fontWeight: AppFontWeights.bold,
//                                     letterSpacing: 0.14,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               HapticFeedback.mediumImpact();
//                               context.go(AppRoutes.msme_new_loan_process);
//                             },
//                             child: Container(
//                               height: 35,
//                               width: 110,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Go Back",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h2,
//                                     fontWeight: AppFontWeights.bold,
//                                     letterSpacing: 0.14,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
