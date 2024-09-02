enum InvoiceLoanServiceErrorCodes {
  unable_to_select_offer, // on_select_01 error
  on_select_02_error,
  aadhar_kyc_failed,
  init_01_error,
  entity_kyc_error,
  init_02_failed,
  init_03_failed,
  repayment_setup_failed,
  init_04_failed,
  loan_agreement_failed,
  confirm_01_failed,
  on_update_01_failed,
  generate_monitoring_consent_failed,
  monitoring_consent_verification_failed,
  request_timeout,
}