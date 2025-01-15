import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/inward_curve_painter.dart';
import 'package:blocsol_loan_application/invoice_loan/state/support/state/support_ticket.dart';
import 'package:blocsol_loan_application/invoice_loan/state/support/support.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanSingleTicketDetails extends ConsumerStatefulWidget {
  const InvoiceLoanSingleTicketDetails({super.key});

  @override
  ConsumerState<InvoiceLoanSingleTicketDetails> createState() =>
      _InvoiceLoanSingleTicketDetailsState();
}

class _InvoiceLoanSingleTicketDetailsState
    extends ConsumerState<InvoiceLoanSingleTicketDetails> {
  final CancelToken _cancelToken = CancelToken();
  bool _closingTicket = false;

  Future<void> _handleStatusRequest() async {
    if (ref.read(invoiceLoanSupportProvider).sendingStatusRequest) return;

    var response = await ref
        .read(invoiceLoanSupportProvider.notifier)
        .askForStatusUpdate(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.error),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "update request sent to lender",
            notifType: SnackbarNotificationType.success),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    return;
  }

  Timer? _supportTicktesMessagesPollTimer;
  final _interval = 10;

  Future<void> pollForSupportTicketsBackground() async {
     if (!mounted || _supportTicktesMessagesPollTimer == null) return;

    if (ref.read(invoiceLoanSupportProvider).fetchingSingleSupportTicket) {
      return;
    }

    await ref
        .read(invoiceLoanSupportProvider.notifier)
        .fetchSingleSupportTicket(_cancelToken);
  }

  void startPollingForSupportTickets() {
    _supportTicktesMessagesPollTimer =
        Timer.periodic(Duration(seconds: _interval), (timer) async {
      await pollForSupportTicketsBackground();
    });
  }

  Future<void> _closeTicket() async {
    if (_closingTicket) return;

    setState(() {
      _closingTicket = true;
    });
    List<String> imageBase64 = [];

    DateTime now = DateTime.now();

    // Define the format
    DateFormat formatter = DateFormat('yyyyMMddTHHmmss');

    // Format the date
    String formattedDate = formatter.format(now);

    ref
        .read(invoiceLoanSupportProvider.notifier)
        .addMessageToSelectedSupportTicket(Message(
            message: "Ticket closed by Customer",
            agent: "CONSUMER",
            actionTaken: "CLOSED",
            name: "",
            phone: "",
            email: "",
            updatedAt: formattedDate,
            images: imageBase64));

    var response = await ref
        .read(invoiceLoanSupportProvider.notifier)
        .raiseSupportIssue(
            ref.read(invoiceLoanSupportProvider).selectedSupportTicket.category,
            ref
                .read(invoiceLoanSupportProvider)
                .selectedSupportTicket
                .subCategory,
            "CLOSED",
            "Ticket closed by Customer",
            imageBase64,
            _cancelToken);

    if (!context.mounted || !mounted) return;

    setState(() {
      _closingTicket = false;
    });

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(message: response.message, notifType: SnackbarNotificationType.error),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(seconds: 10), () {
        startPollingForSupportTickets();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _supportTicktesMessagesPollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final supportRef = ref.watch(invoiceLoanSupportProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.fromLTRB(
                RelativeSize.width(35, width),
                RelativeSize.height(20, height),
                RelativeSize.width(35, width),
                0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        ref
                            .read(routerProvider)
                            .push(InvoiceLoanIndexRouter.support);
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 25,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        _closeTicket();
                      },
                      child: Container(
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: _closingTicket
                              ? Lottie.asset(
                                  "assets/animations/loading_spinner.json",
                                  height: 50,
                                  width: 50,
                                )
                              : Text(
                                  'Mark as Solved',
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b2,
                                    fontWeight: AppFontWeights.medium,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        _handleStatusRequest();
                      },
                      child: Container(
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: supportRef.sendingStatusRequest
                              ? Lottie.asset(
                                  "assets/animations/loading_spinner.json",
                                  height: 50,
                                  width: 50,
                                )
                              : Text(
                                  'Request Update',
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b2,
                                    fontWeight: AppFontWeights.medium,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SpacerWidget(
                  height: 45,
                ),
                Text(
                  'Ticket Details',
                  textAlign: TextAlign.center,
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
                  'Ticket ID: ${supportRef.selectedSupportTicket.id}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.medium,
                    color: const Color.fromRGBO(80, 80, 80, 1),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: RelativeSize.height(500, height),
                  width: width,
                  child: CustomPaint(
                    painter: InwardCurvePainter(
                        color: Theme.of(context).colorScheme.surface),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Stack(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            shrinkWrap: true,
                            itemCount: supportRef
                                .selectedSupportTicket.conversations.length,
                            itemBuilder: (context, index) {
                              final conversation = supportRef
                                  .selectedSupportTicket.conversations[index];

                              final bool isCustomerMessage =
                                  conversation.isCustomerMessage();
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: isCustomerMessage
                                              ? Colors.red
                                              : Colors.blue,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: isCustomerMessage
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            isCustomerMessage
                                                ? "You"
                                                : "Support",
                                            style: TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: AppFontSizes.b2,
                                              fontWeight: AppFontWeights.medium,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            conversation.message,
                                            style: TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: AppFontSizes.b1,
                                              fontWeight: AppFontWeights.normal,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Updated At: ${conversation.getReadableTime()}",
                                            style: TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: AppFontSizes.b2,
                                              fontWeight: AppFontWeights.medium,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SpacerWidget(
                                      height: 10,
                                    ),
                                    conversation.images.isEmpty
                                        ? const SizedBox()
                                        : SizedBox(
                                            height: 100,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              key: UniqueKey(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int imageIndex) {
                                                final image = conversation
                                                    .images[imageIndex];
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child:
                                                      Base64ImageWidget(image),
                                                );
                                              },
                                              itemCount:
                                                  conversation.images.length,
                                            ),
                                          )
                                  ],
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            child: NewMessageBar(
                                category:
                                    supportRef.selectedSupportTicket.category,
                                subCategory: supportRef
                                    .selectedSupportTicket.subCategory),
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
      ),
    );
  }
}

class Base64ImageWidget extends StatelessWidget {
  final String base64String;

  const Base64ImageWidget(this.base64String, {super.key});

  @override
  Widget build(BuildContext context) {
    if (isBase64(base64String)) {
      Uint8List bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
      );
    }

    if (isImageUrl(base64String)) {
      return Image.network(
        base64String,
        fit: BoxFit.cover,
      );
    }

    return const SizedBox();
  }
}

class NewMessageBar extends ConsumerStatefulWidget {
  final String category;
  final String subCategory;
  const NewMessageBar(
      {super.key, required this.category, required this.subCategory});

  @override
  ConsumerState<NewMessageBar> createState() => _NewMessageBarState();
}

class _NewMessageBarState extends ConsumerState<NewMessageBar> {
  final ImagePicker _picker = ImagePicker();
  final _messageController = TextEditingController();
  final _cancelToken = CancelToken();
  List<XFile> _mediaFileList = <XFile>[];

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        _mediaFileList.clear();
        final List<XFile> pickedFileList = await _picker.pickMultiImage();
        if (!mounted || !context.mounted) return;
        setState(() {
          _mediaFileList = pickedFileList;
        });
      } catch (e) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: getSnackbarNotificationWidget(message: "unable to select images", notifType: SnackbarNotificationType.error),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      }
    }
  }

  Future<void> _sendMessage() async {
    if (ref.read(invoiceLoanSupportProvider).generatingSupportTicket) return;

    List<String> imageBase64 = [];

    for (int i = 0; i < _mediaFileList.length; i++) {
      final File file = File(_mediaFileList[i].path);
      final List<int> imageBytes = file.readAsBytesSync();
      final String base64Image = base64Encode(imageBytes);
      imageBase64.add(base64Image);
    }

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyyMMddTHHmmss');
    String formattedDate = formatter.format(now);

    ref
        .read(invoiceLoanSupportProvider.notifier)
        .addMessageToSelectedSupportTicket(Message(
            message: _messageController.text,
            agent: "CONSUMER",
            actionTaken: "OPEN",
            name: "",
            phone: "",
            email: "",
            updatedAt: formattedDate,
            images: imageBase64));

    var response = await ref
        .read(invoiceLoanSupportProvider.notifier)
        .raiseSupportIssue(widget.category, widget.subCategory, "OPEN",
            _messageController.text, imageBase64, _cancelToken);

    if (!context.mounted || !mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.error),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      _messageController.clear();
      setState(() {
        _mediaFileList.clear();
      });
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: _mediaFileList.isEmpty ? 90 : 130,
      padding: const EdgeInsets.all(10),
      width: width * 0.85,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _mediaFileList.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          key: UniqueKey(),
                          itemBuilder: (BuildContext context, int index) {
                            return Semantics(
                                label: 'image_picker_example_picked_image',
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Image.file(
                                    File(_mediaFileList[index].path),
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return const Center(
                                          child: Text(
                                              'This image type is not supported'));
                                    },
                                  ),
                                ));
                          },
                          itemCount: _mediaFileList.length,
                        ),
                      ),
                      const SpacerWidget(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _mediaFileList.clear();
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.primary,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            width: width * 0.85,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(237, 237, 237, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b1,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      controller: _messageController,
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    _sendMessage();
                  },
                  child: Center(
                    child: ref
                            .read(invoiceLoanSupportProvider)
                            .generatingSupportTicket
                        ? Lottie.asset(
                            "assets/animations/loading_spinner.json",
                            height: 25,
                            width: 25,
                          )
                        : Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.primary,
                            size: 25,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

bool isBase64(String str) {
  // Regular expression to check if a string is valid Base64
  final base64RegExp = RegExp(
    r'^[A-Za-z0-9+/]*={0,2}$',
    caseSensitive: false,
    multiLine: false,
  );

  // Check if the string matches the Base64 pattern and is valid when decoded
  if (base64RegExp.hasMatch(str)) {
    try {
      base64.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }
  return false;
}

bool isImageUrl(String str) {
  final urlRegExp = RegExp(
    r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
    multiLine: false,
  );

  return urlRegExp.hasMatch(str);
}
