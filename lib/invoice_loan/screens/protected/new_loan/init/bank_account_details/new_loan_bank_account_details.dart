// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/new_loan/components/continue_button.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/server_sent_events/sse_events_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/text_formatters.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class BankAccountDetails extends ConsumerStatefulWidget {
//   const BankAccountDetails({super.key});

//   @override
//   ConsumerState<BankAccountDetails> createState() =>
//       _NewLoanBankAccountDetailsScreenState();
// }

// class _NewLoanBankAccountDetailsScreenState
//     extends ConsumerState<BankAccountDetails> {
//   final _cancelToken = CancelToken();
//   bool _verifyingBankAccount = false;
//   bool _accountNumberReadOnly = false;
//   bool _ifscCodeReadOnly = false;
//   bool _gettingBankAccountFormDetails = false;

//   final _bankAccountTextInputController = TextEditingController();
//   final _ifscCodeTextInputController = TextEditingController();

//   Future<void> _verifyBankAccountDetails() async {
//     if (_verifyingBankAccount) {
//       return;
//     }

//     setState(() {
//       _verifyingBankAccount = true;
//     });

//     var bankVerificationResponse = await ref
//         .read(newLoanStateProvider.notifier)
//         .submitBankAccountDetails(_ifscCodeReadOnly, _cancelToken);

//     if (!mounted) return;

//     if (!bankVerificationResponse.success) {
//       setState(() {
//         _verifyingBankAccount = false;
//       });

//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: bankVerificationResponse.message,
//           contentType: ContentType.failure,
//         ),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//       return;
//     }
//   }

//   Future<void> _fetchBankAccountFormDetails() async {
//     if (_gettingBankAccountFormDetails) {
//       return;
//     }

//     setState(() {
//       _gettingBankAccountFormDetails = true;
//     });

//     var response = await ref
//         .read(newLoanStateProvider.notifier)
//         .fetchBankAccountFormDetails(_cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       context.go(AppRoutes.msme_new_loan_process_error,
//           extra: response.message);
//     }

//     setState(() {
//       _gettingBankAccountFormDetails = false;
//     });

//     if (response.data['account_number_readonly']) {
//       ref
//           .read(newLoanStateProvider.notifier)
//           .updateBankAccountNumber(response.data['account_number']);

//       _bankAccountTextInputController.text = response.data['account_number'];

//       setState(() {
//         _accountNumberReadOnly = true;
//       });
//     }

//     if (response.data['ifsc_readonly']) {
//       ref
//           .read(newLoanStateProvider.notifier)
//           .updateBankIFSC(response.data['ifsc']);

//       _ifscCodeTextInputController.text = response.data['ifsc'];

//       setState(() {
//         _ifscCodeReadOnly = true;
//       });
//     }

