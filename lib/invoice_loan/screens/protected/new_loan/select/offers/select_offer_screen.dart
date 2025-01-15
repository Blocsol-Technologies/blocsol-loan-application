import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceNewLoanOfferDetails extends ConsumerStatefulWidget {
  const InvoiceNewLoanOfferDetails({super.key});

  @override
  ConsumerState<InvoiceNewLoanOfferDetails> createState() =>
      _InvoiceNewLoanOfferDetailsState();
}

class _InvoiceNewLoanOfferDetailsState
    extends ConsumerState<InvoiceNewLoanOfferDetails> {
  bool _descindingOrder = false;
  List<OfferDetails> _offerDetailsList = [];

  void _sortOffers() {
    if (_descindingOrder) {
      _offerDetailsList.sort((a, b) => a.deposit.compareTo(b.deposit));
    } else {
      _offerDetailsList.sort((a, b) => b.deposit.compareTo(a.deposit));
    }

    setState(() {
      _descindingOrder = !_descindingOrder;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _offerDetailsList = ref
            .read(invoiceNewLoanRequestProvider)
            .selectedInvoice
            .offerDetailsList;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final selectedInvoiceOffer =
        ref.watch(invoiceNewLoanRequestProvider).selectedInvoice;
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                RelativeSize.width(20, width),
                RelativeSize.height(30, height),
                RelativeSize.width(20, width),
                RelativeSize.height(50, height)),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InvoiceNewLoanRequestTopNav(
                  onBackClick: () {
                    ref.read(routerProvider).pop();
                  },
                ),
                const SpacerWidget(height: 35),
                const InvoiceNewLoanRequestCountdownTimer(),
                const SpacerWidget(
                  height: 16,
                ),
                Text(
                  "Select Offer ",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.heading,
                    fontWeight: AppFontWeights.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  softWrap: true,
                ),
                const SpacerWidget(
                  height: 16,
                ),
                RichText(
                  text: TextSpan(
                    text: "Invoice Number:  ",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.normal,
                      letterSpacing: 0.14,
                    ),
                    children: [
                      TextSpan(
                        text: selectedInvoiceOffer.inum.length < 15
                            ? selectedInvoiceOffer.inum
                            : selectedInvoiceOffer.inum.substring(0, 15),
                        style: TextStyle(
                          color: const Color.fromRGBO(80, 80, 80, 1),
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.14,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "Invoice Amount:  ",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.normal,
                      letterSpacing: 0.14,
                    ),
                    children: [
                      TextSpan(
                        text: "₹ ${selectedInvoiceOffer.amount}",
                        style: TextStyle(
                          color: const Color.fromRGBO(80, 80, 80, 1),
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.14,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  height: 45,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        _sortOffers();
                      },
                      child: Container(
                        height: 35,
                        width: 85,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(76, 76, 76, 0.4),
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedRotation(
                              turns: _descindingOrder ? 1 : 0.5,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.sort_rounded,
                                size: 25,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SpacerWidget(
                              width: 5,
                            ),
                            Text(
                              "Sort",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SpacerWidget(
                  height: 20,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _offerDetailsList.length,
                    itemBuilder: (ctx, idx) {
                      return InvoiceOfferWidget(
                        invoiceNumber: selectedInvoiceOffer.inum,
                        offer: _offerDetailsList[idx],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InvoiceOfferWidget extends ConsumerStatefulWidget {
  final String invoiceNumber;
  final OfferDetails offer;
  const InvoiceOfferWidget(
      {super.key, required this.offer, required this.invoiceNumber});

  @override
  ConsumerState<InvoiceOfferWidget> createState() => _InvoiceOfferWidgetState();
}

class _InvoiceOfferWidgetState extends ConsumerState<InvoiceOfferWidget> {
  final _cancelToken = CancelToken();

  bool _selectingOffer = false;

  Future<void> _selectOffer() async {
    if (_selectingOffer) {
      return;
    }

    setState(() {
      _selectingOffer = true;
    });

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .setOfferSelected(widget.offer);

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .selectOffer(
            widget.offer.transactionId,
            widget.offer.offerProviderId,
            widget.offer.offerId,
            widget.invoiceNumber,
            widget.offer.parentItemId,
            _cancelToken);

    if (!mounted || !context.mounted) return;

    logFirebaseEvent("invoice_loan_application_process", {
      "step": "selecting_search_offer",
      "gst": ref.read(invoiceLoanUserProfileDetailsProvider).gstNumber,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (!response.success) {
      ref
          .read(invoiceNewLoanRequestProvider.notifier)
          .setOfferSelected(OfferDetails.demo());

      setState(() {
        _selectingOffer = false;
      });
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message:
                "Unable to select the offer. Contact support or Please try again later.",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 10),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    await Future.delayed(const Duration(seconds: 30));

    if (!mounted || !context.mounted) return;

    if (ref
            .read(invoiceNewLoanRequestProvider)
            .selectedOffer
            .installmentAmount !=
        "") {
      return;
    }
    
    response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .refetchSelectedOfferDetails(_cancelToken);

    if (!mounted || !context.mounted) return;

    setState(() {
      _selectingOffer = false;
    });

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to select the offer. ${response.message}",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 10),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    ref
        .read(routerProvider)
        .push(InvoiceNewLoanRequestRouter.loan_key_fact_sheet);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        bottom: RelativeSize.height(30, height),
      ),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          _selectOffer();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
                offset: const Offset(0, 2),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                    width: 85,
                    child: getLenderDetailsAssetURL(
                        widget.offer.bankName, widget.offer.bankLogoURL),
                  ),
                  const SpacerWidget(
                    width: 15,
                  ),
                  Expanded(
                      child: Text(
                    widget.offer.bankName,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )),
                  const SpacerWidget(
                    width: 5,
                  ),
                  _selectingOffer
                      ? Lottie.asset("assets/animations/loading_spinner.json",
                          height: 25, width: 25)
                      : Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 15,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        )
                ],
              ),
              const SpacerWidget(
                height: 23,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                        color: Color.fromRGBO(200, 200, 200, 1),
                        width: 1.5,
                      ))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Loan",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.medium,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          const SpacerWidget(
                            height: 4,
                          ),
                          Text(
                            "₹ ${widget.offer.deposit}",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                        color: Color.fromRGBO(200, 200, 200, 1),
                        width: 1.5,
                      ))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Interest",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.medium,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          const SpacerWidget(
                            height: 4,
                          ),
                          RichText(
                            text: TextSpan(
                              text: widget.offer.interestRate,
                              style: TextStyle(
                                fontFamily: fontFamily,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Fee",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                        ),
                        const SpacerWidget(
                          height: 4,
                        ),
                        Text(
                          "₹ ${widget.offer.getNumericalValOrDefault(widget.offer.applicationFee)}",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SpacerWidget(
                height: 21,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Repay Loan of ",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.b1,
                        fontWeight: AppFontWeights.normal,
                      ),
                      children: [
                        TextSpan(
                          text: "₹ ${widget.offer.deposit} ",
                          style: TextStyle(
                            color: const Color.fromRGBO(80, 80, 80, 1),
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            fontFamily: fontFamily,
                          ),
                        ),
                        TextSpan(
                          text: "in ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.normal,
                            fontFamily: fontFamily,
                          ),
                        ),
                        TextSpan(
                          text: "${widget.offer.tenure} ",
                          style: TextStyle(
                            color: const Color.fromRGBO(80, 80, 80, 1),
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            fontFamily: fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
