import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class GstDataDownloadScreen extends ConsumerStatefulWidget {
  const GstDataDownloadScreen({super.key});

  @override
  ConsumerState<GstDataDownloadScreen> createState() =>
      _GstDataFetchingScreenState();
}

class _GstDataFetchingScreenState extends ConsumerState<GstDataDownloadScreen> {
  final _cancelToken = CancelToken();

  void downloadGSTData() async {
    if (ref.read(invoiceNewLoanRequestProvider).downloadingGSTData) {
      return;
    }

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .downloadGstData(_cancelToken);

    if (!mounted) return;

    if (response.success) {
      ref
          .read(routerProvider)
          .push(InvoiceNewLoanRequestRouter.fetching_gst_invoices);
    } else {
      context.go(InvoiceNewLoanRequestRouter.loan_service_unavailable,
          extra: "GST Data Download Failed: ${response.message}");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      downloadGSTData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(
                20, RelativeSize.height(30, height), 20, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InvoiceNewLoanRequestTopNav(onBackClick: () {
                  ref.read(routerProvider).pop();
                }),
                const SpacerWidget(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset(
                      'assets/animations/downloading_new_data.json',
                      width: (width - 40),
                    ),
                  ],
                ),
                const SpacerWidget(
                  height: 60,
                ),
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Downloading Your GST Data",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.heading,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.14,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "This might take a while",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: const Color.fromRGBO(130, 130, 130, 1),
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.medium,
                          letterSpacing: 0.14,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
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
