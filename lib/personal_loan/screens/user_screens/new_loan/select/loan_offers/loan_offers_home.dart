import 'dart:async';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/select/utils.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/utils/loan/loan_details.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PCNewLoanOfferHome extends ConsumerStatefulWidget {
  const PCNewLoanOfferHome({super.key});

  @override
  ConsumerState<PCNewLoanOfferHome> createState() =>
      _NewLoanOfferSelectScreenState();
}

class _NewLoanOfferSelectScreenState extends ConsumerState<PCNewLoanOfferHome> {
  List<PersonalLoanDetails> _filteredOffers = [];
  Timer? _debounce;
  Timer? _offerPoll;
  int _interval = 10;
  String _selectedOfferFilter = "Asc";
  int _numFeteched = 0;

  final _maxInterval = 60;
  final _cancelToken = CancelToken();
  final Duration debounceDuration = const Duration(milliseconds: 1000);

  Future<void> _onOfferRefresh() async {
    if (ref.read(personalNewLoanRequestProvider).fetchingOffers) {
      return;
    }

    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .fetchOffers(_cancelToken);

    setState(() {
      _filteredOffers = response.data;
    });
  }

  void startFetching() {
    _offerPoll = Timer.periodic(Duration(seconds: _interval), (timer) async {
      if (_numFeteched >= 3) {
        ref
            .read(personalNewLoanRequestProvider.notifier)
            .setFetchingOffers(false);
        _offerPoll?.cancel();
        return;
      }

      var response = await ref
          .read(personalNewLoanRequestProvider.notifier)
          .fetchOffers(_cancelToken);

      if (!mounted) return;

      if (response.success) {
        setState(() {
          _numFeteched++;
          _filteredOffers = response.data;
        });

        _handleOfferFilterChange();
      } else {
        setState(() {
          _numFeteched++;
        });
      }

      _adjustInterval();
    });
  }

  void _adjustInterval() {
    // Increase the interval linearly up to the maximum
    if (_interval < _maxInterval) {
      _interval += 10;
      _offerPoll?.cancel(); // Cancel the current timer
      _offerPoll = Timer.periodic(Duration(seconds: _interval), (timer) async {
        await ref
            .read(personalNewLoanRequestProvider.notifier)
            .fetchOffers(_cancelToken);
        _adjustInterval();
      });
    }
  }

  void _handleOfferFilterChange() {
    List<PersonalLoanDetails> newFilteredOffers = List.from(_filteredOffers);

    if (_selectedOfferFilter == "Asc") {
      newFilteredOffers
          .sort((a, b) => a.getInterestRate().compareTo(b.getInterestRate()));
    } else {
      newFilteredOffers
          .sort((a, b) => b.getInterestRate().compareTo(a.getInterestRate()));
    }

    setState(() {
      _filteredOffers = newFilteredOffers;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _onOfferRefresh();

      setState(() {
        _filteredOffers = ref.read(personalNewLoanRequestProvider).offers;
      });

      startFetching();
    });

    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _offerPoll?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final newLoanStateRef = ref.watch(personalNewLoanRequestProvider);
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                  height: height,
                  padding: EdgeInsets.symmetric(
                      vertical: RelativeSize.height(20, height)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: PersonalNewLoanRequestTopNav(
                          onBackClick: () async {
                            ref.read(routerProvider).push(
                                PersonalNewLoanRequestRouter.new_loan_process);
                          },
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
                              GestureDetector(
                                onTap: () {
                                  _onOfferRefresh();
                                },
                                child: Text(
                                  "Loan Offers",
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
                              ),
                              const SpacerWidget(
                                height: 10,
                              ),
                              Text(
                                "Select an offer from list below.",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  letterSpacing: 0.24,
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const PersonalNewLoanRequestCountdownTimer(),
                            DropdownButton2<String>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              iconStyleData: IconStyleData(
                                icon: Icon(
                                  Icons.sort_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              items: SelectUtils.offerfilters
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.text,
                                        child: Text(
                                          item.text,
                                          style: TextStyle(
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: _selectedOfferFilter,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedOfferFilter = value ?? "Asc";
                                });
                                _handleOfferFilterChange();
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 30,
                                width: 72,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(5),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 10, right: 10),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: CustomScrollView(
                            slivers: <Widget>[
                              newLoanStateRef.fetchingOffers ||
                                      _filteredOffers.isEmpty
                                  ? SliverToBoxAdapter(
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 30),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                    fontWeight:
                                                        AppFontWeights.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              )
                                            ],
                                          )))
                                  : newLoanStateRef.offers.isEmpty &&
                                          !newLoanStateRef.fetchingOffers
                                      ? SliverToBoxAdapter(
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 30),
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
                                                    "No offers found ...",
                                                    style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        fontSize:
                                                            AppFontSizes.h2,
                                                        fontWeight:
                                                            AppFontWeights.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface),
                                                  )
                                                ],
                                              )))
                                      : SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) => _OfferItem(
                                              offer: _filteredOffers[index],
                                              viewOfferDetails: () {
                                                ref
                                                    .read(
                                                        personalNewLoanRequestProvider
                                                            .notifier)
                                                    .setSelectedOffer(
                                                        _filteredOffers[index]);

                                                context.go(
                                                    PersonalNewLoanRequestRouter
                                                        .new_loan_offer_details);
                                              },
                                            ),
                                            childCount: _filteredOffers.length,
                                          ),
                                        ),
                            ],
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

class _OfferItem extends StatelessWidget {
  final PersonalLoanDetails offer;
  final Function viewOfferDetails;
  const _OfferItem({required this.offer, required this.viewOfferDetails});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
          bottom: RelativeSize.height(20, MediaQuery.of(context).size.height)),
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: RelativeSize.width(30, width)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(2, 2), // Shadow position
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
                  child: getLenderDetailsAssetURL(
                      offer.bankName, offer.bankLogoURL),
                ),
                const SpacerWidget(
                  width: 5,
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    offer.bankName,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.b1,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    softWrap: true,
                  ),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () async {
                    HapticFeedback.mediumImpact();
                    viewOfferDetails();
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                )
              ],
            ),
            const SpacerWidget(
              height: 18,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Loan",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
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
                        "₹ ${offer.deposit}",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Interest",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
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
                          text: "₹ ${offer.interest}",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Interest Rate",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
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
                        offer.interestRate,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
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
                color: const Color.fromRGBO(248, 248, 248, 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: "Repay Loan of ",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFontSizes.b2,
                      fontWeight: AppFontWeights.normal,
                    ),
                    children: [
                      TextSpan(
                        text: "₹ ${offer.deposit} ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
                          fontFamily: fontFamily,
                        ),
                      ),
                      TextSpan(
                        text: "in ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.b2,
                          fontWeight: AppFontWeights.normal,
                          fontFamily: fontFamily,
                        ),
                      ),
                      TextSpan(
                        text: "${offer.tenure} ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
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
    );
  }
}
