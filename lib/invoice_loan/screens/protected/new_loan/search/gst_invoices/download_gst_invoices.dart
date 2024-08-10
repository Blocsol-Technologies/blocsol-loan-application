import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
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
      // downloadGSTData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                20,
                RelativeSize.height(90, MediaQuery.of(context).size.height),
                20,
                50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset(
                      'assets/animations/searching_data.json',
                      // height: 300,
                      width: (MediaQuery.of(context).size.width - 40) * 0.85,
                    ),
                  ],
                ),
                const SpacerWidget(
                  height: 60,
                ),
                Text(
                  "Downloading Invoice Data",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: AppFontSizes.h2,
                    fontWeight: AppFontWeights.bold,
                    letterSpacing: 0.14,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SpacerWidget(
                  height: 10,
                ),
                Text(
                  "Do not click back or close the App",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: AppFontSizes.h2,
                    fontWeight: AppFontWeights.bold,
                    letterSpacing: 0.14,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
