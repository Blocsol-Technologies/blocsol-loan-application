import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/continue_button.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class EnableGSTAPI extends ConsumerStatefulWidget {
  const EnableGSTAPI({super.key});

  @override
  ConsumerState<EnableGSTAPI> createState() => _EnableGSTAPIState();
}

class _EnableGSTAPIState extends ConsumerState<EnableGSTAPI> {
  final _cancelToken = CancelToken();

  late VideoPlayerController _controller;

  Future<void> sendGSTOTP() async {
    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .sendGstOtp(_cancelToken);

    if (!mounted || !context.mounted) return;

    logFirebaseEvent("invoice_loan_application_process", {
      "step": "sending_gst_otp",
      "gst": ref.read(invoiceLoanUserProfileDetailsProvider).gstNumber,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (response.success) {
      ref.read(routerProvider).pushReplacement(
          InvoiceNewLoanRequestRouter.downloading_gst_invoices);
      return;
    } else {
      context.go(InvoiceNewLoanRequestRouter.loan_service_unavailable);
    }
  }

  @override
  void initState() {
    _controller =
        VideoPlayerController.asset('assets/videos/enable_gst_api_access.mp4')
          ..initialize().then((_) {
            setState(() {});
          });

    _controller.setVolume(1.0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ref.watch(invoiceNewLoanRequestProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Container(
            height: height,
            width: width,
            padding: EdgeInsets.fromLTRB(
                RelativeSize.width(30, width),
                RelativeSize.height(30, height),
                RelativeSize.width(30, width),
                RelativeSize.height(50, height)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InvoiceNewLoanRequestTopNav(onBackClick: () {
                  ref.read(routerProvider).pop();
                }),
                const SpacerWidget(height: 70),
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "We need the updated data",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.heading,
                          fontWeight: AppFontWeights.medium,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        softWrap: true,
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "Please enable GST API Access.",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: const Color.fromRGBO(130, 130, 130, 1),
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  height: 30,
                ),
                Container(
                  height: 2,
                  width: RelativeSize.width(150, width),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SpacerWidget(
                  height: 40,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: FutureBuilder(
                          future: _controller.initialize(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If the VideoPlayerController has finished initialization, use
                              // the data it provides to limit the aspect ratio of the video.
                              return AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                // Use the VideoPlayer widget to display the video.
                                child: VideoPlayer(_controller),
                              );
                            } else {
                              // If the VideoPlayerController is still initializing, show a
                              // loading spinner.
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _controller.value.isPlaying == false
                            ? Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.9,
                                color: Colors.black26,
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(
                                height: 10,
                                width: 10,
                              ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _controller.pause();
                            });
                          },
                          icon: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: VideoProgressIndicator(_controller,
                            allowScrubbing: true),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ContinueButton(
                        onPressed: () async {
                          await sendGSTOTP();
                        },
                        text: "Access Enabled?",
                      )
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
