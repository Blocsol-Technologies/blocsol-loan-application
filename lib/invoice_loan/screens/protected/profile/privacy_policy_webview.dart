import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InvoiceLoanPrivacyPolicyWebview extends ConsumerStatefulWidget {
  const InvoiceLoanPrivacyPolicyWebview({super.key});

  @override
  ConsumerState<InvoiceLoanPrivacyPolicyWebview> createState() =>
      _InvoiceLoanPrivacyPolicyWebviewState();
}

class _InvoiceLoanPrivacyPolicyWebviewState
    extends ConsumerState<InvoiceLoanPrivacyPolicyWebview> {
  final GlobalKey _webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  // ignore: unused_field
  final String _url = 'https://ondc.invoicepe.in/privacy-policy';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: height,
            width: width,
            padding: EdgeInsets.only(
              top: RelativeSize.height(30, height),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: const InvoiceLoanProfileTopNav()),
                const SpacerWidget(height: 12),
                Container(
                  height: 5,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(248, 248, 248, 1),
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Color.fromRGBO(230, 230, 230, 1),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: RelativeSize.height(530, height),
                    width: width,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: width,
                          height: 900,
                          child: InAppWebView(
                            key: _webViewKey,
                            gestureRecognizers: const <Factory<
                                VerticalDragGestureRecognizer>>{},
                            initialSettings: InAppWebViewSettings(
                              javaScriptEnabled: true,
                              verticalScrollBarEnabled: true,
                              disableHorizontalScroll: true,
                              disableVerticalScroll: false,
                            ),
                            onWebViewCreated: (controller) async {
                              _webViewController = controller;
                              _webViewController!.loadUrl(
                                  urlRequest: URLRequest(url: WebUri(_url)));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
