// import 'dart:async';
// import 'dart:math';

// import 'package:blocsol_personal_credit/screens/personal_credit/user_screens/new_loan/select/utils.dart';
// import 'package:blocsol_personal_credit/state/router/router_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/account_details/borrower_account_details_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/new_loan/new_loan_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_personal_credit/state/user/borrower/utils/loan/loan_details.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:blocsol_personal_credit/utils/bank_logo_picker.dart';
// import 'package:dio/dio.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_countdown_timer/index.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:string_similarity/string_similarity.dart';

// class PCNewLoanOfferHome extends ConsumerStatefulWidget {
//   const PCNewLoanOfferHome({super.key});

//   @override
//   ConsumerState<PCNewLoanOfferHome> createState() =>
//       _NewLoanOfferSelectScreenState();
// }

// class _NewLoanOfferSelectScreenState extends ConsumerState<PCNewLoanOfferHome> {
//   List<LoanDetails> _filteredOffers = [];
//   int _endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 900;
//   Timer? _debounce;
//   Timer? _offerPoll;
//   int _interval = 10;
//   String _selectedOfferFilter = "Asc";
//   int _numFeteched = 0;

//   final _maxInterval = 60;
//   final _cancelToken = CancelToken();
//   final _textInputController = TextEditingController();
//   final Duration debounceDuration = const Duration(milliseconds: 1000);

//   void _onOfferSearchTextInput(String searchQuery) {
//     String normalizedSearchText = searchQuery.toLowerCase();

//     var offers = ref.read(newLoanStateProvider).offers;

//     if (normalizedSearchText.isEmpty) {
//       setState(() {
//         _filteredOffers = offers;
//       });
//       return;
//     } else {
//       setState(() {
//         List<LoanDetails> matchingOffers = offers.where((offerDet) {
//           String normalizedName = offerDet.bankName.toLowerCase();

//           double similarityScore =
//               normalizedName.similarityTo(normalizedSearchText);

//           return similarityScore > 0.3;
//         }).toList();

//         matchingOffers.sort((a, b) {
//           String normalizedNameA = a.bankName.toLowerCase();
//           String normalizedNameB = b.bankName.toLowerCase();

//           double similarityScoreA =
//               normalizedNameA.similarityTo(normalizedSearchText);
//           double similarityScoreB =
//               normalizedNameB.similarityTo(normalizedSearchText);

//           return similarityScoreB.compareTo(similarityScoreA);
//         });

//         _filteredOffers = matchingOffers;
//       });
//     }
//   }

//   void _onTextChanged() {
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
//     _debounce = Timer(debounceDuration, () {
//       _onOfferSearchTextInput(_textInputController.text);
//     });
//   }

//   Future<void> _onOfferRefresh() async {
//     if (ref.read(newLoanStateProvider).fetchingOffers) {
//       return;
//     }

//     var _ =
//         await ref.read(newLoanStateProvider.notifier).fetchOffers(_cancelToken);
//   }

//   void startFetching() {
//     _offerPoll = Timer.periodic(Duration(seconds: _interval), (timer) async {
//       if (_numFeteched >= 3) {
//         ref.read(newLoanStateProvider.notifier).setFetchingOffers(false);
//         _offerPoll?.cancel();
//         return;
//       }

//       await ref.read(newLoanStateProvider.notifier).fetchOffers(_cancelToken);
//       _adjustInterval();
//       setState(() {
//         _numFeteched++;
//       });
//     });
//   }

//   void _adjustInterval() {
//     // Increase the interval linearly up to the maximum
//     if (_interval < _maxInterval) {
//       _interval += 10;
//       _offerPoll?.cancel(); // Cancel the current timer
//       _offerPoll = Timer.periodic(Duration(seconds: _interval), (timer) async {
//         await ref.read(newLoanStateProvider.notifier).fetchOffers(_cancelToken);
//         _adjustInterval();
//       });
//     }
//   }

