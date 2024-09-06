import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/aadhar_kyc_failed.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/conifrm_01_failed.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/entity_kyc_failed.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/init_01_error.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/init_02_error.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/init_03_error.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/init_04_error.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/loan_agreement_failed.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/on_select_02_error.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/on_update_01_failed.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/repayment_setup_failed.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/request_timeout.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/unable_to_select_offer.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceLoanServiceError extends ConsumerStatefulWidget {
  final InvoiceLoanServiceErrorCodes errorCode;
  const InvoiceLoanServiceError({super.key, required this.errorCode});

  @override
  ConsumerState<InvoiceLoanServiceError> createState() =>
      _InvoiceLoanServiceErrorScreenState();
}

class _InvoiceLoanServiceErrorScreenState
    extends ConsumerState<InvoiceLoanServiceError> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: getErrorChild(widget.errorCode),
    );
  }
}

Widget getErrorChild(InvoiceLoanServiceErrorCodes errorCode) {
  switch (errorCode) {
    case InvoiceLoanServiceErrorCodes.unable_to_select_offer:
      return const InvoiceLoanUnableToSelectOffer();
    case InvoiceLoanServiceErrorCodes.on_select_02_error:
      return const InvoiceLoanOnSelect02Error();
    case InvoiceLoanServiceErrorCodes.aadhar_kyc_failed:
      return const InvoiceLoanAadharKycFailed();
    case InvoiceLoanServiceErrorCodes.init_01_error:
      return const InvoiceLoanInit01Error();
    case InvoiceLoanServiceErrorCodes.entity_kyc_error:
      return const InvoiceLoanEntityKycFailed();
    case InvoiceLoanServiceErrorCodes.init_02_failed:
      return const InvoiceLoanInit02Error();
    case InvoiceLoanServiceErrorCodes.init_03_failed:
      return const InvoiceLoanInit03Error();
    case InvoiceLoanServiceErrorCodes.repayment_setup_failed:
      return const InvoiceLoanRepaymentSetupFailed();
    case InvoiceLoanServiceErrorCodes.init_04_failed:
      return const InvoiceLoanInit04Error();
    case InvoiceLoanServiceErrorCodes.loan_agreement_failed:
      return const InvoiceNewLoanAgreementFailed();
    case InvoiceLoanServiceErrorCodes.confirm_01_failed:
      return const InvoiceLoanConfirm01Error();
    case InvoiceLoanServiceErrorCodes.on_update_01_failed:
      return const InvoiceLoanOnUpdate01Error();
    case InvoiceLoanServiceErrorCodes.generate_monitoring_consent_failed:
      return const InvoiceLoanConfirm01Error();
    case InvoiceLoanServiceErrorCodes.monitoring_consent_verification_failed:
      return const InvoiceLoanConfirm01Error();
    case InvoiceLoanServiceErrorCodes.request_timeout:
      return const InvoiceLoanRequestTimeout();
    default:
      return Container();
  }
}
