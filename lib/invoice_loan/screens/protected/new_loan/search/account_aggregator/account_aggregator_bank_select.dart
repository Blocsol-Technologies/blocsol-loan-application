// import 'dart:async';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/utils/lender_utils.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:string_similarity/string_similarity.dart';

// class NewLoanAABankSelectScreen extends ConsumerStatefulWidget {
//   final bool skipFormSubmission;
//   const NewLoanAABankSelectScreen(
//       {super.key, required this.skipFormSubmission});

//   @override
//   ConsumerState<NewLoanAABankSelectScreen> createState() =>
//       _NewLoanAABankSelectScreenState();
// }

// class _NewLoanAABankSelectScreenState
//     extends ConsumerState<NewLoanAABankSelectScreen> {
//   final _textInputController = TextEditingController();
//   final Duration _debounceDuration = const Duration(milliseconds: 1000);

//   List<LenderDetails> _filteredBanks = [];

//   Timer? _debounce;

//   void _onBankTextInput(String searchQuery) {
//     String normalizedSearchText = searchQuery.toLowerCase();

//     var bankDetails = lenderDetailsList;

//     if (normalizedSearchText.isEmpty) {
//       setState(() {
//         _filteredBanks = bankDetails;
//       });
//       return;
//     } else {
//       setState(() {
//         List<LenderDetails> matchingBanks = bankDetails.where((detail) {
//           String normalizedName = detail.name.toLowerCase();

//           double similarityScore =
//               normalizedName.similarityTo(normalizedSearchText);

//           return similarityScore > 0.3;
//         }).toList();

//         matchingBanks.sort((a, b) {
//           String normalizedNameA = a.name.toLowerCase();
//           String normalizedNameB = b.name.toLowerCase();

//           double similarityScoreA =
//               normalizedNameA.similarityTo(normalizedSearchText);
//           double similarityScoreB =
//               normalizedNameB.similarityTo(normalizedSearchText);

//           return similarityScoreB.compareTo(similarityScoreA);
//         });

//         _filteredBanks = matchingBanks;
//       });
//     }
//   }

//   void _onTextChanged() {
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
//     _debounce = Timer(_debounceDuration, () {
//       _onBankTextInput(_textInputController.text);
//     });
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         _filteredBanks = lenderDetailsList;
//       });
//     });
//     _textInputController.addListener(_onTextChanged);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _textInputController.removeListener(_onTextChanged);
//     _textInputController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final _ = ref.watch(serverSentEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             body: SingleChildScrollView(
//               padding: EdgeInsets.fromLTRB(
//                   RelativeSize.width(20, width),
//                   RelativeSize.height(20, height),
//                   RelativeSize.width(20, width),
//                   RelativeSize.height(50, height)),
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () async {
//                           HapticFeedback.mediumImpact();
//                           context.go(AppRoutes.msme_new_loan_process);
//                         },
//                         child: Icon(
//                           Icons.arrow_back_outlined,
//                           size: 25,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(),
//                       ),
//                       const SpacerWidget(
//                         width: 12,
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
//                     height: 35,
//                   ),
//                   Text(
//                     "Select your bank",
//                     style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h1,
//                         fontWeight: AppFontWeights.bold,
//                         color: Theme.of(context).colorScheme.onSurface),
//                   ),
//                   const SpacerWidget(
//                     height: 15,
//                   ),
//                   Text(
//                     "Choose the bank name you have an account with.",
//                     style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h3,
//                         fontWeight: AppFontWeights.normal,
//                         color: Theme.of(context).colorScheme.onSurface),
//                   ),
//                   const SpacerWidget(
//                     height: 15,
//                   ),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2, // Number of items per row
//                       crossAxisSpacing: RelativeSize.width(
//                           12, width), // Horizontal space between items
//                       mainAxisSpacing: RelativeSize.height(
//                           10, height), // Vertical space between items
//                       childAspectRatio:
//                           1.3, // Aspect ratio of each item (width/height)
//                     ),
//                     itemBuilder: (context, index) {
//                       return BankItem(
//                         bankDetails: _filteredBanks[index],
//                         onSelect: () {
//                           context.go(
//                               AppRoutes.msme_new_loan_account_aggregator_select,
//                               extra: AAConsentDetails(
//                                   aaInfo: _filteredBanks[index].connectedAA,
//                                   skipFormSubmission:
//                                       widget.skipFormSubmission));
//                         },
//                       );
//                     },
//                     itemCount:
//                         _filteredBanks.length, // Number of items in the grid
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
// }

// class BankItem extends StatelessWidget {
//   final Function onSelect;
//   final LenderDetails bankDetails;

//   const BankItem({
//     super.key,
//     required this.onSelect,
//     required this.bankDetails,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.mediumImpact();
//         onSelect();
//       },
//       child: Container(
//         height: RelativeSize.height(90, height),
//         color: Theme.of(context).colorScheme.surface,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               height: 16,
//               width: 16,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Theme.of(context).colorScheme.primary,
//                     width: 1,
//                   )),
//             ),
//             const SpacerWidget(
//               width: 10,
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.18,
//                   child: getLenderDetailsAssetURL(bankDetails.name, ""),
//                 ),
//                 const SpacerWidget(
//                   height: 5,
//                 ),
//                 SizedBox(
//                   width: 120,
//                   child: Text(
//                     bankDetails.name,
//                     textAlign: TextAlign.center,
//                     softWrap: true,
//                     style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.body2,
//                         fontWeight: AppFontWeights.bold,
//                         color: Theme.of(context).colorScheme.onSurface),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