//   void _handleNotificationBellPress() {
//     print("Notification Bell Pressed");
//   }

//   void _handleOfferFilterChange() {
//     List<LoanDetails> newFilteredOffers = List.from(_filteredOffers);

//     if (_selectedOfferFilter == "Asc") {
//       newFilteredOffers
//           .sort((a, b) => a.getInterestRate().compareTo(b.getInterestRate()));
//     } else {
//       newFilteredOffers
//           .sort((a, b) => b.getInterestRate().compareTo(a.getInterestRate()));
//     }

//     setState(() {
//       _filteredOffers = newFilteredOffers;
//     });
//   }

//   @override
//   void initState() {
//     _textInputController.addListener(_onTextChanged);

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await _onOfferRefresh();
//       int properEndTime = max(
//           900 -
//               (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
//                   ref.read(newLoanStateProvider).offersFetchTime),
//           0);

//       setState(() {
//         _endTime =
//             DateTime.now().millisecondsSinceEpoch + (properEndTime) * 1000;
//         _filteredOffers = ref.read(newLoanStateProvider).offers;
//       });

//       startFetching();
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _textInputController.removeListener(_onTextChanged);
//     _textInputController.dispose();
//     _cancelToken.cancel();
//     _offerPoll?.cancel();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final newLoanStateRef = ref.watch(newLoanStateProvider);
//     final borrowerAccountDetailsRef =
//         ref.watch(borrowerAccountDetailsStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);

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
//                   height: RelativeSize.height(235, height),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primary,
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(40),
//                       bottomRight: Radius.circular(40),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: height,
//                   padding: EdgeInsets.symmetric(
//                       vertical: RelativeSize.height(20, height)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(30, width)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             GestureDetector(
//                               onTap: () {
//                                 HapticFeedback.mediumImpact();
//                                 context.go(AppRoutes.pc_new_loan_process);
//                               },
//                               child: Icon(
//                                 Icons.arrow_back_ios,
//                                 size: 20,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                             ),
//                             SizedBox(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   IconButton(
//                                     onPressed: () {
//                                       HapticFeedback.mediumImpact();
//                                       _handleNotificationBellPress();
//                                     },
//                                     icon: Icon(
//                                       Icons.notifications_active,
//                                       size: 25,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onPrimary,
//                                     ),
//                                   ),
//                                   const SpacerWidget(
//                                     width: 15,
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       HapticFeedback.mediumImpact();
//                                     },
//                                     child: Container(
//                                       height: 28,
//                                       width: 28,
//                                       clipBehavior: Clip.antiAlias,
//                                       decoration: BoxDecoration(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onPrimary,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Center(
//                                         child: Image.network(
//                                           borrowerAccountDetailsRef
//                                                   .imageURL.isEmpty
//                                               ? "https://placehold.co/30x30/000000/FFFFFF.png"
//                                               : borrowerAccountDetailsRef
//                                                   .imageURL,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 20,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(50, width)),
//                         child: SizedBox(
//                           width: width,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Loan Offers",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.h1,
//                                   fontWeight: AppFontWeights.medium,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 softWrap: true,
//                               ),
//                               const SpacerWidget(
//                                 height: 10,
//                               ),
//                               Text(
//                                 "Select an offer from list below.",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.normal,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                   letterSpacing: 0.24,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 softWrap: true,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 30,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: RelativeSize.width(30, width)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 150,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(4),
//                                 color: const Color.fromRGBO(233, 248, 238, 1),
//                                 border: Border.all(
//                                   color: Theme.of(context).colorScheme.surface,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: CountdownTimer(
//                                   endTime: _endTime,
//                                   widgetBuilder:
//                                       (_, CurrentRemainingTime? time) {
//                                     String text =
//                                         "${time?.min ?? "00"}m : ${time?.sec ?? "00"}s";

//                                     if (ref
//                                         .read(newLoanStateProvider)
//                                         .fetchingOffers) {
//                                       text = "Fetching...";
//                                     }

