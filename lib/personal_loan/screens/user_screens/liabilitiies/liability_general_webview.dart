import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/old_loans.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:blocsol_loan_application/utils/ui/webview_top_bar.dart';
import 'package:blocsol_loan_application/utils/ui/window_popup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PCLiabilityGeneralWebview extends ConsumerStatefulWidget {
  final String url;
  const PCLiabilityGeneralWebview({super.key, required this.url});

  @override
  ConsumerState<PCLiabilityGeneralWebview> createState() =>
      _PCLiabilityGeneralWebviewState();
}

class _PCLiabilityGeneralWebviewState
    extends ConsumerState<PCLiabilityGeneralWebview> {
  String _currentURL = "";
  bool _fetchingURL = true;
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(widget.url)));
    });

    setState(() {
      _currentURL = widget.url;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ref.watch(personalLoanLiabilitiesProvider);
    ref.watch(personalLoanEventsProvider);
    ref.watch(personalLoanServerSentEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: RelativeSize.height(235, height),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: RelativeSize.height(20, height)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: SizedBox(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  ref.read(routerProvider).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(50, width)),
                        child: SizedBox(
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Document Details",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h1,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 30,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: RelativeSize.width(15, width)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: InAppWebView(
                                      gestureRecognizers: const <Factory<
                                          VerticalDragGestureRecognizer>>{},
                                      initialSettings: InAppWebViewSettings(
                                        javaScriptEnabled: true,
                                        verticalScrollBarEnabled: true,
                                        disableHorizontalScroll: true,
                                        disableVerticalScroll: false,
                                        javaScriptCanOpenWindowsAutomatically:
                                            true,
                                        supportMultipleWindows: true,
                                      ),
                                      onCreateWindow: (controller,
                                          createWindowAction) async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return WindowPopup(
                                                createWindowAction:
                                                    createWindowAction);
                                          },
                                        );
                                        return true;
                                      },
                                      onLoadStop: (controller, url) {
                                        setState(() {
                                          _fetchingURL = false;
                                          _currentURL = url.toString();
                                        });
                                      },
                                      initialUrlRequest:
                                          URLRequest(url: WebUri(_currentURL)),
                                      onWebViewCreated: (controller) async {
                                        _webViewController = controller;
                                        _webViewController!.loadUrl(
                                            urlRequest: URLRequest(
                                                url: WebUri(_currentURL)));
                                        setState(() {
                                          _fetchingURL = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                WebviewTopBar(controller: _webViewController),
                                _fetchingURL
                                    ? const LinearProgressIndicator()
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
