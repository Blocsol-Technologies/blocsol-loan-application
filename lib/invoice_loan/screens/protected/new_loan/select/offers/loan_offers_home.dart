import 'dart:async';

import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:string_similarity/string_similarity.dart';

class InvoiceNewLoanOffersSelect extends ConsumerStatefulWidget {
  const InvoiceNewLoanOffersSelect({super.key});

  @override
  ConsumerState<InvoiceNewLoanOffersSelect> createState() =>
      _InvoiceNewLoanOffersSelectState();
}

class _InvoiceNewLoanOffersSelectState
    extends ConsumerState<InvoiceNewLoanOffersSelect> {
  final _textInputController = TextEditingController();
  final Duration _debounceDuration = const Duration(milliseconds: 1000);

  final _cancelToken = CancelToken();

  int _maxInterval = 12;
  final bool _timerExpired = false;
  Timer? _debounce;
  List<LoanDetails> _filteredOffers = [];

  Timer? _invoicePoll;

  void _onInvoiceTextInput(String searchQuery) {
    String normalizedSearchText = searchQuery.toLowerCase();

    var invoices = ref.read(invoiceNewLoanRequestProvider).invoicesWithOffers;

    if (normalizedSearchText.isEmpty) {
      setState(() {
        _filteredOffers = invoices;
      });
      return;
    } else {
      setState(() {
        List<LoanDetails> matchingInvoices = invoices.where((invoice) {
          String normalizedName = invoice.companyName.toLowerCase();

          double similarityScore =
              normalizedName.similarityTo(normalizedSearchText);

          return similarityScore > 0.3;
        }).toList();

        matchingInvoices.sort((a, b) {
          String normalizedNameA = a.companyName.toLowerCase();
          String normalizedNameB = b.companyName.toLowerCase();

          double similarityScoreA =
              normalizedNameA.similarityTo(normalizedSearchText);
          double similarityScoreB =
              normalizedNameB.similarityTo(normalizedSearchText);

          return similarityScoreB.compareTo(similarityScoreA);
        });

        _filteredOffers = matchingInvoices;
      });
    }
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      _onInvoiceTextInput(_textInputController.text);
    });
  }

  Future<void> onInvoiceOffersRefresh() async {
    if (ref.read(invoiceNewLoanRequestProvider).fetchingInvoiceWithOffers) {
      return;
    }

    var _ = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .fetchLoanOffers(_cancelToken);
  }

  void _startFetching() {
    _invoicePoll = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await ref
          .read(invoiceNewLoanRequestProvider.notifier)
          .fetchLoanOffers(_cancelToken);
      _adjustInterval();
    });
  }

  void _adjustInterval() {
    if (_maxInterval == 0) {
      _invoicePoll?.cancel();
      return;
    }

    setState(() {
      _maxInterval -= 1;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _textInputController.addListener(_onTextChanged);
      await onInvoiceOffersRefresh();

      setState(() {
        _filteredOffers =
            ref.read(invoiceNewLoanRequestProvider).invoicesWithOffers;
      });

      _startFetching();
    });

    super.initState();
  }

  @override
  void dispose() {
    _textInputController.removeListener(_onTextChanged);
    _textInputController.dispose();
    _cancelToken.cancel();
    _invoicePoll?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final newLoanStateRef = ref.read(invoiceNewLoanRequestProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, RelativeSize.height(30, height),
                  0, RelativeSize.height(50, height)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: InvoiceNewLoanRequestTopNav(
                      onBackClick: () {
                        ref.read(routerProvider).pop();
                      },
                    ),
                  ),
                  const SpacerWidget(
                    height: 35,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Text(
                      "Loan Offers",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.heading,
                        fontWeight: AppFontWeights.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SpacerWidget(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Text(
                      "Select an invoice from the below list to check the loan offers from lenders",
                      softWrap: true,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.h3,
                        fontWeight: AppFontWeights.normal,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SpacerWidget(
                    height: 30,
                  ),
                  OfferSearch(
                    onRefrersh: onInvoiceOffersRefresh,
                    textEditingController: _textInputController,
                    lenFilteredInvoices: _filteredOffers.length,
                  ),
                  const SpacerWidget(
                    height: 12,
                  ),
                  (_maxInterval == 0 &&
                          ref
                              .read(invoiceNewLoanRequestProvider)
                              .invoicesWithOffers
                              .isEmpty)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Lottie.asset("assets/animations/empty.json",
                                  height: 150, width: 150),
                              const SpacerWidget(
                                height: 15,
                              ),
                              Text(
                                "We are in touch with the lender to generate offers for you. We will get back to you shortly ...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.h2,
                                    fontWeight: AppFontWeights.medium,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              )
                            ],
                          ))
                      : newLoanStateRef.invoicesWithOffers.isEmpty &&
                              !_timerExpired
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Lottie.asset(
                                      "assets/animations/loading_spinner.json",
                                      height: 150,
                                      width: 150),
                                  const SpacerWidget(
                                    height: 15,
                                  ),
                                  Text(
                                    "Loading Offers Data ...",
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.h2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  )
                                ],
                              ))
                          : newLoanStateRef.invoicesWithOffers.isEmpty &&
                                  _timerExpired
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Lottie.asset(
                                          "assets/animations/error.json",
                                          height: 150,
                                          width: 150),
                                      const SpacerWidget(
                                        height: 15,
                                      ),
                                      Text(
                                        "No Offers Found ...",
                                        style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h2,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                      )
                                    ],
                                  ))
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (ctx, idx) {
                                    return OfferItems(
                                      index: idx,
                                      offerDetails: _filteredOffers[idx],
                                      offers:
                                          _filteredOffers[idx].offerDetailsList,
                                      onOfferSelect: () {
                                        var offer = _filteredOffers[idx]
                                            .offerDetailsList[0];

                                        ref
                                            .read(invoiceNewLoanRequestProvider
                                                .notifier)
                                            .setTransactionId(
                                                offer.transactionId);
                                        ref
                                            .read(invoiceNewLoanRequestProvider
                                                .notifier)
                                            .setSelectedInvoice(
                                                _filteredOffers[idx]);

                                        ref.read(routerProvider).push(
                                            InvoiceNewLoanRequestRouter
                                                .single_bank_offer_select);
                                      },
                                    );
                                  },
                                  itemCount: _filteredOffers.length,
                                ),
                ],
              ),
            )),
      ),
    );
  }
}

