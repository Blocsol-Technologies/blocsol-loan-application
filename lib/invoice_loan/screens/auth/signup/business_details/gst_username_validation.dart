import 'package:blocsol_loan_application/invoice_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/components/section_heading.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/components/section_main.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class SignupGstUsernameValidation extends ConsumerStatefulWidget {
  const SignupGstUsernameValidation({super.key});

  @override
  ConsumerState<SignupGstUsernameValidation> createState() =>
      _SignupGstUsernameValidationState();
}

class _SignupGstUsernameValidationState
    extends ConsumerState<SignupGstUsernameValidation> {
  final _textController = TextEditingController();
  final _cancelToken = CancelToken();

  late VideoPlayerController _controller;

  bool _isError = false;
  bool _showEnableApiAccessVideo = false;
  String _errMessage = "";

  Future<void> _sendGstOtp() async {
    var response = await ref
        .read(invoiceLoanSignupStateProvider.notifier)
        .sendGSTOTP(_textController.text, _cancelToken);

    if (!mounted || !context.mounted) return;

    logFirebaseEvent("invoice_loan_customer_signup", {
      "step": "sending_gst_otp",
      "gst": ref.read(invoiceLoanSignupStateProvider).gstNumber,
      "gstUsername": _textController.text,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (response.success) {
      context.go(InvoiceLoanSignupRouter.gst_otp_verification);
      return;
    }

    setState(() {
      _isError = true;
      _errMessage = response.message;
    });

    return;
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
  void dispose() {
    _textController.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Stack(
          children: [
            Positioned(
              top: RelativeSize.height(90, height),
              right: RelativeSize.width(150, width),
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Positioned(
              top: RelativeSize.height(210, height),
              left: 0,
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Positioned(
              top: RelativeSize.height(335, height),
              right: RelativeSize.width(55, width),
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Container(
              height: height,
              width: width,
              padding: EdgeInsets.only(top: RelativeSize.height(48, height)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Invoice",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: AppFontSizes.h2,
                              fontWeight: AppFontWeights.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Pe",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: AppFontSizes.h2,
                                  fontWeight: AppFontWeights.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpacerWidget(
                    height: 65,
                  ),
                  const SectionHeading(
                    headingWidth: 200,
                    subHeading: "Let's Start",
                    heading: "Enter your GST Username",
                  ),
                  const SpacerWidget(
                    height: 45,
                  ),
                  SectionMain(
                    textController: _textController,
                    textInputChild: Column(
                      children: [
                        _isError
                            ? Text(
                                _errMessage,
                                textAlign: TextAlign.start,
                                softWrap: true,
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.medium,
                                    color: Colors.red),
                              )
                            : Text(
                                "Please enter GST username to link a GSTIN to your Account ",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b2,
                                  fontWeight: AppFontWeights.normal,
                                  color: const Color.fromRGBO(118, 118, 118, 1),
                                ),
                              ),
                        const SpacerWidget(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showEnableApiAccessVideo = true;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 220,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "How to enable API Access?",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    maxInputLength: 50,
                    keyboardType: TextInputType.text,
                    showBackButton: true,
                    hintText: "GST Username",
                    onTextChanged: (val) {
                      setState(() {
                        _isError = false;
                      });
                    },
                    gap: 20,
                    isObscure: false,
                    hasErrored: _isError,
                    performAction: () async {
                      await _sendGstOtp();
                    },
                    inputFormatters: const [],
                  )
                ],
              ),
            ),
            _showEnableApiAccessVideo
                ? Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showEnableApiAccessVideo = false;
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            }
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.7),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: SizedBox(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (_showEnableApiAccessVideo) {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                }
                              },
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: FutureBuilder(
                                      future: _controller.initialize(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          // If the VideoPlayerController has finished initialization, use
                                          // the data it provides to limit the aspect ratio of the video.
                                          return AspectRatio(
                                            aspectRatio:
                                                _controller.value.aspectRatio,
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
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
                                          _showEnableApiAccessVideo = false;
                                          _controller.pause();
                                        });
                                      },
                                      icon: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
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
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