//     return;
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchBankAccountFormDetails();
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final _ = ref.watch(serverSentEventStateProvider);
//     ref.watch(loanEventStateProvider);
//     return PopScope(
//       canPop: false,
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           body: SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(
//                 RelativeSize.width(20, width),
//                 RelativeSize.height(20, height),
//                 RelativeSize.width(20, width),
//                 RelativeSize.height(50, height)),
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
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
//                         color: Theme.of(context)
//                             .colorScheme
//                             .onSurface
//                             .withOpacity(0.65),
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(),
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
//                 const SpacerWidget(height: 35),
//                 _gettingBankAccountFormDetails
//                     ? SizedBox(
//                         width: width,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Lottie.asset(
//                                 "assets/animations/loading_spinner.json",
//                                 height: 160,
//                                 width: 160),
//                             const SpacerWidget(height: 35),
//                             Text(
//                               "Fetching Bank Details Form!",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h2,
//                                 fontWeight: AppFontWeights.bold,
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : BankAccountDetailsForm(
//                         bankAccountTextInputController:
//                             _bankAccountTextInputController,
//                         ifscCodeTextInputController:
//                             _ifscCodeTextInputController,
//                         verifyBankAccountDetails: _verifyBankAccountDetails,
//                         verifyingBankAccount: _verifyingBankAccount,
//                         accountNumberReadOnly: _accountNumberReadOnly,
//                         ifscCodeReadOnly: _ifscCodeReadOnly,
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BankAccountDetailsForm extends ConsumerWidget {
//   final Function verifyBankAccountDetails;
//   final TextEditingController bankAccountTextInputController;
//   final TextEditingController ifscCodeTextInputController;
//   final bool verifyingBankAccount;
//   final bool accountNumberReadOnly;
//   final bool ifscCodeReadOnly;

//   const BankAccountDetailsForm(
//       {super.key,
//       required this.bankAccountTextInputController,
//       required this.ifscCodeTextInputController,
//       required this.verifyBankAccountDetails,
//       required this.verifyingBankAccount,
//       required this.accountNumberReadOnly,
//       required this.ifscCodeReadOnly});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Share Loan Deposit A/c",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h1,
//               fontWeight: AppFontWeights.bold,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//             softWrap: true,
//           ),
//           const SpacerWidget(height: 15),
//           Text(
//             "Enter your account where the loan needs to be disbursed by the lender",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h3,
//               fontWeight: AppFontWeights.normal,
//               color: Theme.of(context).colorScheme.onSurface,
//               letterSpacing: 0.14,
//             ),
//             softWrap: true,
//           ),
//           const SpacerWidget(height: 35),
//           Text(
//             "ENTER ACCOUNT NUMBER",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h2,
//               fontWeight: AppFontWeights.medium,
//               color: Theme.of(context).colorScheme.onSurface,
//               letterSpacing: 0.14,
//             ),
//             softWrap: true,
//           ),
//           const SpacerWidget(height: 15),
//           TextField(
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.start,
//             onChanged: (val) {
//               ref
//                   .read(newLoanStateProvider.notifier)
//                   .updateBankAccountNumber(val);
//             },
//             controller: bankAccountTextInputController,
//             readOnly: accountNumberReadOnly,
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.body,
//               fontWeight: AppFontWeights.bold,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             textDirection: TextDirection.ltr,
//             decoration: InputDecoration(
//               counterText: "",
//               hintText: 'Bank Account Number',
//               contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//               hintStyle: TextStyle(
//                 fontFamily: fontFamily,
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.normal,
//                 color: Theme.of(context).colorScheme.scrim,
//               ),
//               fillColor: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
//               filled: true,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//             ),
//           ),
//           const SpacerWidget(height: 30),
//           Text(
//             "ENTER IFSC CODE",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h2,
//               fontWeight: AppFontWeights.medium,
//               color: Theme.of(context).colorScheme.onSurface,
//               letterSpacing: 0.14,
//             ),
//             softWrap: true,
//           ),
//           const SpacerWidget(height: 15),
//           TextField(
//             keyboardType: TextInputType.text,
//             textAlign: TextAlign.start,
//             onChanged: (val) {
//               ref.read(newLoanStateProvider.notifier).updateBankIFSC(val);
//             },
//             controller: ifscCodeTextInputController,
//             readOnly: ifscCodeReadOnly,
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.body,
//               fontWeight: AppFontWeights.bold,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             inputFormatters: [UpperCaseTextInputFormatter()],
//             textDirection: TextDirection.ltr,
//             decoration: InputDecoration(
//               counterText: "",
//               hintText: 'IFSC Code',
//               contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//               hintStyle: TextStyle(
//                 fontFamily: fontFamily,
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.normal,
//                 color: Theme.of(context).colorScheme.scrim,
//               ),
//               fillColor: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
//               filled: true,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//             ),
//           ),
//           const SpacerWidget(
//             height: 20,
//           ),
//           verifyingBankAccount
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       "Verifying Bank Account Details...",
//                       style: TextStyle(
//                         fontFamily: fontFamily,
//                         color: Theme.of(context).colorScheme.scrim,
//                         fontSize: AppFontSizes.body,
//                         fontWeight: AppFontWeights.medium,
//                       ),
//                     ),
//                   ],
//                 )
//               : const SpacerWidget(),
//           const SpacerWidget(
//             height: 120,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ContinueButton(
//                 onPressed: () async {
//                   await verifyBankAccountDetails();
//                 },
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
