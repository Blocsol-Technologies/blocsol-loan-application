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

class InvoicesFetchingScreen extends ConsumerStatefulWidget {
  const InvoicesFetchingScreen({super.key});

  @override
  ConsumerState<InvoicesFetchingScreen> createState() =>
      _InvoicesFetchingScreenState();
}

class _InvoicesFetchingScreenState
    extends ConsumerState<InvoicesFetchingScreen> {
  final _cancelToken = CancelToken();

  void _fetchGstInvoices() async {
    if (ref.read(invoiceNewLoanRequestProvider).loadingInvoices) {
      return;
    }

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .fetchGstInvoices(_cancelToken);

    if (!mounted) return;

    if (response.success) {
      if (response.data['refetchData']) {
        response = await ref
            .read(invoiceNewLoanRequestProvider.notifier)
            .sendGstOtp(_cancelToken);

        if (!mounted) return;

        if (!response.success) {
          context.go(InvoiceNewLoanRequestRouter.loan_service_unavailable);
          return;
        }

        context.pushReplacement(InvoiceNewLoanRequestRouter.verify_gst_otp);
        return;
      }

      context
          .pushReplacement(InvoiceNewLoanRequestRouter.gst_invoices_showcase);
    } else {
      context.go(InvoiceNewLoanRequestRouter.loan_service_unavailable);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchGstInvoices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        'assets/animations/fetching_data.json',
                        width: (width - 40),
                      ),
                    ],
                  ),
                  const SpacerWidget(
                    height: 60,
                  ),
                  Text(
                    "Fetching Your GST Data",
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
                    "And we are almost done...",
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
              )),
        ),
      ),
    );
  }
}
