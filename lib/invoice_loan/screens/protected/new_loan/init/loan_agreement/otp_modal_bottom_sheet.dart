// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/details/company_details_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/loan_events/loan_events_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/new_loan/new_loan_state.dart';
// import 'package:blocsol_invoice_based_credit/utils/lender_utils.dart';
// import 'package:blocsol_invoice_based_credit/utils/regex.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LoanAgreementOTPModalBottomSheet extends ConsumerStatefulWidget {
//   final Function onSubmit;

//   const LoanAgreementOTPModalBottomSheet({super.key, required this.onSubmit});

//   @override
//   ConsumerState<LoanAgreementOTPModalBottomSheet> createState() =>
//       _OTPModalBottomSheetState();
// }

// class _OTPModalBottomSheetState
//     extends ConsumerState<LoanAgreementOTPModalBottomSheet> {
//   final _textInputFocusNode = FocusNode();

//   String _otp = "";
//   bool _otpVerificationError = false;

//   Future<void> submitForm() async {
//     if (!RegexProvider.otpRegex.hasMatch(_otp)) {
//       setState(() {
//         _otpVerificationError = true;
//       });
//       return;
//     }

//     Navigator.of(context).pop();
//     await widget.onSubmit(_otp);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final newLoanStateRef = ref.watch(newLoanStateProvider);
//     final msmeBasicStateRef = ref.watch(companyDetailsStateProvider);
//     ref.watch(loanEventStateProvider);
//     return Container(
//       height: 400,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.fromLTRB(25, 25, 25, 40),
//       color: Theme.of(context).colorScheme.surface,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(
//             height: 40,
//             child: getLenderDetailsAssetURL(newLoanStateRef.bankName,
//                 newLoanStateRef.selectedOffer.bankLogoURL),
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(
//             "OTP sent to mobile number ${msmeBasicStateRef.phone}",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h3,
//               fontWeight: AppFontWeights.normal,
//               color:
//                   Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
//               letterSpacing: 0.14,
//             ),
//           ),
//           const SizedBox(
//             height: 41,
//           ),
//           Text(
//             "VERIFY ACCOUNT",
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.h2,
//               fontWeight: AppFontWeights.bold,
//               color: Theme.of(context).colorScheme.onSurface,
//               letterSpacing: 0.14,
//             ),
//           ),
//           const SizedBox(
//             height: 13,
//           ),
//           TextField(
//             keyboardType: TextInputType.number,
//             maxLength: 6,
//             textAlign: TextAlign.center,
//             onChanged: (value) {
//               setState(() {
//                 _otpVerificationError = false;
//                 _otp = value;
//               });

//               if (value.length == 6) {
//                 _textInputFocusNode.unfocus();
//               }
//             },
//             focusNode: _textInputFocusNode,
//             style: TextStyle(
//               fontFamily: fontFamily,
//               fontSize: AppFontSizes.emphasis,
//               fontWeight: AppFontWeights.bold,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//             decoration: InputDecoration(
//               counterText: "",
//               hintText: '6-Digit OTP',
//               hintStyle: TextStyle(
//                   fontFamily: fontFamily,
//                   fontSize: AppFontSizes.emphasis,
//                   fontWeight: AppFontWeights.normal,
//                   color: Theme.of(context).colorScheme.scrim),
//               fillColor: Theme.of(context).colorScheme.scrim.withOpacity(0.2),
//               filled: true,
//               border: OutlineInputBorder(
//                 borderSide:
//                     BorderSide(color: Theme.of(context).colorScheme.scrim),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide:
//                     BorderSide(color: Theme.of(context).colorScheme.scrim),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: _otpVerificationError
//                       ? Theme.of(context).colorScheme.error
//                       : Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//             ),
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//             ],
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           // ActionButton(
//           //   width: 220,
//           //   text: "Verify OTP",
//           //   onPressed: () async {
//           //     await submitForm();
//           //   },
//           //   fromColor: Theme.of(context).colorScheme.primary,
//           //   toColor: Theme.of(context).colorScheme.surface,
//           // )
//         ],
//       ),
//     );
//   }
// }
