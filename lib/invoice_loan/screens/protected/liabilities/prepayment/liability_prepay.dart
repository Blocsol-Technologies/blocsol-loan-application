// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/liabilities/utils/top_decoration.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/liabilities/liabilities_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// class LiabilityPrepay extends ConsumerStatefulWidget {
//   const LiabilityPrepay({super.key});

//   @override
//   ConsumerState<LiabilityPrepay> createState() => _LiabilityPrepayState();
// }

// class _LiabilityPrepayState extends ConsumerState<LiabilityPrepay> {
//   final _cancelToken = CancelToken();

//   num _minPercentage = 0;
//   num _amountPercentage = 0;
//   num _amountSelected = 0;

//   void _getAmountSelected() {
//     final selectedLiability =
//         ref.read(liabilitiesStateProvider).selectedLiability;
//     final maxAmount =
//         num.parse(selectedLiability.offerDetails.getBalanceLeft());

//     setState(() {
//       _amountSelected = (maxAmount * (_amountPercentage / 100)).round();
//     });
//   }

//   Future<void> _handlePrepayClick() async {
//     // if (ref.read(oldLoanDetailsStateProvider).initiatingPrepayment) return;

//     var response = await ref
//         .read(liabilitiesStateProvider.notifier)
//         .initiatePartPrepayment('$_amountSelected', _cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: response.message,
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 5),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//       return;
//     }

//     context.go(AppRoutes.msme_liability_part_prepayment_webview,
//         extra: response.data['url']);
//   }

//   @override
//   void initState() {
//     final selectedLiability =
//         ref.read(liabilitiesStateProvider).selectedLiability;
//     final maxAmount =
//         num.parse(selectedLiability.offerDetails.getBalanceLeft());

//     var val = num.parse(selectedLiability.offerDetails.getNextPayment());

//     final minAmount = val;

//     setState(() {
//       _minPercentage = (minAmount / maxAmount) * 100;
//       _amountPercentage = _minPercentage;
//       _amountSelected = minAmount;
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _cancelToken.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final oldLoanStateRef = ref.watch(liabilitiesStateProvider);
//     final selectedLiability = oldLoanStateRef.selectedLiability;

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Stack(
//               children: [
//                 const LiabilityTopDecoration(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                           top: RelativeSize.height(60, height),
//                           left: RelativeSize.width(30, width),
//                           right: RelativeSize.width(30, width)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               HapticFeedback.mediumImpact();
//                               context.go(AppRoutes.msme_liability_details);
//                             },
//                             child: Icon(
//                               Icons.arrow_back_ios,
//                               size: 20,
//                               color: Theme.of(context).colorScheme.onPrimary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 30,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: RelativeSize.width(50, width)),
//                       child: SizedBox(
//                         width: width,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Choose an Amount",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h1,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                               textAlign: TextAlign.center,
//                               softWrap: true,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 100,
//                     ),
//                     CircularSlider(
//                       minValue: _amountPercentage.toDouble(),
//                       onUpdate: (double value) {
//                         setState(() {
//                           _amountPercentage = value;
//                         });
//                         _getAmountSelected();
//                       },
//                     ),
//                     const SpacerWidget(
//                       height: 20,
//                     ),
//                     Text(
//                       "Payment Due",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.body,
//                         fontWeight: AppFontWeights.normal,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                     ),
//                     const SpacerWidget(
//                       height: 4,
//                     ),
//                     Text(
//                       "₹ ${selectedLiability.offerDetails.getBalanceLeft()}",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.body,
//                         fontWeight: AppFontWeights.normal,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                     ),
//                     const SpacerWidget(
//                       height: 40,
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         text: "You are paying ",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.normal,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: "₹ $_amountSelected",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.medium,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 40,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         HapticFeedback.mediumImpact();
//                         context.go(AppRoutes.msme_liability_payment_history);
//                       },
//                       child: Text(
//                         "View Payments History",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.medium,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                     const SpacerWidget(
//                       height: 50,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         HapticFeedback.heavyImpact();
//                         _handlePrepayClick();
//                       },
//                       child: Container(
//                         height: RelativeSize.height(40, height),
//                         width: RelativeSize.width(180, width),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.primary,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Center(
//                           child: oldLoanStateRef.initiatingPrepayment
//                               ? Lottie.asset(
//                                   'assets/animations/loading_spinner.json',
//                                   height: 50,
//                                   width: 50)
//                               : Text(
//                                   "Pay Now",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.body,
//                                     fontWeight: AppFontWeights.medium,
//                                     color:
//                                         Theme.of(context).colorScheme.onPrimary,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CircularSlider extends StatefulWidget {
//   final double minValue;
//   final Function onUpdate;
//   const CircularSlider(
//       {super.key, required this.minValue, required this.onUpdate});

//   @override
//   State<CircularSlider> createState() => _CircularSliderState();
// }

// class _CircularSliderState extends State<CircularSlider> {
//   final customWidth03 =
//       CustomSliderWidths(trackWidth: 24, progressBarWidth: 24, shadowWidth: 0);
//   final customColors03 = CustomSliderColors(
//       trackColors: [HexColor('#EEEDED'), HexColor('#EEEDED')],
//       progressBarColors: [HexColor('#9FAFA1'), HexColor('#9FAFA1')],
//       dynamicGradient: true,
//       shadowMaxOpacity: 0.05);

//   @override
//   Widget build(BuildContext context) {
//     print("minValue: ${widget.minValue}");
//     final info03 = InfoProperties(
//         mainLabelStyle: TextStyle(
//             color: Theme.of(context).colorScheme.primary,
//             fontSize: AppFontSizes.emphasis,
//             fontWeight: AppFontWeights.medium,
//             fontFamily: fontFamily),
//         modifier: (double value) {
//           final kcal = value.toInt();
//           return '$kcal %';
//         });

//     final CircularSliderAppearance appearance03 = CircularSliderAppearance(
//         customWidths: customWidth03,
//         customColors: customColors03,
//         infoProperties: info03,
//         size: 200.0,
//         startAngle: 270,
//         angleRange: 340);
//     final viewModel03 = ExampleViewModel(
//         appearance: appearance03,
//         min: 0,
//         max: 100,
//         value: widget.minValue,
//         pageColors: [HexColor('#D9FFF7'), HexColor('#FFFFFF')]);

//     return SleekCircularSlider(
//       onChangeStart: (double value) {},
//       onChangeEnd: (double value) {
//         widget.onUpdate(value);
//       },
//       innerWidget: viewModel03.innerWidget,
//       appearance: viewModel03.appearance,
//       min: viewModel03.min,
//       max: viewModel03.max,
//       initialValue: viewModel03.value,
//     );
//   }
// }

// class ExampleViewModel {
//   final List<Color> pageColors;
//   final CircularSliderAppearance appearance;
//   final double min;
//   final double max;
//   final double value;
//   final InnerWidget? innerWidget;

//   ExampleViewModel(
//       {required this.pageColors,
//       required this.appearance,
//       this.min = 0,
//       this.max = 100,
//       this.value = 50,
//       this.innerWidget});
// }

// class HexColor extends Color {
//   static int _getColorFromHex(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll('#', '');
//     if (hexColor.length == 6) {
//       hexColor = 'FF$hexColor';
//     }
//     return int.parse(hexColor, radix: 16);
//   }

//   HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
// }
