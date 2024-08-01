// import 'dart:async';
// import 'dart:math';

// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/utils/loan_details.dart';
// import 'package:blocsol_invoice_based_credit/utils/lender_utils.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:string_similarity/string_similarity.dart';
// import 'package:flutter_countdown_timer/index.dart';

// class LoanOffersSelect extends ConsumerStatefulWidget {
//   const LoanOffersSelect({super.key});

//   @override
//   ConsumerState<LoanOffersSelect> createState() => _LoanOffersSelectState();
// }

// class _LoanOffersSelectState extends ConsumerState<LoanOffersSelect> {
//   final _textInputController = TextEditingController();
//   final Duration _debounceDuration = const Duration(milliseconds: 1000);
//   final _maxInterval = 60;
//   final _cancelToken = CancelToken();

//   final bool _timerExpired = false;
//   Timer? _debounce;
//   List<LoanDetails> _filteredOffers = [];
//   int endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 900;

//   Timer? _invoicePoll;
//   int _interval = 10;

//   void _onInvoiceTextInput(String searchQuery) {
//     String normalizedSearchText = searchQuery.toLowerCase();

//     var invoices = ref.read(newLoanStateProvider).invoicesWithOffers;

//     if (normalizedSearchText.isEmpty) {
//       setState(() {
//         _filteredOffers = invoices;
//       });
//       return;
//     } else {
//       setState(() {
//         List<LoanDetails> matchingInvoices = invoices.where((invoice) {
//           String normalizedName = invoice.companyName.toLowerCase();

//           double similarityScore =
//               normalizedName.similarityTo(normalizedSearchText);

//           return similarityScore > 0.3;
//         }).toList();

//         matchingInvoices.sort((a, b) {
//           String normalizedNameA = a.companyName.toLowerCase();
//           String normalizedNameB = b.companyName.toLowerCase();

//           double similarityScoreA =
//               normalizedNameA.similarityTo(normalizedSearchText);
//           double similarityScoreB =
//               normalizedNameB.similarityTo(normalizedSearchText);

//           return similarityScoreB.compareTo(similarityScoreA);
//         });

//         _filteredOffers = matchingInvoices;
//       });
//     }
//   }

//   void _onTextChanged() {
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
//     _debounce = Timer(_debounceDuration, () {
//       _onInvoiceTextInput(_textInputController.text);
//     });
//   }

//   Future<void> onInvoiceOffersRefresh() async {
//     if (ref.read(newLoanStateProvider).fetchingInvoiceWithOffers) {
//       return;
//     }

//     var _ = await ref
//         .read(newLoanStateProvider.notifier)
//         .fetchLoanOffers(_cancelToken);
//   }

//   void _startFetching() {
//     _invoicePoll = Timer.periodic(Duration(seconds: _interval), (timer) async {
//       await ref
//           .read(newLoanStateProvider.notifier)
//           .fetchLoanOffers(_cancelToken);
//       _adjustInterval();
//     });
//   }

//   void _adjustInterval() {
//     // Increase the interval linearly up to the maximum
//     if (_interval < _maxInterval) {
//       _interval += 10;
//       _invoicePoll?.cancel(); // Cancel the current timer
//       _invoicePoll =
//           Timer.periodic(Duration(seconds: _interval), (timer) async {
//         await ref
//             .read(newLoanStateProvider.notifier)
//             .fetchLoanOffers(_cancelToken);
//         _adjustInterval();
//       });
//     }
//   }

//   @override
//   void initState() {
//     _textInputController.addListener(_onTextChanged);

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await onInvoiceOffersRefresh();
//       int properEndTime = max(
//           900 -
//               (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
//                   ref.read(newLoanStateProvider).invoiceWithOffersFetchTime),
//           0);

//       setState(() {
//         endTime =
//             DateTime.now().millisecondsSinceEpoch + (properEndTime) * 1000;
//         _filteredOffers = ref.read(newLoanStateProvider).invoicesWithOffers;
//       });

