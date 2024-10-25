import 'dart:async';

import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/support_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/inward_curve_painter.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/support/support.dart';
import 'package:blocsol_loan_application/utils/functions.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalLoanAllSupportTickets extends ConsumerStatefulWidget {
  const PersonalLoanAllSupportTickets({super.key});

  @override
  ConsumerState<PersonalLoanAllSupportTickets> createState() =>
      _PersonalLoanAllSupportTicketsState();
}

class _PersonalLoanAllSupportTicketsState
    extends ConsumerState<PersonalLoanAllSupportTickets> {
  final _cancelToken = CancelToken();
  final _interval = 15;

  Timer? _supportTicktesPollTimer;
  bool _fetchingSupportTickets = false;

  Future<void> pollForSupportTicketsBackground() async {
     if (!mounted || _supportTicktesPollTimer == null) return;
    if (ref.read(personalLoanSupportStateProvider).fetchingAllSupportTickets) {
      return;
    }

    var response = await ref
        .read(personalLoanSupportStateProvider.notifier)
        .fetchAllSupportTickets(_cancelToken);

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }
  }

  void startPollingForSupportTickets() {
    _supportTicktesPollTimer =
        Timer.periodic(Duration(seconds: _interval), (timer) async {
      await pollForSupportTicketsBackground();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _fetchingSupportTickets = true;
      });

      await ref
          .read(personalLoanSupportStateProvider.notifier)
          .fetchAllSupportTickets(_cancelToken);

      setState(() {
        _fetchingSupportTickets = false;
      });

      Future.delayed(const Duration(seconds: 10), () {
        startPollingForSupportTickets();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _supportTicktesPollTimer?.cancel();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final supportRef = ref.watch(personalLoanSupportStateProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              vertical: RelativeSize.height(25, height),
              horizontal: RelativeSize.width(25, width)),
          child: Column(
            children: [
              const PlProfileTopNav(),
              const SpacerWidget(
                height: 45,
              ),
              Text(
                'Get Help',
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(
                height: 5,
              ),
              Text(
                'At your service 24*7',
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.medium,
                  color: const Color.fromRGBO(80, 80, 80, 1),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CustomPaint(
                    painter: PlInwardCurvePainter(
                        color: Theme.of(context).colorScheme.surface),
                    child: Container(
                      height: RelativeSize.height(600, height),
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
                      child: ListView(
                        shrinkWrap: true,

                        children: [
                          const SpacerWidget(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize.width(15, width),
                                vertical: RelativeSize.height(25, height)),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(235, 243, 246, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: RelativeSize.width(200, width),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Have a query?',
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.h3,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      const SpacerWidget(
                                        height: 5,
                                      ),
                                      Text(
                                        'Lets connect quick to fix your problems',
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b1,
                                          fontWeight: AppFontWeights.medium,
                                          color: const Color.fromRGBO(
                                              80, 80, 80, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                GestureDetector(
                                  onTap: () async {
                                    HapticFeedback.mediumImpact();
                                    const whatsappUrl =
                                        "https://wa.me/918360458365";

                                    await launchUrl(Uri.parse(whatsappUrl));
                                  },
                                  child: Container(
                                    height: RelativeSize.height(30, height),
                                    width: RelativeSize.width(90, width),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Chat Now',
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b1,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SpacerWidget(
                            height: 50,
                          ),
                          Text(
                            'Complaints',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.medium,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SpacerWidget(
                            height: 10,
                          ),
                          supportRef.supportTickets.isEmpty &&
                                  _fetchingSupportTickets
                              ? SizedBox(
                                  width: width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                          "assets/animations/loading_spinner.json",
                                          height: 150,
                                          width: 150),
                                      Text(
                                        "Loading...",
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.h3,
                                          fontWeight: AppFontWeights.medium,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : supportRef.supportTickets.isEmpty
                                  ? Container(
                                      width: width,
                                      padding: EdgeInsets.only(
                                        top: RelativeSize.height(20, height),
                                        bottom: RelativeSize.height(30, height),
                                        right: RelativeSize.width(25, width),
                                        left: RelativeSize.width(25, width),
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            235, 243, 246, 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.heavyImpact();
                                                  ref.read(routerProvider).push(
                                                      PersonalLoanSupportRouter
                                                          .raise_new_ticket);
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: RelativeSize.width(
                                                      110, width),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        size: 20,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      const SpacerWidget(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        'Create New',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize:
                                                              AppFontSizes.b2,
                                                          fontWeight:
                                                              AppFontWeights
                                                                  .bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SpacerWidget(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: width,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.support_outlined,
                                                  color: Color.fromRGBO(
                                                      144, 141, 244, 1),
                                                  size: 25,
                                                ),
                                                const SpacerWidget(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Your complaint box is empty',
                                                  style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.h3,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    color: const Color.fromRGBO(
                                                        144, 141, 244, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          supportRef.supportTickets.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (ctx, idx) {
                                        final ticket =
                                            supportRef.supportTickets[idx];
                                        return GestureDetector(
                                          onTap: () {
                                            HapticFeedback.mediumImpact();
                                            ref
                                                .read(
                                                    personalLoanSupportStateProvider
                                                        .notifier)
                                                .setSelectSupportTicket(ticket);
                                            ref.read(routerProvider).push(
                                                PersonalLoanSupportRouter
                                                    .support_ticket_details);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 50),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      235, 243, 246, 1),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            width: width,
                                            padding: EdgeInsets.symmetric(
                                                vertical: RelativeSize.height(
                                                    10, height),
                                                horizontal: RelativeSize.width(
                                                    20, width)),
                                            child: (ticket.status == "CLOSED")
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Icon(
                                                        Icons.blinds_sharp,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        size: 40,
                                                      ),
                                                      const SpacerWidget(
                                                        width: 15,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "ID : ${ticket.id.length > 14 ? ticket.id.substring(0, 13) : ticket.id}",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .h3,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                              ),
                                                            ),
                                                            const SpacerWidget(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "${ticket.category} : ${ticket.subCategory}",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    80,
                                                                    80,
                                                                    80,
                                                                    1),
                                                              ),
                                                            ),
                                                            const SpacerWidget(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "Resolved: ${ticket.updatedAt}",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    80,
                                                                    80,
                                                                    80,
                                                                    1),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 50,
                                                        width: 80,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: 20,
                                                              width: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    233,
                                                                    233,
                                                                    250,
                                                                    1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Completed',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        fontFamily,
                                                                    fontSize:
                                                                        AppFontSizes
                                                                            .b2,
                                                                    fontWeight:
                                                                        AppFontWeights
                                                                            .bold,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "ID : ${ticket.id.length > 14 ? ticket.id.substring(0, 13) : ticket.id}",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontSize:
                                                                  AppFontSizes
                                                                      .h3,
                                                              fontWeight:
                                                                  AppFontWeights
                                                                      .medium,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 20,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromRGBO(211,
                                                                  250, 212, 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'In progress',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      fontFamily,
                                                                  fontSize:
                                                                      AppFontSizes
                                                                          .b2,
                                                                  fontWeight:
                                                                      AppFontWeights
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SpacerWidget(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Category",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                          const SpacerWidget(
                                                            width: 40,
                                                          ),
                                                          Text(
                                                            ":",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontSize:
                                                                  AppFontSizes
                                                                      .b1,
                                                              fontWeight:
                                                                  AppFontWeights
                                                                      .medium,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                            ),
                                                          ),
                                                          const SpacerWidget(
                                                            width: 40,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              ticket.category,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SpacerWidget(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Sub-Category",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                          const SpacerWidget(
                                                            width: 40,
                                                          ),
                                                          Text(
                                                            ":",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontSize:
                                                                  AppFontSizes
                                                                      .b1,
                                                              fontWeight:
                                                                  AppFontWeights
                                                                      .medium,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                            ),
                                                          ),
                                                          const SpacerWidget(
                                                            width: 40,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              ticket
                                                                  .subCategory,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SpacerWidget(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Raised At",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                          const SpacerWidget(
                                                            width: 40,
                                                          ),
                                                          Text(
                                                            ":",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontSize:
                                                                  AppFontSizes
                                                                      .b1,
                                                              fontWeight:
                                                                  AppFontWeights
                                                                      .medium,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                            ),
                                                          ),
                                                          const SpacerWidget(
                                                            width: 40,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              getFormattedTime(
                                                                  ticket
                                                                      .createdAt),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SpacerWidget(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Updated At",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                          const SpacerWidget(
                                                            width: 40,
                                                          ),
                                                          Text(
                                                            ":",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontSize:
                                                                  AppFontSizes
                                                                      .b1,
                                                              fontWeight:
                                                                  AppFontWeights
                                                                      .medium,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                            ),
                                                          ),
                                                          const SpacerWidget(
                                                            width: 40,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              getFormattedTime(
                                                                  ticket
                                                                      .updatedAt),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize:
                                                                    AppFontSizes
                                                                        .b1,
                                                                fontWeight:
                                                                    AppFontWeights
                                                                        .medium,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                          ),
                                        );
                                      })
                        ],
                      ),
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
