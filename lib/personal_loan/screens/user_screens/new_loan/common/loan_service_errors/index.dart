import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/aadhar_kyc_failed.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/error_codes.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/loan_agreement_failed.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/on_conifrm_01_failed.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/on_init_01_error.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/on_init_02_error.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/on_init_03_error.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/on_select_03_error.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/on_update_01_failed.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/repayment_setup_failed.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/request_timeout.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/unable_to_select_offer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalLoanServiceError extends ConsumerStatefulWidget {
  final PersonalLoanServiceErrorCodes errorCode;
  const PersonalLoanServiceError({super.key, required this.errorCode});

  @override
  ConsumerState<PersonalLoanServiceError> createState() =>
      _PersonalLoanServiceErrorScreenState();
}

class _PersonalLoanServiceErrorScreenState
    extends ConsumerState<PersonalLoanServiceError> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: getErrorChild(widget.errorCode),
    );
  }
}

Widget getErrorChild(PersonalLoanServiceErrorCodes errorCode) {
  switch (errorCode) {
    case PersonalLoanServiceErrorCodes.unable_to_select_offer:
      return const PersonalLoanUnableToSelectOffer();
    case PersonalLoanServiceErrorCodes.on_select_03_error:
      return const PersonalLoanOnSelect03Error();
    case PersonalLoanServiceErrorCodes.aadhar_kyc_failed:
      return const PersonalLoanAadharKycFailed();
    case PersonalLoanServiceErrorCodes.on_init_01_error:
      return const PersonalLoanOnInit01Error();
    case PersonalLoanServiceErrorCodes.on_init_02_error:
      return const PersonalLoanOnInit02Error();
    case PersonalLoanServiceErrorCodes.repayment_setup_failed:
      return const PersonalLoanRepaymentSetupFailed();
    case PersonalLoanServiceErrorCodes.on_init_03_error:
      return const PersonalLoanOnInit03Error();
    case PersonalLoanServiceErrorCodes.loan_agreement_failed:
      return const PersonalNewLoanAgreementFailed();
    case PersonalLoanServiceErrorCodes.on_confirm_01_failed:
      return const PersonalLoanOnConfirm01Error();
    case PersonalLoanServiceErrorCodes.on_update_01_failed:
      return const PersonalLoanOnUpdate01Error();
    case PersonalLoanServiceErrorCodes.generate_monitoring_consent_failed:
      return const PersonalLoanOnConfirm01Error();
    case PersonalLoanServiceErrorCodes.monitoring_consent_verification_failed:
      return const PersonalLoanOnConfirm01Error();
    case PersonalLoanServiceErrorCodes.request_timeout:
      return const PersonalLoanRequestTimeout();
    default:
      return Container();
  }
}
