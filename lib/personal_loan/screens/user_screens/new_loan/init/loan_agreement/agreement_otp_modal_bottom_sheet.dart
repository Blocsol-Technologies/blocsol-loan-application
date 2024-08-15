// import 'package:blocsol_personal_credit/state/user/borrower/account_details/borrower_account_details_state.dart';
// import 'package:blocsol_personal_credit/ui/contants.dart';
// import 'package:blocsol_personal_credit/ui/relative_sizer.dart';
// import 'package:blocsol_personal_credit/ui/spacer.dart';
// import 'package:blocsol_personal_credit/utils/regex.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LoanAgreementOTPModalBottomSheet extends ConsumerStatefulWidget {
//   final Function onSubmit;

//   const LoanAgreementOTPModalBottomSheet({super.key, required this.onSubmit});

//   @override
//   ConsumerState<LoanAgreementOTPModalBottomSheet> createState() =>
//       _LoanAgreementOTPModalBottomSheetState();
// }

// class _LoanAgreementOTPModalBottomSheetState
//     extends ConsumerState<LoanAgreementOTPModalBottomSheet> {
//   String _otp = "";
//   bool _otpVerificationError = false;
//   final textInputFocusNode = FocusNode();

//   Future<void> _submitForm() async {
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
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final borrowerBasicStateRef =
//         ref.watch(borrowerAccountDetailsStateProvider);
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(20),
//         topRight: Radius.circular(20),
//       ),
//       child: Container(
//         height: 225,
//         width: MediaQuery.of(context).size.width,
//         padding: const EdgeInsets.fromLTRB(25, 25, 25, 40),
//         color: Theme.of(context).colorScheme.primary,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               "OTP sent to mobile number ${borrowerBasicStateRef.phone}",
//               style: TextStyle(
//                 fontFamily: fontFamily,
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.normal,
//                 color:
//                     Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
//                 letterSpacing: 0.14,
//               ),
//             ),
//             const SpacerWidget(
//               height: 15,
//             ),
//             SizedBox(
//               height: 50,
//               child: TextField(
//                 keyboardType: TextInputType.number,
//                 maxLength: 6,
//                 textAlign: TextAlign.center,
//                 onChanged: (value) {
//                   setState(() {
//                     _otpVerificationError = false;
//                     _otp = value;
//                   });

//                   if (value.length == 6) {
//                     textInputFocusNode.unfocus();
//                   }
//                 },
//                 focusNode: textInputFocusNode,
//                 style: TextStyle(
//                   fontFamily: fontFamily,
//                   fontSize: AppFontSizes.h3,
//                   fontWeight: AppFontWeights.medium,
//                   color: Theme.of(context).colorScheme.onPrimary,
//                 ),
//                 decoration: InputDecoration(
//                   counterText: "",
//                   hintText: '6-Digit OTP',
//                   hintStyle: TextStyle(
//                       fontFamily: fontFamily,
//                       fontSize: AppFontSizes.h3,
//                       fontWeight: AppFontWeights.normal,
//                       color: Theme.of(context).colorScheme.onPrimary),
//                   fillColor:
//                       Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).colorScheme.onPrimary),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).colorScheme.onPrimary),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: _otpVerificationError
//                           ? Theme.of(context).colorScheme.error
//                           : Theme.of(context).colorScheme.primary,
//                     ),
//                   ),
//                 ),
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                 ],
//               ),
//             ),
//             const SpacerWidget(
//               height: 25,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 GestureDetector(
//                   onTap: () {
//                     HapticFeedback.heavyImpact();
//                     _submitForm();
//                   },
//                   child: Container(
//                     height: RelativeSize.height(32.5, height),
//                     width: RelativeSize.width(150, width),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.onPrimary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "Continue",
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
