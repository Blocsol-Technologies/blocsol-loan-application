import 'dart:async';

import 'package:blocsol_loan_application/personal_loan/contants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:string_similarity/string_similarity.dart';

class PCNewLoanAABankSelect extends ConsumerStatefulWidget {
  const PCNewLoanAABankSelect({super.key});

  @override
  ConsumerState<PCNewLoanAABankSelect> createState() =>
      _PCNewLoanAABankSelectState();
}

class _PCNewLoanAABankSelectState extends ConsumerState<PCNewLoanAABankSelect> {
  List<LenderDetails> filteredBanks = [];
  final textInputController = TextEditingController();
  final Duration debounceDuration = const Duration(milliseconds: 1000);
  Timer? _debounce;

  void _handleNotificationBellPress() {}

  void onBankTextInput(String searchQuery) {
    String normalizedSearchText = searchQuery.toLowerCase();

    var bankDetails = lenderDetailsList;

    if (normalizedSearchText.isEmpty) {
      setState(() {
        filteredBanks = bankDetails;
      });
      return;
    } else {
      setState(() {
        List<LenderDetails> matchingBanks = bankDetails.where((detail) {
          String normalizedName = detail.name.toLowerCase();

          double similarityScore =
              normalizedName.similarityTo(normalizedSearchText);

          return similarityScore > 0.3;
        }).toList();

        matchingBanks.sort((a, b) {
          String normalizedNameA = a.name.toLowerCase();
          String normalizedNameB = b.name.toLowerCase();

          double similarityScoreA =
              normalizedNameA.similarityTo(normalizedSearchText);
          double similarityScoreB =
              normalizedNameB.similarityTo(normalizedSearchText);

          return similarityScoreB.compareTo(similarityScoreA);
        });

        filteredBanks = matchingBanks;
      });
    }
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(debounceDuration, () {
      onBankTextInput(textInputController.text);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filteredBanks = lenderDetailsList;
      });
    });
    textInputController.addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    textInputController.removeListener(_onTextChanged);
    textInputController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final borrowerAccountDetailsRef =
        ref.watch(personalLoanAccountDetailsProvider);
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                width: width,
                height: RelativeSize.height(250, height),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: RelativeSize.height(20, height),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(30, width)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              context.go(PersonalNewLoanRequestRouter
                                  .new_loan_account_aggregator_info);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.network(
                                        borrowerAccountDetailsRef
                                                .imageURL.isEmpty
                                            ? "https://placehold.co/30x30/000000/FFFFFF.png"
                                            : borrowerAccountDetailsRef
                                                .imageURL,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpacerWidget(
                      height: 30,
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
                              "Select your Bank",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                            const SpacerWidget(
                              height: 10,
                            ),
                            Text(
                              "Choose your Active Bank to proceed",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.normal,
                                color: Theme.of(context).colorScheme.onPrimary,
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
                      padding: EdgeInsets.fromLTRB(
                          RelativeSize.width(30, width),
                          0,
                          RelativeSize.width(30, width),
                          RelativeSize.height(20, height)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: width,
                        height: 490,
                        child: Column(
                          children: [
                            BankSearch(
                              textEditingController: textInputController,
                              lenfilteredBanks: filteredBanks.length,
                            ),
                            SizedBox(
                              height: 390,
                              child: CustomScrollView(
                                slivers: <Widget>[
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        if (filteredBanks[index].show ==
                                            false) {
                                          return const SizedBox.shrink();
                                        }

                                        return BankItem(
                                          bankDetails: filteredBanks[index],
                                          onSelect: () {
                                            ref
                                                .read(
                                                    personalNewLoanRequestProvider
                                                        .notifier)
                                                .updateAccountAggregatorInfoList(
                                                    filteredBanks[index]
                                                        .connectedAA);

                                            context.go(
                                              PersonalNewLoanRequestRouter
                                                  .new_loan_account_aggregator_select,
                                            );
                                          },
                                        );
                                      },
                                      childCount: filteredBanks.length,
                                    ),
                                  ),
                                ],
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
    );
  }
}

class BankItem extends StatelessWidget {
  final Function onSelect;
  final LenderDetails bankDetails;

  const BankItem({
    super.key,
    required this.onSelect,
    required this.bankDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.surface,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 35, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                    child: getLenderDetailsAssetURL(bankDetails.name, ""),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      width: 150,
                      child: Text(
                        bankDetails.name,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.16,
                        ),
                        textAlign: TextAlign.right,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SpacerWidget(
              height: 25,
            ),
            Container(
              height: 5,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.scrim.withOpacity(0.2),
            )
          ],
        ),
      ),
    );
  }
}

class BankSearch extends StatefulWidget {
  final TextEditingController textEditingController;
  final int lenfilteredBanks;

  const BankSearch(
      {super.key,
      required this.textEditingController,
      required this.lenfilteredBanks});

  @override
  State<BankSearch> createState() => _BankSearchState();
}

class _BankSearchState extends State<BankSearch> {
  bool refreshingBanks = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      color: Theme.of(context).colorScheme.scrim.withOpacity(0.2),
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
                  size: 18,
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
                      fontSize: AppFontSizes.b1,
                      fontWeight: AppFontWeights.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Search Bank Name',
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      hintStyle: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b1,
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
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Matched Names: (${widget.lenfilteredBanks})",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.13),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