class OfferItems extends StatelessWidget {
  final int index;
  final LoanDetails offerDetails;
  final List<OfferDetails> offers;
  final Function onOfferSelect;

  const OfferItems(
      {super.key,
      required this.index,
      required this.offerDetails,
      required this.onOfferSelect,
      required this.offers});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: index % 2 != 0
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.tertiary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
            offset: const Offset(0, 2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 35, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Text(
                    offerDetails.companyName,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: 0.16,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 35, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        offerDetails.idt,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          letterSpacing: 0.15,
                        ),
                        softWrap: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: 5,
                          width: 5,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(200, 200, 200, 1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Text(
                        offerDetails.inum.length < 15
                            ? offerDetails.inum
                            : offerDetails.inum.substring(0, 15),
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          letterSpacing: 0.15,
                        ),
                        softWrap: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: 5,
                          width: 5,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(200, 200, 200, 1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Text(
                        "\u{20B9}${offerDetails.amount}",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          letterSpacing: 0.15,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpacerWidget(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                onOfferSelect();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: index % 2 != 0
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.surface,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          ...offers.map((item) {
                            return SizedBox(
                              height: 45,
                              width: 70,
                              child: getLenderDetailsAssetURL(
                                  item.bankName, item.bankLogoURL),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SpacerWidget(
                      width: 10,
                    ),
                    Text(
                      "${offers.length} ${offers.length <= 1 ? "Offer" : "Offers"}",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b1,
                        fontWeight: AppFontWeights.extraBold,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SpacerWidget(
            height: 15,
          ),
          const SpacerWidget(
            height: 10,
          )
        ],
      ),
    );
  }
}

class OfferSearch extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function onRefrersh;
  final int lenFilteredInvoices;

  const OfferSearch(
      {super.key,
      required this.textEditingController,
      required this.onRefrersh,
      required this.lenFilteredInvoices});

  @override
  State<OfferSearch> createState() => _OfferSearchState();
}

class _OfferSearchState extends State<OfferSearch> {
  bool refreshingInvoices = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      color: Theme.of(context).colorScheme.tertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.search,
                  size: 20,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SpacerWidget(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    controller: widget.textEditingController,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Search Name',
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      hintStyle: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.h3,
                        fontWeight: AppFontWeights.normal,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                      filled: false,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SpacerWidget(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "OFFERS (${widget.lenFilteredInvoices})",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.13),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (refreshingInvoices) {
                    return;
                  }

                  setState(() {
                    refreshingInvoices = true;
                  });

                  await widget.onRefrersh();

                  setState(() {
                    refreshingInvoices = false;
                  });
                },
                child: Container(
                  height: 25,
                  width: 90,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.75),
                      width: 1,
                    ),
                  ),
                  child: refreshingInvoices
                      ? Lottie.asset(
                          "assets/animations/loading_spinner.json",
                          height: 25,
                          width: 25,
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.refresh,
                              size: 15,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SpacerWidget(
                              width: 3,
                            ),
                            Text(
                              "REFRESH",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.extraBold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
