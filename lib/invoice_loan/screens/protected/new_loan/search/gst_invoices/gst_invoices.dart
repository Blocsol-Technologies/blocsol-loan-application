// import 'dart:async';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/new_loan/components/continue_button.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state_data.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/utils/loan_details.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:string_similarity/string_similarity.dart';

// class NewLoanGstInvoices extends ConsumerStatefulWidget {
//   const NewLoanGstInvoices({super.key});

//   @override
//   ConsumerState<NewLoanGstInvoices> createState() => _NewLoanGstInvoicesState();
// }

// class _NewLoanGstInvoicesState extends ConsumerState<NewLoanGstInvoices> {
//   final _cancelToken = CancelToken();
//   final _textInputController = TextEditingController();
//   final Duration _debounceDuration = const Duration(milliseconds: 1000);
//   List<Invoice> _filteredInvoices = [];
//   Invoice? _selectedInvoice;
//   Timer? _debounce;

//   void _onInvoiceTextInput(String searchQuery) {
//     String normalizedSearchText = searchQuery.toLowerCase();

//     var invoices = ref.read(newLoanStateProvider).invoices;

//     if (normalizedSearchText.isEmpty) {
//       setState(() {
//         _filteredInvoices = invoices;
//       });
//       return;
//     } else {
//       setState(() {
//         List<Invoice> matchingInvoices = invoices.where((invoice) {
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

//         _filteredInvoices = matchingInvoices;
//       });
//     }
//   }

//   void _onTextChanged() {
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
//     _debounce = Timer(_debounceDuration, () {
//       _onInvoiceTextInput(_textInputController.text);
//     });
//   }

