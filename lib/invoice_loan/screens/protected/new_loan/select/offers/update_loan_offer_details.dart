// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// class UpdateLoanOffer extends ConsumerStatefulWidget {
//   const UpdateLoanOffer({super.key});

//   @override
//   ConsumerState<UpdateLoanOffer> createState() => _UpdateLoanOfferState();
// }

// class _UpdateLoanOfferState extends ConsumerState<UpdateLoanOffer> {
//   final _cancelToken = CancelToken();
//   bool submittingForm = false;
//   num _minPercentage = 0;
//   num _amountPercentage = 0;
//   num _amountSelected = 0;
//   num _maxAmount = 0;

//   void _getAmountSelected() {
//     final selectedOffer = ref.read(newLoanStateProvider).selectedOffer;
//     final maxAmount = num.parse(selectedOffer.deposit);

//     setState(() {
//       _amountSelected = (maxAmount * (_amountPercentage / 100)).round();
//     });
//   }

//   Future<void> _submitLoanUpdateForm() async {
//     if (submittingForm) return;

//     if (_amountSelected < _maxAmount * 0.3) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message:
//               "Update Loan Amount cannot be less than 30% of the loan offer amount",
//           contentType: ContentType.failure,
//         ),
//         duration: const Duration(seconds: 5),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//       return;
//     }

//     setState(() {
//       submittingForm = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .submitLoanUpdateForm('$_amountSelected', _cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       setState(() {
//         submittingForm = false;
//       });
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

//     response = await ref
//         .read(newLoanStateProvider.notifier)
//         .refetchSelectedOfferDetails(_cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       setState(() {
//         submittingForm = false;
//       });
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

//     await Future.delayed(const Duration(seconds: 5));

//     if (!mounted) return;

//     context.go(AppRoutes.msme_new_loan_single_loan_offer_details);

//     return;
//   }

//   @override
//   void initState() {
//     final selectedOffer = ref.read(newLoanStateProvider).selectedOffer;
//     final maxAmount = num.parse(selectedOffer.deposit);
//     final minAmount = num.parse(selectedOffer.deposit) * 0.5;
//     setState(() {
//       _maxAmount = maxAmount;
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
//     final _ = ref.watch(serverSentEventStateProvider);
//     ref.watch(loanEventStateProvider);

//     final newLoanStateRef = ref.watch(newLoanStateProvider);
//     final selectedOldOffer = newLoanStateRef.selectedOffer;
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Stack(
//               children: [
//                 Container(
//                   width: width,
//                   height: 170,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primary,
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(130),
//                       bottomRight: Radius.circular(130),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 50),
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
//                     const SizedBox(
//                       height: 80,
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
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       "Loan Offer",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h3,
//                         fontWeight: AppFontWeights.normal,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                     ),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       "₹ ${selectedOldOffer.deposit}",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h2,
//                         fontWeight: AppFontWeights.medium,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         text: "You want - ",
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
//                               fontSize: AppFontSizes.h3,
//                               fontWeight: AppFontWeights.medium,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         HapticFeedback.heavyImpact();
//                         _submitLoanUpdateForm();
//                       },
//                       child: Container(
//                         height: 50,
//                         width: 220,
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.onPrimary,
//                           border: Border.all(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Center(
//                           child: submittingForm
//                               ? Lottie.asset(
//                                   'assets/animations/loading_spinner.json',
//                                   height: 60,
//                                   width: 60)
//                               : Text(
//                                   "Update Loan Requirement",
//                                   style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h3,
//                                     fontWeight: AppFontWeights.medium,
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
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
//     final info03 = InfoProperties(
//         mainLabelStyle: TextStyle(
//             color: Theme.of(context).colorScheme.primary,
//             fontSize: AppFontSizes.title,
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
