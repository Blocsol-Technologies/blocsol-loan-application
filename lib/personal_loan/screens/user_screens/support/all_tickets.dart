import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/support_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/support/support.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PCAllSupportTickets extends ConsumerStatefulWidget {
  const PCAllSupportTickets({super.key});

  @override
  ConsumerState<PCAllSupportTickets> createState() => _PCAllSupportTicketsState();
}

class _PCAllSupportTicketsState extends ConsumerState<PCAllSupportTickets> {
  final _cancelToken = CancelToken();

  bool _fetchingSupportTickets = false;
  bool _fetchingError = false;

  Timer? _supportTicktesPollTimer;
  final _interval = 15;

  Future<void> pollForSupportTickets() async {
    if (_fetchingSupportTickets) {
      return;
    }

    setState(() {
      _fetchingSupportTickets = true;
      _fetchingError = false;
    });

    var response = await ref
        .read(personalLoanSupportStateProvider.notifier)
        .fetchAllSupportTickets(_cancelToken);

    if (!response.success) {
      if (mounted) {
        setState(() {
          _fetchingSupportTickets = false;
          _fetchingError = true;
        });

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: response.message,
            contentType: ContentType.failure,
          ),
          duration: const Duration(seconds: 5),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }

    if (mounted) {
      setState(() {
        _fetchingSupportTickets = false;
        _fetchingError = false;
      });
    }
  }

  Future<void> pollForSupportTicketsBackground() async {
    if (ref.read(personalLoanSupportStateProvider).fetchingAllSupportTickets) {
      return;
    }

    var _ = await ref
        .read(personalLoanSupportStateProvider.notifier)
        .fetchAllSupportTickets(_cancelToken);

    if (!mounted) return;
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
      await pollForSupportTickets();
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
    final supportRef = ref.watch(personalLoanSupportStateProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: _fetchingSupportTickets
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Lottie.asset(
                        "assets/animations/loading_spinner.json",
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Fetching Support Tickets...',
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h2,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                )
              : _fetchingError
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Lottie.asset(
                            "assets/animations/error.json",
                            height: 200,
                            width: 200,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Error occured while fetching support tickets. Contact support...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h2,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ],
                      ))
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () async {
                                HapticFeedback.mediumImpact();
                                context.go(PersonalLoanIndexRouter.dashboard);
                              },
                            ),
                            Text(
                              'All Support Tickets',
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h1,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        supportRef.supportTickets.isEmpty
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 100,
                                    ),
                                    Lottie.asset(
                                      "assets/animations/error.json",
                                      height: 250,
                                      width: 250,
                                    ),
                                    Text(
                                      'No support tickets found...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.h2,
                                          fontWeight: AppFontWeights.medium,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                  ],
                                ))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: supportRef.supportTickets.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 200,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 280,
                                              child: Text(
                                                "ID #: ${supportRef.supportTickets[index].id}",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.b1,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 280,
                                              child: Text(
                                                "Category: ${supportRef.supportTickets[index].category}",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.b1,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 280,
                                              child: Text(
                                                "Sub-Category: ${supportRef.supportTickets[index].subCategory}",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.b1,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 280,
                                              child: Text(
                                                "Raised At: ${supportRef.supportTickets[index].getReadableTime(supportRef.supportTickets[index].createdAt)}",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.b1,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 280,
                                              child: Text(
                                                "Updated At: ${supportRef.supportTickets[index].getReadableTime(supportRef.supportTickets[index].updatedAt)}",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.b1,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();

                                                  ref
                                                      .read(
                                                          personalLoanSupportStateProvider
                                                              .notifier)
                                                      .setIssueDetails(
                                                          supportRef
                                                              .supportTickets[
                                                                  index]
                                                              .providerId,
                                                          supportRef
                                                              .supportTickets[
                                                                  index]
                                                              .transactionId,
                                                          supportRef
                                                              .supportTickets[
                                                                  index]
                                                              .id,
                                                          supportRef
                                                              .supportTickets[
                                                                  index]
                                                              .pan);

                                                  ref
                                                      .read(
                                                          personalLoanSupportStateProvider
                                                              .notifier)
                                                      .setSelectSupportTicket(
                                                          supportRef
                                                                  .supportTickets[
                                                              index]);
                                                  ref.read(routerProvider).push(
                                                      PersonalLoanSupportRouter
                                                          .support_ticket_details);
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    color: supportRef
                                                        .supportTickets[index]
                                                        .getStatusColor(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      supportRef
                                                          .supportTickets[index]
                                                          .status,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize:
                                                              AppFontSizes.h3,
                                                          fontWeight:
                                                              AppFontWeights
                                                                  .medium,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
        ),
      ),
    );
  }
}