//   void _onInvoiceRefresh() async {
//     if (ref.read(newLoanStateProvider).loadingInvoices) {
//       return;
//     }

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .fetchGstInvoices(_cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'On Snap!',
//           message: "Unable to fetch invoices. Please try again later.",
//           contentType: ContentType.failure,
//         ),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//     } else {
//       setState(() {
//         _filteredInvoices = response.data;
//       });
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _onInvoiceRefresh();
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
//     final newLoanStateRef = ref.watch(newLoanStateProvider);
//     final _ = ref.watch(serverSentEventStateProvider);

//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: Container(
//             padding: EdgeInsets.symmetric(
//                 horizontal: RelativeSize.width(30, width),
//                 vertical: RelativeSize.height(30, height)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Top Nav
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     GestureDetector(
//                       onTap: () async {
//                         HapticFeedback.mediumImpact();
//                         context.go(AppRoutes.msme_new_loan_process);
//                       },
//                       child: Icon(
//                         Icons.arrow_back_outlined,
//                         size: 25,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(),
//                     ),
//                     Container(
//                       height: 25,
//                       width: 90,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         border: Border.all(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .primary
//                               .withOpacity(0.75),
//                           width: 1,
//                         ),
//                       ),
//                       child: Stack(
//                         children: <Widget>[
//                           Center(
//                             child: Text(
//                               "Step 1 of 5",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.extraBold,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 0,
//                             left: 0,
//                             child: Container(
//                               width: 16,
//                               height: 30,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .primary
//                                   .withOpacity(0.15),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SpacerWidget(
//                       width: 12,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         HapticFeedback.mediumImpact();
//                         context.go(AppRoutes.msme_raise_new_ticket);
//                       },
//                       child: Container(
//                         height: 25,
//                         width: 65,
//                         clipBehavior: Clip.antiAlias,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18),
//                           border: Border.all(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .primary
//                                 .withOpacity(0.75),
//                             width: 1,
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Help?",
//                             style: TextStyle(
//                               fontFamily: fontFamily,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.extraBold,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SpacerWidget(
//                   height: 48,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: RelativeSize.width(15, width)),
//                   child: Text(
//                     "GST Invoices for Loan",
//                     style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.h1,
//                         fontWeight: AppFontWeights.bold,
//                         color: Theme.of(context).colorScheme.onSurface),
//                   ),
//                 ),
//                 const SpacerWidget(
//                   height: 15,
//                 ),
//                 Expanded(
//                   child: Container(
//                     width: width,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.secondary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     padding: EdgeInsets.fromLTRB(
//                         5,
//                         RelativeSize.height(5, height),
//                         5,
//                         RelativeSize.height(22, height)),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 10,
//                               width: 10,
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     width: 1,
//                                   ),
//                                   color:
//                                       Theme.of(context).colorScheme.surface),
//                             ),
//                             Container(
//                               height: 10,
//                               width: 10,
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     width: 1,
//                                   ),
//                                   color:
//                                       Theme.of(context).colorScheme.surface),
//                             )
//                           ],
//                         ),
//                         const SpacerWidget(
//                           height: 20,
//                         ),
//                         InvoiceSearch(
//                           onRefrersh: _onInvoiceRefresh,
//                           refreshingInvoices: newLoanStateRef.loadingInvoices,
//                           textEditingController: _textInputController,
//                           lenFilteredInvoices: _filteredInvoices.length,
//                         ),
//                         const SpacerWidget(
//                           height: 15,
//                         ),
//                         Expanded(
//                           child: Stack(
//                             children: [
//                               SizedBox(
//                                 width: width,
//                                 height: RelativeSize.height(250, height),
//                                 child: SingleChildScrollView(
//                                   padding: EdgeInsets.fromLTRB(
//                                       RelativeSize.width(20, width),
//                                       0,
//                                       RelativeSize.width(20, width),
//                                       0),
//                                   physics: const BouncingScrollPhysics(),
//                                   child: newLoanStateRef.loadingInvoices
//                                       ? Container(
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
//                                                 "Loading Invoice Data ...",
//                                                 style: TextStyle(
//                                                     fontFamily: fontFamily,
//                                                     fontSize: AppFontSizes.h2,
//                                                     fontWeight:
//                                                         AppFontWeights.bold,
//                                                     color: Theme.of(context)
//                                                         .colorScheme
//                                                         .onSurface),
//                                               )
//                                             ],
//                                           ))
//                                       : ListView.builder(
//                                           shrinkWrap: true,
//                                           physics:
//                                               const NeverScrollableScrollPhysics(),
//                                           itemCount: _filteredInvoices.length,
//                                           itemBuilder: (ctx, idx) {
//                                             return InvoiceItem(
//                                               invoiceDetails:
//                                                   _filteredInvoices[idx],
//                                               isSelected: _selectedInvoice
//                                                       ?.inum ==
//                                                   _filteredInvoices[idx].inum,
//                                               onSelect: () {
//                                                 setState(() {
//                                                   _selectedInvoice =
//                                                       _filteredInvoices[idx];
//                                                 });
//                                               },
//                                               onNavigateToDetails: () {
//                                                 context.go(
//                                                     AppRoutes
//                                                         .msme_new_loan_single_invoice_details,
//                                                     extra:
//                                                         _filteredInvoices[idx]);
//                                               },
//                                             );
//                                           }),
//                                 ),
//                               ),
//                               Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: SizedBox(
//                                   height: RelativeSize.height(40, height),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       ContinueButton(
//                                         onPressed: () {
//                                           ref
//                                               .read(
//                                                   newLoanStateProvider.notifier)
//                                               .updateState(NewLoanProgress
//                                                   .invoiceSelect);
//                                           context.go(
//                                               AppRoutes.msme_new_loan_process);
//                                         },
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class InvoiceItem extends StatelessWidget {
//   final Function onNavigateToDetails;
//   final Function onSelect;
//   final bool isSelected;
//   final Invoice invoiceDetails;

//   const InvoiceItem(
//       {super.key,
//       required this.onSelect,
//       required this.isSelected,
//       required this.invoiceDetails,
//       required this.onNavigateToDetails});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.mediumImpact();
//         onNavigateToDetails();
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         color: Theme.of(context).colorScheme.surface,
//         padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.fromLTRB(RelativeSize.width(10, width), 0,
//                   RelativeSize.width(10, width), 0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     flex: 5,
//                     child: Text(
//                       invoiceDetails.companyName,
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.body,
//                         fontWeight: AppFontWeights.bold,
//                         color: Theme.of(context).colorScheme.primary,
//                         letterSpacing: 0.16,
//                       ),
//                       softWrap: true,
//                     ),
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: <Widget>[
//                         Text(
//                           "₹ ${invoiceDetails.amount}",
//                           style: TextStyle(
//                             fontFamily: fontFamily,
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.bold,
//                             color: Theme.of(context).colorScheme.primary,
//                             letterSpacing: 0.16,
//                           ),
//                           softWrap: true,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SpacerWidget(
//               height: 8,
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(RelativeSize.width(10, width), 0,
//                   RelativeSize.width(10, width), 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Expanded(
//                     child: Text(
//                       "${invoiceDetails.idt} . ${invoiceDetails.inum}",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.body,
//                         fontWeight: AppFontWeights.normal,
//                         color: isSelected
//                             ? Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.6)
//                             : Theme.of(context)
//                                 .colorScheme
//                                 .onSurface
//                                 .withOpacity(0.6),
//                         letterSpacing: 0.15,
//                       ),
//                       softWrap: true,
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_forward_rounded,
//                     size: 17,
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onSurface
//                         .withOpacity(0.6),
//                   )
//                 ],
//               ),
//             ),
//             const SpacerWidget(
//               height: 15,
//             ),
//             Container(
//               height: 5,
//               width: MediaQuery.of(context).size.width,
//               color: Theme.of(context).colorScheme.secondary,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class InvoiceSearch extends StatefulWidget {
//   final TextEditingController textEditingController;
//   final Function onRefrersh;
//   final bool refreshingInvoices;
//   final int lenFilteredInvoices;

//   const InvoiceSearch(
//       {super.key,
//       required this.textEditingController,
//       required this.onRefrersh,
//       required this.refreshingInvoices,
//       required this.lenFilteredInvoices});

//   @override
//   State<InvoiceSearch> createState() => _InvoiceSearchState();
// }

// class _InvoiceSearchState extends State<InvoiceSearch> {
//   bool refreshingInvoices = false;

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.fromLTRB(
//           RelativeSize.width(20, width),
//           RelativeSize.height(15, height),
//           RelativeSize.width(20, width),
//           RelativeSize.height(25, height)),
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
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "INVOICES (${widget.lenFilteredInvoices})",
//                       style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.medium,
//                           color: Theme.of(context).colorScheme.onSurface,
//                           letterSpacing: 0.13),
//                     ),
//                     Text(
//                       "All these invoices will be shared for requesting loan offers from lenders ",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         fontSize: AppFontSizes.body3,
//                         fontWeight: AppFontWeights.normal,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         letterSpacing: 0.1,
//                       ),
//                       softWrap: true,
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
//                               const Icon(
//                                 Icons.refresh,
//                                 size: 20,
//                                 color: Color.fromRGBO(0, 165, 236, 1),
//                               ),
//                               const SpacerWidget(
//                                 width: 3,
//                               ),
//                               Text(
//                                 widget.refreshingInvoices
//                                     ? "Fetching ..."
//                                     : "REFRESH",
//                                 style: TextStyle(
//                                   fontFamily: fontFamily,
//                                   fontSize: AppFontSizes.h3,
//                                   fontWeight: AppFontWeights.bold,
//                                   color: const Color.fromRGBO(0, 165, 236, 1),
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