//       _startFetching();
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _textInputController.removeListener(_onTextChanged);
//     _textInputController.dispose();
//     _cancelToken.cancel();
//     _invoicePoll?.cancel();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final _ = ref.watch(serverSentEventStateProvider);
//     final newLoanStateRef = ref.read(newLoanStateProvider);
//     ref.watch(loanEventStateProvider);

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             body: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: EdgeInsets.fromLTRB(
//                   RelativeSize.width(20, width),
//                   RelativeSize.height(20, height),
//                   RelativeSize.width(20, width),
//                   RelativeSize.height(50, height)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       GestureDetector(
//                         onTap: () async {
//                           HapticFeedback.mediumImpact();
//                           context.go(AppRoutes.msme_new_loan_process);
//                         },
//                         child: Icon(
//                           Icons.arrow_back_outlined,
//                           size: 25,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.65),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           HapticFeedback.mediumImpact();
//                           context.go(AppRoutes.msme_raise_new_ticket);
//                         },
//                         child: Container(
//                           height: 25,
//                           width: 65,
//                           clipBehavior: Clip.antiAlias,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(18),
//                             border: Border.all(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .primary
//                                   .withOpacity(0.75),
//                               width: 1,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Help?",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.extraBold,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SpacerWidget(
//                     height: 36,
//                   ),
//                   Container(
//                     width: 180,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4),
//                       color: const Color.fromRGBO(233, 248, 238, 1),
//                       border: Border.all(
//                         color: Theme.of(context).colorScheme.surface,
//                         width: 1,
//                       ),
//                     ),
//                     child: Center(
//                       child: CountdownTimer(
//                         endTime: endTime,
//                         widgetBuilder: (_, CurrentRemainingTime? time) {
//                           String text =
//                               "${time?.min ?? "00"}min : ${time?.sec ?? "00"}sec";

//                           if (ref
//                               .read(newLoanStateProvider)
//                               .fetchingInvoiceWithOffers) {
//                             text = "Fetching...";
//                           }

//                           if (time == null) {
//                             text = "Time's up!";
//                           }

//                           return Text(
//                             "Valid for: $text",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.medium,
//                               color: const Color.fromRGBO(39, 188, 92, 1),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SpacerWidget(
//                     height: 16,
//                   ),
//                   Text(
//                     "Loan Offers",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h1,
//                       fontWeight: AppFontWeights.bold,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                   const SpacerWidget(
//                     height: 16,
//                   ),
//                   Text(
//                     "Select an invoice from the below list to check the loan offers from lenders",
//                     softWrap: true,
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h3,
//                       fontWeight: AppFontWeights.normal,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                   const SpacerWidget(
//                     height: 30,
//                   ),
//                   OfferSearch(
//                     onRefrersh: onInvoiceOffersRefresh,
//                     textEditingController: _textInputController,
//                     lenFilteredInvoices: _filteredOffers.length,
//                   ),
//                   const SpacerWidget(
//                     height: 12,
//                   ),
//                   newLoanStateRef.invoicesWithOffers.isEmpty && !_timerExpired
//                       ? Container(
//                           width: MediaQuery.of(context).size.width,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 30),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Lottie.asset(
//                                   "assets/animations/loading_spinner.json",
//                                   height: 150,
//                                   width: 150),
//                               const SpacerWidget(
//                                 height: 15,
//                               ),
//                               Text(
//                                 "Loading Offers Data ...",
//                                 style: TextStyle(
//                                     fontFamily: fontFamily,
//                                     fontSize: AppFontSizes.h2,
//                                     fontWeight: AppFontWeights.bold,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface),
//                               )
//                             ],
//                           ))
//                       : newLoanStateRef.invoicesWithOffers.isEmpty &&
//                               _timerExpired
//                           ? Container(
//                               width: MediaQuery.of(context).size.width,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 30),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Lottie.asset("assets/animations/error.json",
//                                       height: 150, width: 150),
//                                   const SpacerWidget(
//                                     height: 15,
//                                   ),
//                                   Text(
//                                     "No Offers Found ...",
//                                     style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.h2,
//                                         fontWeight: AppFontWeights.bold,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface),
//                                   )
//                                 ],
//                               ))
//                           : ListView.builder(
//                               physics: const NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               itemBuilder: (ctx, idx) {
//                                 return OfferItems(
//                                   offerDetails: _filteredOffers[idx],
//                                   offers: _filteredOffers[idx].offerDetailsList,
//                                   onOfferSelect: () {
//                                     ref
//                                         .read(newLoanStateProvider.notifier)
//                                         .setSelectedInvoice(
//                                             _filteredOffers[idx]);

//                                     context.go(
//                                         AppRoutes.msme_new_loan_offer_details);
//                                   },
//                                 );
//                               },
//                               itemCount: _filteredOffers.length,
//                             ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
// }

// class OfferItems extends StatelessWidget {
//   final LoanDetails offerDetails;
//   final List<OfferDetails> offers;
//   final Function onOfferSelect;

//   const OfferItems(
//       {super.key,
//       required this.offerDetails,
//       required this.onOfferSelect,
//       required this.offers});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         boxShadow: [
//           BoxShadow(
//             color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
//             offset: const Offset(0, 2),
//             blurRadius: 10,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 0, 35, 0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   flex: 5,
//                   child: Text(
//                     offerDetails.companyName,
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h3,
//                       fontWeight: AppFontWeights.bold,
//                       color: Theme.of(context).colorScheme.onSurface,
//                       letterSpacing: 0.16,
//                     ),
//                     softWrap: true,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 0, 35, 0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Expanded(
//                   child: Text(
//                     "${offerDetails.idt} . ${offerDetails.inum} . \u{20B9}${offerDetails.amount}",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.body,
//                       fontWeight: AppFontWeights.normal,
//                       color: Theme.of(context)
//                           .colorScheme
//                           .onSurface
//                           .withOpacity(0.6),
//                       letterSpacing: 0.15,
//                     ),
//                     softWrap: true,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SpacerWidget(
//             height: 12,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: GestureDetector(
//               onTap: () {
//                 onOfferSelect();
//               },
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Theme.of(context).colorScheme.secondary,
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.7,
//                       child: Wrap(
//                         spacing: 10,
//                         runSpacing: 10,
//                         crossAxisAlignment: WrapCrossAlignment.center,
//                         children: <Widget>[
//                           ...offers.map((item) {
//                             return SizedBox(
//                               height: 30,
//                               width: 50,
//                               child: getLenderDetailsAssetURL(
//                                   item.bankName, item.bankLogoURL),
//                             );
//                           }),
//                           Text(
//                             "${offers.length} ${offers.length <= 1 ? "Offer" : "Offers"}",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.extraBold,
//                               color: Theme.of(context).colorScheme.primary,
//                               letterSpacing: 0.15,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SpacerWidget(
//             height: 15,
//           ),
//           const SpacerWidget(
//             height: 10,
//           )
//         ],
//       ),
//     );
//   }
// }

// class OfferSearch extends StatefulWidget {
//   final TextEditingController textEditingController;
//   final Function onRefrersh;
//   final int lenFilteredInvoices;

//   const OfferSearch(
//       {super.key,
//       required this.textEditingController,
//       required this.onRefrersh,
//       required this.lenFilteredInvoices});

//   @override
//   State<OfferSearch> createState() => _OfferSearchState();
// }

// class _OfferSearchState extends State<OfferSearch> {
//   bool refreshingInvoices = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//       color: Theme.of(context).colorScheme.secondary,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           Container(
//             height: 50,
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surface,
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(
//                 color: Theme.of(context)
//                     .colorScheme
//                     .onSurface
//                     .withOpacity(0.35),
//                 width: 1,
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Icon(
//                   Icons.search,
//                   size: 24,
//                   color: Theme.of(context)
//                       .colorScheme
//                       .onSurface
//                       .withOpacity(0.6),
//                 ),
//                 const SpacerWidget(
//                   width: 8,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     keyboardType: TextInputType.text,
//                     textAlign: TextAlign.left,
//                     controller: widget.textEditingController,
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h2,
//                       fontWeight: AppFontWeights.bold,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     decoration: InputDecoration(
//                       counterText: "",
//                       hintText: 'Search Company Name',
//                       contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
//                       hintStyle: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h2,
//                         fontWeight: AppFontWeights.normal,
//                         color: Theme.of(context).colorScheme.scrim,
//                       ),
//                       filled: false,
//                       border: const OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.transparent),
//                       ),
//                       enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.transparent),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.transparent,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SpacerWidget(
//             height: 20,
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "OFFERS (${widget.lenFilteredInvoices})",
//                       style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h2,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           letterSpacing: 0.13),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (refreshingInvoices) {
//                       return;
//                     }

//                     setState(() {
//                       refreshingInvoices = true;
//                     });

//                     await widget.onRefrersh();

//                     setState(() {
//                       refreshingInvoices = false;
//                     });
//                   },
//                   child: Container(
//                     height: 30,
//                     width: 100,
//                     clipBehavior: Clip.antiAlias,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.surface,
//                       borderRadius: BorderRadius.circular(18),
//                       border: Border.all(
//                         color: Theme.of(context)
//                             .colorScheme
//                             .primary
//                             .withOpacity(0.75),
//                         width: 1,
//                       ),
//                     ),
//                     child: refreshingInvoices
//                         ? Lottie.asset(
//                             "assets/animations/loading_spinner.json",
//                             height: 35,
//                             width: 35,
//                           )
//                         : Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Icon(
//                                 Icons.refresh,
//                                 size: 18,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                               const SpacerWidget(
//                                 width: 3,
//                               ),
//                               Text(
//                                 "REFRESH",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.extraBold,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
