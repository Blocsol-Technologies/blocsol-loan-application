import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class InvoiceNewLoanUpdateOffer extends ConsumerStatefulWidget {
  const InvoiceNewLoanUpdateOffer({super.key});

  @override
  ConsumerState<InvoiceNewLoanUpdateOffer> createState() =>
      _InvoiceNewLoanUpdateOfferState();
}

class _InvoiceNewLoanUpdateOfferState
    extends ConsumerState<InvoiceNewLoanUpdateOffer> {
  final _cancelToken = CancelToken();
  bool submittingForm = false;
  num _minPercentage = 0;
  num _amountPercentage = 0;
  num _amountSelected = 0;
  num _maxAmount = 0;

  void _getAmountSelected() {
    final selectedOffer = ref.read(invoiceNewLoanRequestProvider).selectedOffer;
    final maxAmount = num.parse(selectedOffer.deposit);

    setState(() {
      _amountSelected = (maxAmount * (_amountPercentage / 100)).round();
    });
  }

  Future<void> _submitLoanUpdateForm() async {
    if (submittingForm) return;

    if (_amountSelected < _maxAmount * 0.3) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message:
                "Update Loan Amount cannot be less than 30% of the loan offer amount",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    setState(() {
      submittingForm = true;
    });

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .submitLoanUpdateForm('$_amountSelected', _cancelToken);

    if (!mounted || !context.mounted) return;

    logFirebaseEvent("invoice_loan_application_process", {
      "step": "submitting_loan_update_offer_form",
      "gst": ref.read(invoiceLoanUserProfileDetailsProvider).gstNumber,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (!response.success) {
      setState(() {
        submittingForm = false;
      });
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

      if (ref.read(routerProvider).canPop()) {
        ref.read(routerProvider).pop();
      }

      return;
    }

    response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .refetchSelectedOfferDetails(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (!response.success) {
      setState(() {
        submittingForm = false;
      });
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

    await Future.delayed(const Duration(seconds: 10));

    if (!mounted || !context.mounted) return;

    ref
        .read(routerProvider)
        .pushReplacement(InvoiceNewLoanRequestRouter.loan_key_fact_sheet);

    return;
  }

  @override
  void initState() {
    final selectedOffer = ref.read(invoiceNewLoanRequestProvider).selectedOffer;
    final maxAmount = num.parse(selectedOffer.deposit);
    final minAmount = num.parse(selectedOffer.deposit) * 0.5;
    setState(() {
      _maxAmount = maxAmount;
      _minPercentage = (minAmount / maxAmount) * 100;
      _amountPercentage = _minPercentage;
      _amountSelected = minAmount;
    });

    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);

    final newLoanStateRef = ref.watch(invoiceNewLoanRequestProvider);
    final selectedOldOffer = newLoanStateRef.selectedOffer;
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
                  height: 170,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(130),
                      bottomRight: Radius.circular(130),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: SizedBox(
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Choose an Amount",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    CircularSlider(
                      minValue: _amountPercentage.toDouble(),
                      onUpdate: (double value) {
                        setState(() {
                          _amountPercentage = value;
                        });
                        _getAmountSelected();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Loan Offer",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.h3,
                        fontWeight: AppFontWeights.normal,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "₹ ${selectedOldOffer.deposit}",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.h2,
                        fontWeight: AppFontWeights.medium,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "You want - ",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: "₹ $_amountSelected",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.medium,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        _submitLoanUpdateForm();
                      },
                      child: Container(
                        height: 50,
                        width: 220,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: submittingForm
                              ? Lottie.asset(
                                  'assets/animations/loading_spinner.json',
                                  height: 60,
                                  width: 60)
                              : Text(
                                  "Update Loan Requirement",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.h3,
                                    fontWeight: AppFontWeights.medium,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircularSlider extends StatefulWidget {
  final double minValue;
  final Function onUpdate;
  const CircularSlider(
      {super.key, required this.minValue, required this.onUpdate});

  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  final customWidth03 =
      CustomSliderWidths(trackWidth: 24, progressBarWidth: 24, shadowWidth: 0);
  final customColors03 = CustomSliderColors(
      trackColors: [HexColor('#EEEDED'), HexColor('#EEEDED')],
      progressBarColors: [HexColor('#9FAFA1'), HexColor('#9FAFA1')],
      dynamicGradient: true,
      shadowMaxOpacity: 0.05);

  @override
  Widget build(BuildContext context) {
    final info03 = InfoProperties(
        mainLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: AppFontSizes.title,
            fontWeight: AppFontWeights.medium,
            fontFamily: fontFamily),
        modifier: (double value) {
          final kcal = value.toInt();
          return '$kcal %';
        });

    final CircularSliderAppearance appearance03 = CircularSliderAppearance(
        customWidths: customWidth03,
        customColors: customColors03,
        infoProperties: info03,
        size: 200.0,
        startAngle: 270,
        angleRange: 340);
    final viewModel03 = ExampleViewModel(
        appearance: appearance03,
        min: 0,
        max: 100,
        value: widget.minValue,
        pageColors: [HexColor('#D9FFF7'), HexColor('#FFFFFF')]);

    return SleekCircularSlider(
      onChangeStart: (double value) {},
      onChangeEnd: (double value) {
        widget.onUpdate(value);
      },
      innerWidget: viewModel03.innerWidget,
      appearance: viewModel03.appearance,
      min: viewModel03.min,
      max: viewModel03.max,
      initialValue: viewModel03.value,
    );
  }
}

class ExampleViewModel {
  final List<Color> pageColors;
  final CircularSliderAppearance appearance;
  final double min;
  final double max;
  final double value;
  final InnerWidget? innerWidget;

  ExampleViewModel(
      {required this.pageColors,
      required this.appearance,
      this.min = 0,
      this.max = 100,
      this.value = 50,
      this.innerWidget});
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
