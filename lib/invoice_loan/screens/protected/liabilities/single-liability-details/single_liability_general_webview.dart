// import 'package:blocsol_invoice_based_credit/screens/user/protected/liabilities/utils/top_decoration.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:go_router/go_router.dart';

// class LiabilityGeneralWebview extends StatefulWidget {
//   final String url;
//   const LiabilityGeneralWebview({super.key, required this.url});

//   @override
//   State<LiabilityGeneralWebview> createState() =>
//       _LiabilityGeneralWebviewState();
// }

// class _LiabilityGeneralWebviewState extends State<LiabilityGeneralWebview> {
//   String _currentURL = "";
//   bool _fetchingURL = true;
//   InAppWebViewController? _webViewController;

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _webViewController?.loadUrl(
//           urlRequest: URLRequest(url: WebUri(widget.url)));
//     });

//     setState(() {
//       _currentURL = widget.url;
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: SizedBox(
//             height: height,
//             width: width,
//             child: Stack(
//               children: [
//                 const LiabilityTopDecoration(),
//                 Container(
//                   padding:
//                       EdgeInsets.only(top: RelativeSize.height(40, height)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(30, width)),
//                         child: SizedBox(
//                           width: width,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               GestureDetector(
//                                 onTap: () async {
//                                   HapticFeedback.mediumImpact();
//                                   context.go(AppRoutes.msme_liability_details);
//                                 },
//                                 child: Icon(
//                                   Icons.arrow_back_ios,
//                                   size: 20,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: SizedBox(
//                           width: width,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Document Details",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.h1,
//                                   fontWeight: AppFontWeights.medium,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 softWrap: true,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 30,
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: RelativeSize.width(15, width)),
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             clipBehavior: Clip.antiAlias,
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.surface,
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 topRight: Radius.circular(20),
//                               ),
//                             ),
//                             child: Stack(
//                               children: [
//                                 _fetchingURL
//                                     ? const LinearProgressIndicator()
//                                     : Container(),
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(20),
//                                     topRight: Radius.circular(20),
//                                   ),
//                                   child: InAppWebView(
//                                     gestureRecognizers: const <Factory<
//                                         VerticalDragGestureRecognizer>>{},
//                                     initialSettings: InAppWebViewSettings(
//                                       javaScriptEnabled: true,
//                                       verticalScrollBarEnabled: true,
//                                       disableHorizontalScroll: true,
//                                       disableVerticalScroll: false,
//                                     ),
//                                     onLoadStop: (controller, url) {
//                                       setState(() {
//                                         _fetchingURL = false;
//                                         _currentURL = url.toString();
//                                       });
//                                     },
//                                     initialUrlRequest:
//                                         URLRequest(url: WebUri(_currentURL)),
//                                     onWebViewCreated: (controller) async {
//                                       _webViewController = controller;
//                                       _webViewController!.loadUrl(
//                                           urlRequest: URLRequest(
//                                               url: WebUri(_currentURL)));
//                                       setState(() {
//                                         _fetchingURL = false;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
