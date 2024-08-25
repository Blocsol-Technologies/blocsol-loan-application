import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/shared_components/liability_card.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/all/all_liabilities.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/invoice_loan/state/ui/nav/bottom_nav_bar/bottom_nav_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:string_similarity/string_similarity.dart';

class InvoiceLoanLiabilitiesHome extends ConsumerStatefulWidget {
  const InvoiceLoanLiabilitiesHome({super.key});

  @override
  ConsumerState<InvoiceLoanLiabilitiesHome> createState() =>
      _InvoiceLoanLiabilitiesHomeState();
}

class _InvoiceLoanLiabilitiesHomeState
    extends ConsumerState<InvoiceLoanLiabilitiesHome> {
  final _cancelToken = CancelToken();
  final _textInputController = TextEditingController();
  final Duration _debounceDuration = const Duration(milliseconds: 1000);

  List<LoanDetails> _filteredLoans = [];
  Timer? _debounce;

  void _onLoanTextInput(String searchQuery) {
    String normalizedSearchText = searchQuery.toLowerCase();

    var loans = ref.read(invoiceLoanLiabilitiesProvider).liabilities;

    if (normalizedSearchText.isEmpty) {
      setState(() {
        _filteredLoans = loans;
      });
      return;
    } else {
      List<LoanDetails> matchingLoans = loans.where((invoice) {
        String normalizedName = invoice.offerDetails.bankName.toLowerCase();

        double similarityScore =
            normalizedName.similarityTo(normalizedSearchText);

        return similarityScore > 0.3;
      }).toList();

      matchingLoans.sort((a, b) {
        String normalizedNameA = a.offerDetails.bankName.toLowerCase();
        String normalizedNameB = b.offerDetails.bankName.toLowerCase();

        double similarityScoreA =
            normalizedNameA.similarityTo(normalizedSearchText);
        double similarityScoreB =
            normalizedNameB.similarityTo(normalizedSearchText);

        return similarityScoreB.compareTo(similarityScoreA);
      });

      setState(() {
        _filteredLoans = matchingLoans;
      });
    }
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      _onLoanTextInput(_textInputController.text);
    });
  }

  void _handleNotificationBellPress() {}

  Future<void> _handleRefresh() async {
    if (ref.read(invoiceLoanLiabilitiesProvider).fetchingLiabilitiess) {
      return;
    }

    await ref
        .read(invoiceLoanLiabilitiesProvider.notifier)
        .fetchAllLiabilities(_cancelToken);

    await ref
        .read(invoiceLoanLiabilitiesProvider.notifier)
        .fetchAllClosedLiabilities(_cancelToken);
  }

  void _onInvoiceRefresh() async {
    if (ref.read(invoiceLoanLiabilitiesProvider).fetchingLiabilitiess) {
      return;
    }

    var response = await ref
        .read(invoiceLoanLiabilitiesProvider.notifier)
        .fetchAllLiabilities(_cancelToken);

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'On Snap!',
          message: "Unable to fetch loans. Please try again later.",
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      setState(() {
        _filteredLoans = response.data;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRefresh();
      _textInputController.addListener(_onTextChanged);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final liabiliiesStateRef = ref.watch(invoiceLoanLiabilitiesProvider);
    final companyDetailsRef = ref.watch(invoiceLoanUserProfileDetailsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: RelativeSize.height(30, height),
                      left: RelativeSize.width(25, width),
                      right: RelativeSize.width(25, width)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          ref
                              .read(bottomNavStateProvider.notifier).changeItem(BottomNavItems.home);

                              context.go(InvoiceLoanIndexRouter.dashboard);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              _handleNotificationBellPress();
                            },
                            icon: Icon(
                              Icons.notifications_active,
                              size: 25,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SpacerWidget(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                            },
                            child: Container(
                              height: 28,
                              width: 28,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Text(
                                companyDetailsRef.tradeName[0],
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: AppFontSizes.h3,
                                    fontWeight: AppFontWeights.bold,
                                    letterSpacing: 0.14,
                                    fontFamily: fontFamily),
                              )),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  height: 25,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(25, width)),
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.fromLTRB(
                          0,
                          RelativeSize.height(5, height),
                          0,
                          RelativeSize.height(22, height)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1,
                                    ),
                                    color:
                                        Theme.of(context).colorScheme.surface),
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1,
                                    ),
                                    color:
                                        Theme.of(context).colorScheme.surface),
                              )
                            ],
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          LoanSearch(
                            onRefrersh: () {
                              _onInvoiceRefresh();
                            },
                            refreshingLoans:
                                liabiliiesStateRef.fetchingLiabilitiess,
                            textEditingController: _textInputController,
                            lenFilteredOffers: _filteredLoans.length,
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: width,
                              height: RelativeSize.height(280, height),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: liabiliiesStateRef.fetchingLiabilitiess
                                    ? SizedBox(
                                        width: width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Lottie.asset(
                                              'assets/animations/searching_data.json',
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      40) *
                                                  0.85,
                                            ),
                                            const SpacerWidget(
                                              height: 30,
                                            ),
                                            Text(
                                              "Fetching Loan Data",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontSize: AppFontSizes.h2,
                                                fontWeight: AppFontWeights.bold,
                                                letterSpacing: 0.14,
                                              ),
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      )
                                    : liabiliiesStateRef.liabilities.isEmpty
                                        ? SizedBox(
                                            width: width,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Lottie.asset(
                                                  'assets/animations/invoice_offer_not_found.json',
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          40) *
                                                      0.85,
                                                ),
                                                Text(
                                                  "No Loans Found",
                                                  style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                    fontSize: AppFontSizes.h2,
                                                    fontWeight:
                                                        AppFontWeights.bold,
                                                    letterSpacing: 0.14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                ),
                                                Text(
                                                  "Get a New Loan!",
                                                  style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    color: const Color.fromRGBO(
                                                        151, 151, 151, 1),
                                                    fontSize: AppFontSizes.b1,
                                                    fontWeight:
                                                        AppFontWeights.bold,
                                                    letterSpacing: 0.14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                ),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: liabiliiesStateRef
                                                .liabilities.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return LiabilityCard(
                                                oldLoanDetails:
                                                    liabiliiesStateRef
                                                        .liabilities[index],
                                              );
                                            },
                                          ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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

class LoanSearch extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function onRefrersh;
  final bool refreshingLoans;
  final int lenFilteredOffers;

  const LoanSearch(
      {super.key,
      required this.textEditingController,
      required this.onRefrersh,
      required this.refreshingLoans,
      required this.lenFilteredOffers});

  @override
  State<LoanSearch> createState() => _LoanSearchState();
}

class _LoanSearchState extends State<LoanSearch> {
  bool refreshingLoans = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
          RelativeSize.width(20, width),
          RelativeSize.height(0, height),
          RelativeSize.width(20, width),
          RelativeSize.height(25, height)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  width: 3,
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    controller: widget.textEditingController,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.medium,
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
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Loans (${widget.lenFilteredOffers})",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.medium,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.13),
                    ),
                  ],
                ),
              ),
              const SpacerWidget(
                width: 5,
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () async {
                    if (refreshingLoans) {
                      return;
                    }

                    setState(() {
                      refreshingLoans = true;
                    });

                    await widget.onRefrersh();

                    setState(() {
                      refreshingLoans = false;
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
                    child: Row(
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
                          widget.refreshingLoans ? "FETCHING" : "REFRESH",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
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