//                                     if (time == null) {
//                                       text = "Time's up!";
//                                     }

//                                     return Text(
//                                       "Valid for: $text",
//                                       style: TextStyle(
//                                         fontFamily: fontFamily,
//                                         fontSize: AppFontSizes.body,
//                                         fontWeight: AppFontWeights.medium,
//                                         color: const Color.fromRGBO(
//                                             39, 188, 92, 1),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                             DropdownButton2<String>(
//                               isExpanded: true,
//                               underline: const SizedBox(),
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.bold,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                               iconStyleData: IconStyleData(
//                                 icon: Icon(
//                                   Icons.sort_outlined,
//                                   color: Theme.of(context).colorScheme.primary,
//                                   size: 20,
//                                 ),
//                               ),
//                               items: SelectUtils.offerfilters
//                                   .map((item) => DropdownMenuItem<String>(
//                                         value: item.text,
//                                         child: Text(
//                                           item.text,
//                                           style: TextStyle(
//                                             fontSize: AppFontSizes.body,
//                                             fontWeight: AppFontWeights.bold,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ))
//                                   .toList(),
//                               value: _selectedOfferFilter,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   _selectedOfferFilter = value ?? "Asc";
//                                 });
//                                 _handleOfferFilterChange();
//                               },
//                               buttonStyleData: ButtonStyleData(
//                                 height: 30,
//                                 width: 72,
//                                 padding:
//                                     const EdgeInsets.only(left: 14, right: 14),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(14),
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                 ),
//                               ),
//                               dropdownStyleData: DropdownStyleData(
//                                 maxHeight: 200,
//                                 width: 80,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                 ),
//                                 offset: const Offset(0, 0),
//                                 scrollbarTheme: ScrollbarThemeData(
//                                   radius: const Radius.circular(5),
//                                   thumbVisibility:
//                                       MaterialStateProperty.all<bool>(true),
//                                 ),
//                               ),
//                               menuItemStyleData: const MenuItemStyleData(
//                                 height: 40,
//                                 padding: EdgeInsets.only(left: 10, right: 10),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 5,
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           width: width,
//                           height: height,
//                           child: CustomScrollView(
//                             slivers: <Widget>[
//                               newLoanStateRef.fetchingOffers ||
//                                       _filteredOffers.isEmpty
//                                   ? SliverToBoxAdapter(
//                                       child: Container(
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 20, vertical: 30),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: <Widget>[
//                                               Lottie.asset(
//                                                   "assets/animations/loading_spinner.json",
//                                                   height: 150,
//                                                   width: 150),
//                                               const SpacerWidget(
//                                                 height: 15,
//                                               ),
//                                               Text(
//                                                 "Loading Offers Data ...",
//                                                 style: TextStyle(
//                                                     fontFamily: fontFamily,
//                                                     fontSize: AppFontSizes.h2,
//                                                     fontWeight:
//                                                         AppFontWeights.bold,
//                                                     color: Theme.of(context)
//                                                         .colorScheme
//                                                         .onBackground),
//                                               )
//                                             ],
//                                           )))
//                                   : newLoanStateRef.offers.isEmpty &&
//                                           !newLoanStateRef.fetchingOffers
//                                       ? SliverToBoxAdapter(
//                                           child: Container(
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width,
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 20,
//                                                       vertical: 30),
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: <Widget>[
//                                                   Lottie.asset(
//                                                       "assets/animations/error.json",
//                                                       height: 150,
//                                                       width: 150),
//                                                   const SpacerWidget(
//                                                     height: 15,
//                                                   ),
//                                                   Text(
//                                                     "No offers found ...",
//                                                     style: TextStyle(
//                                                         fontFamily: fontFamily,
//                                                         fontSize:
//                                                             AppFontSizes.h2,
//                                                         fontWeight:
//                                                             AppFontWeights.bold,
//                                                         color: Theme.of(context)
//                                                             .colorScheme
//                                                             .onBackground),
//                                                   )
//                                                 ],
//                                               )))
//                                       : SliverList(
//                                           delegate: SliverChildBuilderDelegate(
//                                             (context, index) => _OfferItem(
//                                               offer: _filteredOffers[index],
//                                               viewOfferDetails: () {
//                                                 ref
//                                                     .read(newLoanStateProvider
//                                                         .notifier)
//                                                     .setSelectedOffer(
//                                                         _filteredOffers[index]);

//                                                 context.go(AppRoutes
//                                                     .pc_new_loan_offer_details);
//                                               },
//                                             ),
//                                             childCount: _filteredOffers.length,
//                                           ),
//                                         ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _OfferItem extends StatelessWidget {
//   final LoanDetails offer;
//   final Function viewOfferDetails;
//   const _OfferItem({required this.offer, required this.viewOfferDetails});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.only(
//           bottom: RelativeSize.height(20, MediaQuery.of(context).size.height)),
//       padding: EdgeInsets.symmetric(
//           vertical: 10, horizontal: RelativeSize.width(30, width)),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.background,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: Theme.of(context).colorScheme.primary,
//             width: 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Theme.of(context)
//                   .colorScheme
//                   .onBackground
//                   .withOpacity(0.2), // Shadow color with opacity
//               spreadRadius: 0,
//               blurRadius: 5,
//               offset: const Offset(2, 2), // Shadow position
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(
//                   height: 30,
//                   child: getLenderDetailsAssetURL(
//                       offer.bankName, offer.bankLogoURL),
//                 ),
//                 const SpacerWidget(
//                   width: 5,
//                 ),
//                 SizedBox(
//                   width: 150,
//                   child: Text(
//                     offer.bankName,
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.body,
//                       fontWeight: AppFontWeights.medium,
//                       color: Theme.of(context).colorScheme.onBackground,
//                     ),
//                     softWrap: true,
//                   ),
//                 ),
//                 Expanded(child: Container()),
//                 GestureDetector(
//                   onTap: () async {
//                     HapticFeedback.mediumImpact();
//                     viewOfferDetails();
//                   },
//                   child: Icon(
//                     Icons.arrow_forward_ios_sharp,
//                     size: 18,
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onBackground
//                         .withOpacity(0.5),
//                   ),
//                 )
//               ],
//             ),
//             const SpacerWidget(
//               height: 18,
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Loan",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.medium,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onBackground
//                               .withOpacity(0.5),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 4,
//                       ),
//                       Text(
//                         "₹ ${offer.deposit}",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.onBackground,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerWidget(
//                   width: 8,
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Interest",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.medium,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onBackground
//                               .withOpacity(0.5),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 4,
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           text: "₹ ${offer.interest}",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             color: Theme.of(context).colorScheme.onBackground,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerWidget(
//                   width: 8,
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Interest Rate",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.medium,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onBackground
//                               .withOpacity(0.5),
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 4,
//                       ),
//                       Text(
//                         offer.interestRate,
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           color: Theme.of(context).colorScheme.onBackground,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SpacerWidget(
//               height: 21,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8,
//               ),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: const Color.fromRGBO(248, 248, 248, 1),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Center(
//                 child: RichText(
//                   text: TextSpan(
//                     text: "Repay Loan of ",
//                     style: TextStyle(
//                       fontFamily: fontFamily,
//                       color: Theme.of(context).colorScheme.onBackground,
//                       fontSize: AppFontSizes.body2,
//                       fontWeight: AppFontWeights.normal,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: "₹ ${offer.deposit} ",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onBackground,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           fontFamily: fontFamily,
//                         ),
//                       ),
//                       TextSpan(
//                         text: "in ",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onBackground,
//                           fontSize: AppFontSizes.body2,
//                           fontWeight: AppFontWeights.normal,
//                           fontFamily: fontFamily,
//                         ),
//                       ),
//                       TextSpan(
//                         text: "${offer.tenure} ",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onBackground,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           fontFamily: fontFamily,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
