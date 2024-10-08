// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_request_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LoanRequestStateData {
  bool get requestingNewLoan => throw _privateConstructorUsedError;
  LoanRequestProgress get currentState => throw _privateConstructorUsedError;
  String get transactionId => throw _privateConstructorUsedError;
  String get gstDataDownloadTime => throw _privateConstructorUsedError;
  bool get downloadingGSTData => throw _privateConstructorUsedError;
  int get gstInvoicesFetchedTime => throw _privateConstructorUsedError; //
  AccountAggregatorInfo get selectedAA => throw _privateConstructorUsedError;
  bool get aaConsentSuccess => throw _privateConstructorUsedError;
  List<Invoice> get invoices => throw _privateConstructorUsedError;
  bool get loadingInvoices => throw _privateConstructorUsedError;
  bool get submittingInvoicesForOffers => throw _privateConstructorUsedError; //
  LoanDetails get selectedInvoice => throw _privateConstructorUsedError;
  OfferDetails get selectedOffer => throw _privateConstructorUsedError;
  bool get fetchingInvoiceWithOffers => throw _privateConstructorUsedError;
  bool get offerSelected => throw _privateConstructorUsedError;
  List<LoanDetails> get invoicesWithOffers =>
      throw _privateConstructorUsedError;
  int get invoiceWithOffersFetchTime => throw _privateConstructorUsedError;
  bool get loanUpdateFormSubmitted => throw _privateConstructorUsedError;
  bool get multipleSubmissionsForOfferUpdateForm =>
      throw _privateConstructorUsedError; //
  bool get skipAadharKyc => throw _privateConstructorUsedError;
  bool get fetchingAadharKYCURl => throw _privateConstructorUsedError;
  bool get verifyingAadharKYC => throw _privateConstructorUsedError;
  bool get aadharKYCFailure => throw _privateConstructorUsedError;
  bool get skipEntityKyc => throw _privateConstructorUsedError;
  bool get fetchingEntityKYCURl => throw _privateConstructorUsedError;
  bool get verifyingEntityKYC => throw _privateConstructorUsedError;
  bool get entityKYCFailure => throw _privateConstructorUsedError; //
  String get bankName => throw _privateConstructorUsedError;
  String get bankAccountNumber => throw _privateConstructorUsedError;
  String get bankIFSC => throw _privateConstructorUsedError;
  bool get submittingBankAccountDetails =>
      throw _privateConstructorUsedError; //
  String get disbursedCancellationFee => throw _privateConstructorUsedError;
  String get sanctionedCancellationFee => throw _privateConstructorUsedError;
  bool get fetchingRepaymentSetupUrl => throw _privateConstructorUsedError;
  bool get checkingRepaymentSetupSuccess => throw _privateConstructorUsedError;
  bool get repaymentSetupFailure => throw _privateConstructorUsedError; //
  bool get fetchingLoanAgreementForm => throw _privateConstructorUsedError;
  bool get verifyingLoanAgreementSuccess => throw _privateConstructorUsedError;
  bool get loanAgreementFailure => throw _privateConstructorUsedError;
  bool get generatingMonitoringConsent => throw _privateConstructorUsedError;
  bool get generateMonitoringConsentErr => throw _privateConstructorUsedError;
  bool get validatingMonitoringConsentSuccess =>
      throw _privateConstructorUsedError;
  bool get monitoringConsentError => throw _privateConstructorUsedError;
  String get loanId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LoanRequestStateDataCopyWith<LoanRequestStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanRequestStateDataCopyWith<$Res> {
  factory $LoanRequestStateDataCopyWith(LoanRequestStateData value,
          $Res Function(LoanRequestStateData) then) =
      _$LoanRequestStateDataCopyWithImpl<$Res, LoanRequestStateData>;
  @useResult
  $Res call(
      {bool requestingNewLoan,
      LoanRequestProgress currentState,
      String transactionId,
      String gstDataDownloadTime,
      bool downloadingGSTData,
      int gstInvoicesFetchedTime,
      AccountAggregatorInfo selectedAA,
      bool aaConsentSuccess,
      List<Invoice> invoices,
      bool loadingInvoices,
      bool submittingInvoicesForOffers,
      LoanDetails selectedInvoice,
      OfferDetails selectedOffer,
      bool fetchingInvoiceWithOffers,
      bool offerSelected,
      List<LoanDetails> invoicesWithOffers,
      int invoiceWithOffersFetchTime,
      bool loanUpdateFormSubmitted,
      bool multipleSubmissionsForOfferUpdateForm,
      bool skipAadharKyc,
      bool fetchingAadharKYCURl,
      bool verifyingAadharKYC,
      bool aadharKYCFailure,
      bool skipEntityKyc,
      bool fetchingEntityKYCURl,
      bool verifyingEntityKYC,
      bool entityKYCFailure,
      String bankName,
      String bankAccountNumber,
      String bankIFSC,
      bool submittingBankAccountDetails,
      String disbursedCancellationFee,
      String sanctionedCancellationFee,
      bool fetchingRepaymentSetupUrl,
      bool checkingRepaymentSetupSuccess,
      bool repaymentSetupFailure,
      bool fetchingLoanAgreementForm,
      bool verifyingLoanAgreementSuccess,
      bool loanAgreementFailure,
      bool generatingMonitoringConsent,
      bool generateMonitoringConsentErr,
      bool validatingMonitoringConsentSuccess,
      bool monitoringConsentError,
      String loanId});
}

/// @nodoc
class _$LoanRequestStateDataCopyWithImpl<$Res,
        $Val extends LoanRequestStateData>
    implements $LoanRequestStateDataCopyWith<$Res> {
  _$LoanRequestStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestingNewLoan = null,
    Object? currentState = null,
    Object? transactionId = null,
    Object? gstDataDownloadTime = null,
    Object? downloadingGSTData = null,
    Object? gstInvoicesFetchedTime = null,
    Object? selectedAA = null,
    Object? aaConsentSuccess = null,
    Object? invoices = null,
    Object? loadingInvoices = null,
    Object? submittingInvoicesForOffers = null,
    Object? selectedInvoice = null,
    Object? selectedOffer = null,
    Object? fetchingInvoiceWithOffers = null,
    Object? offerSelected = null,
    Object? invoicesWithOffers = null,
    Object? invoiceWithOffersFetchTime = null,
    Object? loanUpdateFormSubmitted = null,
    Object? multipleSubmissionsForOfferUpdateForm = null,
    Object? skipAadharKyc = null,
    Object? fetchingAadharKYCURl = null,
    Object? verifyingAadharKYC = null,
    Object? aadharKYCFailure = null,
    Object? skipEntityKyc = null,
    Object? fetchingEntityKYCURl = null,
    Object? verifyingEntityKYC = null,
    Object? entityKYCFailure = null,
    Object? bankName = null,
    Object? bankAccountNumber = null,
    Object? bankIFSC = null,
    Object? submittingBankAccountDetails = null,
    Object? disbursedCancellationFee = null,
    Object? sanctionedCancellationFee = null,
    Object? fetchingRepaymentSetupUrl = null,
    Object? checkingRepaymentSetupSuccess = null,
    Object? repaymentSetupFailure = null,
    Object? fetchingLoanAgreementForm = null,
    Object? verifyingLoanAgreementSuccess = null,
    Object? loanAgreementFailure = null,
    Object? generatingMonitoringConsent = null,
    Object? generateMonitoringConsentErr = null,
    Object? validatingMonitoringConsentSuccess = null,
    Object? monitoringConsentError = null,
    Object? loanId = null,
  }) {
    return _then(_value.copyWith(
      requestingNewLoan: null == requestingNewLoan
          ? _value.requestingNewLoan
          : requestingNewLoan // ignore: cast_nullable_to_non_nullable
              as bool,
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as LoanRequestProgress,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      gstDataDownloadTime: null == gstDataDownloadTime
          ? _value.gstDataDownloadTime
          : gstDataDownloadTime // ignore: cast_nullable_to_non_nullable
              as String,
      downloadingGSTData: null == downloadingGSTData
          ? _value.downloadingGSTData
          : downloadingGSTData // ignore: cast_nullable_to_non_nullable
              as bool,
      gstInvoicesFetchedTime: null == gstInvoicesFetchedTime
          ? _value.gstInvoicesFetchedTime
          : gstInvoicesFetchedTime // ignore: cast_nullable_to_non_nullable
              as int,
      selectedAA: null == selectedAA
          ? _value.selectedAA
          : selectedAA // ignore: cast_nullable_to_non_nullable
              as AccountAggregatorInfo,
      aaConsentSuccess: null == aaConsentSuccess
          ? _value.aaConsentSuccess
          : aaConsentSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      invoices: null == invoices
          ? _value.invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<Invoice>,
      loadingInvoices: null == loadingInvoices
          ? _value.loadingInvoices
          : loadingInvoices // ignore: cast_nullable_to_non_nullable
              as bool,
      submittingInvoicesForOffers: null == submittingInvoicesForOffers
          ? _value.submittingInvoicesForOffers
          : submittingInvoicesForOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedInvoice: null == selectedInvoice
          ? _value.selectedInvoice
          : selectedInvoice // ignore: cast_nullable_to_non_nullable
              as LoanDetails,
      selectedOffer: null == selectedOffer
          ? _value.selectedOffer
          : selectedOffer // ignore: cast_nullable_to_non_nullable
              as OfferDetails,
      fetchingInvoiceWithOffers: null == fetchingInvoiceWithOffers
          ? _value.fetchingInvoiceWithOffers
          : fetchingInvoiceWithOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      offerSelected: null == offerSelected
          ? _value.offerSelected
          : offerSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      invoicesWithOffers: null == invoicesWithOffers
          ? _value.invoicesWithOffers
          : invoicesWithOffers // ignore: cast_nullable_to_non_nullable
              as List<LoanDetails>,
      invoiceWithOffersFetchTime: null == invoiceWithOffersFetchTime
          ? _value.invoiceWithOffersFetchTime
          : invoiceWithOffersFetchTime // ignore: cast_nullable_to_non_nullable
              as int,
      loanUpdateFormSubmitted: null == loanUpdateFormSubmitted
          ? _value.loanUpdateFormSubmitted
          : loanUpdateFormSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
      multipleSubmissionsForOfferUpdateForm: null ==
              multipleSubmissionsForOfferUpdateForm
          ? _value.multipleSubmissionsForOfferUpdateForm
          : multipleSubmissionsForOfferUpdateForm // ignore: cast_nullable_to_non_nullable
              as bool,
      skipAadharKyc: null == skipAadharKyc
          ? _value.skipAadharKyc
          : skipAadharKyc // ignore: cast_nullable_to_non_nullable
              as bool,
      fetchingAadharKYCURl: null == fetchingAadharKYCURl
          ? _value.fetchingAadharKYCURl
          : fetchingAadharKYCURl // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingAadharKYC: null == verifyingAadharKYC
          ? _value.verifyingAadharKYC
          : verifyingAadharKYC // ignore: cast_nullable_to_non_nullable
              as bool,
      aadharKYCFailure: null == aadharKYCFailure
          ? _value.aadharKYCFailure
          : aadharKYCFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      skipEntityKyc: null == skipEntityKyc
          ? _value.skipEntityKyc
          : skipEntityKyc // ignore: cast_nullable_to_non_nullable
              as bool,
      fetchingEntityKYCURl: null == fetchingEntityKYCURl
          ? _value.fetchingEntityKYCURl
          : fetchingEntityKYCURl // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingEntityKYC: null == verifyingEntityKYC
          ? _value.verifyingEntityKYC
          : verifyingEntityKYC // ignore: cast_nullable_to_non_nullable
              as bool,
      entityKYCFailure: null == entityKYCFailure
          ? _value.entityKYCFailure
          : entityKYCFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccountNumber: null == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      bankIFSC: null == bankIFSC
          ? _value.bankIFSC
          : bankIFSC // ignore: cast_nullable_to_non_nullable
              as String,
      submittingBankAccountDetails: null == submittingBankAccountDetails
          ? _value.submittingBankAccountDetails
          : submittingBankAccountDetails // ignore: cast_nullable_to_non_nullable
              as bool,
      disbursedCancellationFee: null == disbursedCancellationFee
          ? _value.disbursedCancellationFee
          : disbursedCancellationFee // ignore: cast_nullable_to_non_nullable
              as String,
      sanctionedCancellationFee: null == sanctionedCancellationFee
          ? _value.sanctionedCancellationFee
          : sanctionedCancellationFee // ignore: cast_nullable_to_non_nullable
              as String,
      fetchingRepaymentSetupUrl: null == fetchingRepaymentSetupUrl
          ? _value.fetchingRepaymentSetupUrl
          : fetchingRepaymentSetupUrl // ignore: cast_nullable_to_non_nullable
              as bool,
      checkingRepaymentSetupSuccess: null == checkingRepaymentSetupSuccess
          ? _value.checkingRepaymentSetupSuccess
          : checkingRepaymentSetupSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      repaymentSetupFailure: null == repaymentSetupFailure
          ? _value.repaymentSetupFailure
          : repaymentSetupFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      fetchingLoanAgreementForm: null == fetchingLoanAgreementForm
          ? _value.fetchingLoanAgreementForm
          : fetchingLoanAgreementForm // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingLoanAgreementSuccess: null == verifyingLoanAgreementSuccess
          ? _value.verifyingLoanAgreementSuccess
          : verifyingLoanAgreementSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      loanAgreementFailure: null == loanAgreementFailure
          ? _value.loanAgreementFailure
          : loanAgreementFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      generatingMonitoringConsent: null == generatingMonitoringConsent
          ? _value.generatingMonitoringConsent
          : generatingMonitoringConsent // ignore: cast_nullable_to_non_nullable
              as bool,
      generateMonitoringConsentErr: null == generateMonitoringConsentErr
          ? _value.generateMonitoringConsentErr
          : generateMonitoringConsentErr // ignore: cast_nullable_to_non_nullable
              as bool,
      validatingMonitoringConsentSuccess: null ==
              validatingMonitoringConsentSuccess
          ? _value.validatingMonitoringConsentSuccess
          : validatingMonitoringConsentSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      monitoringConsentError: null == monitoringConsentError
          ? _value.monitoringConsentError
          : monitoringConsentError // ignore: cast_nullable_to_non_nullable
              as bool,
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanRequestStateDataImplCopyWith<$Res>
    implements $LoanRequestStateDataCopyWith<$Res> {
  factory _$$LoanRequestStateDataImplCopyWith(_$LoanRequestStateDataImpl value,
          $Res Function(_$LoanRequestStateDataImpl) then) =
      __$$LoanRequestStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool requestingNewLoan,
      LoanRequestProgress currentState,
      String transactionId,
      String gstDataDownloadTime,
      bool downloadingGSTData,
      int gstInvoicesFetchedTime,
      AccountAggregatorInfo selectedAA,
      bool aaConsentSuccess,
      List<Invoice> invoices,
      bool loadingInvoices,
      bool submittingInvoicesForOffers,
      LoanDetails selectedInvoice,
      OfferDetails selectedOffer,
      bool fetchingInvoiceWithOffers,
      bool offerSelected,
      List<LoanDetails> invoicesWithOffers,
      int invoiceWithOffersFetchTime,
      bool loanUpdateFormSubmitted,
      bool multipleSubmissionsForOfferUpdateForm,
      bool skipAadharKyc,
      bool fetchingAadharKYCURl,
      bool verifyingAadharKYC,
      bool aadharKYCFailure,
      bool skipEntityKyc,
      bool fetchingEntityKYCURl,
      bool verifyingEntityKYC,
      bool entityKYCFailure,
      String bankName,
      String bankAccountNumber,
      String bankIFSC,
      bool submittingBankAccountDetails,
      String disbursedCancellationFee,
      String sanctionedCancellationFee,
      bool fetchingRepaymentSetupUrl,
      bool checkingRepaymentSetupSuccess,
      bool repaymentSetupFailure,
      bool fetchingLoanAgreementForm,
      bool verifyingLoanAgreementSuccess,
      bool loanAgreementFailure,
      bool generatingMonitoringConsent,
      bool generateMonitoringConsentErr,
      bool validatingMonitoringConsentSuccess,
      bool monitoringConsentError,
      String loanId});
}

/// @nodoc
class __$$LoanRequestStateDataImplCopyWithImpl<$Res>
    extends _$LoanRequestStateDataCopyWithImpl<$Res, _$LoanRequestStateDataImpl>
    implements _$$LoanRequestStateDataImplCopyWith<$Res> {
  __$$LoanRequestStateDataImplCopyWithImpl(_$LoanRequestStateDataImpl _value,
      $Res Function(_$LoanRequestStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestingNewLoan = null,
    Object? currentState = null,
    Object? transactionId = null,
    Object? gstDataDownloadTime = null,
    Object? downloadingGSTData = null,
    Object? gstInvoicesFetchedTime = null,
    Object? selectedAA = null,
    Object? aaConsentSuccess = null,
    Object? invoices = null,
    Object? loadingInvoices = null,
    Object? submittingInvoicesForOffers = null,
    Object? selectedInvoice = null,
    Object? selectedOffer = null,
    Object? fetchingInvoiceWithOffers = null,
    Object? offerSelected = null,
    Object? invoicesWithOffers = null,
    Object? invoiceWithOffersFetchTime = null,
    Object? loanUpdateFormSubmitted = null,
    Object? multipleSubmissionsForOfferUpdateForm = null,
    Object? skipAadharKyc = null,
    Object? fetchingAadharKYCURl = null,
    Object? verifyingAadharKYC = null,
    Object? aadharKYCFailure = null,
    Object? skipEntityKyc = null,
    Object? fetchingEntityKYCURl = null,
    Object? verifyingEntityKYC = null,
    Object? entityKYCFailure = null,
    Object? bankName = null,
    Object? bankAccountNumber = null,
    Object? bankIFSC = null,
    Object? submittingBankAccountDetails = null,
    Object? disbursedCancellationFee = null,
    Object? sanctionedCancellationFee = null,
    Object? fetchingRepaymentSetupUrl = null,
    Object? checkingRepaymentSetupSuccess = null,
    Object? repaymentSetupFailure = null,
    Object? fetchingLoanAgreementForm = null,
    Object? verifyingLoanAgreementSuccess = null,
    Object? loanAgreementFailure = null,
    Object? generatingMonitoringConsent = null,
    Object? generateMonitoringConsentErr = null,
    Object? validatingMonitoringConsentSuccess = null,
    Object? monitoringConsentError = null,
    Object? loanId = null,
  }) {
    return _then(_$LoanRequestStateDataImpl(
      requestingNewLoan: null == requestingNewLoan
          ? _value.requestingNewLoan
          : requestingNewLoan // ignore: cast_nullable_to_non_nullable
              as bool,
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as LoanRequestProgress,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      gstDataDownloadTime: null == gstDataDownloadTime
          ? _value.gstDataDownloadTime
          : gstDataDownloadTime // ignore: cast_nullable_to_non_nullable
              as String,
      downloadingGSTData: null == downloadingGSTData
          ? _value.downloadingGSTData
          : downloadingGSTData // ignore: cast_nullable_to_non_nullable
              as bool,
      gstInvoicesFetchedTime: null == gstInvoicesFetchedTime
          ? _value.gstInvoicesFetchedTime
          : gstInvoicesFetchedTime // ignore: cast_nullable_to_non_nullable
              as int,
      selectedAA: null == selectedAA
          ? _value.selectedAA
          : selectedAA // ignore: cast_nullable_to_non_nullable
              as AccountAggregatorInfo,
      aaConsentSuccess: null == aaConsentSuccess
          ? _value.aaConsentSuccess
          : aaConsentSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      invoices: null == invoices
          ? _value._invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<Invoice>,
      loadingInvoices: null == loadingInvoices
          ? _value.loadingInvoices
          : loadingInvoices // ignore: cast_nullable_to_non_nullable
              as bool,
      submittingInvoicesForOffers: null == submittingInvoicesForOffers
          ? _value.submittingInvoicesForOffers
          : submittingInvoicesForOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedInvoice: null == selectedInvoice
          ? _value.selectedInvoice
          : selectedInvoice // ignore: cast_nullable_to_non_nullable
              as LoanDetails,
      selectedOffer: null == selectedOffer
          ? _value.selectedOffer
          : selectedOffer // ignore: cast_nullable_to_non_nullable
              as OfferDetails,
      fetchingInvoiceWithOffers: null == fetchingInvoiceWithOffers
          ? _value.fetchingInvoiceWithOffers
          : fetchingInvoiceWithOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      offerSelected: null == offerSelected
          ? _value.offerSelected
          : offerSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      invoicesWithOffers: null == invoicesWithOffers
          ? _value._invoicesWithOffers
          : invoicesWithOffers // ignore: cast_nullable_to_non_nullable
              as List<LoanDetails>,
      invoiceWithOffersFetchTime: null == invoiceWithOffersFetchTime
          ? _value.invoiceWithOffersFetchTime
          : invoiceWithOffersFetchTime // ignore: cast_nullable_to_non_nullable
              as int,
      loanUpdateFormSubmitted: null == loanUpdateFormSubmitted
          ? _value.loanUpdateFormSubmitted
          : loanUpdateFormSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
      multipleSubmissionsForOfferUpdateForm: null ==
              multipleSubmissionsForOfferUpdateForm
          ? _value.multipleSubmissionsForOfferUpdateForm
          : multipleSubmissionsForOfferUpdateForm // ignore: cast_nullable_to_non_nullable
              as bool,
      skipAadharKyc: null == skipAadharKyc
          ? _value.skipAadharKyc
          : skipAadharKyc // ignore: cast_nullable_to_non_nullable
              as bool,
      fetchingAadharKYCURl: null == fetchingAadharKYCURl
          ? _value.fetchingAadharKYCURl
          : fetchingAadharKYCURl // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingAadharKYC: null == verifyingAadharKYC
          ? _value.verifyingAadharKYC
          : verifyingAadharKYC // ignore: cast_nullable_to_non_nullable
              as bool,
      aadharKYCFailure: null == aadharKYCFailure
          ? _value.aadharKYCFailure
          : aadharKYCFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      skipEntityKyc: null == skipEntityKyc
          ? _value.skipEntityKyc
          : skipEntityKyc // ignore: cast_nullable_to_non_nullable
              as bool,
      fetchingEntityKYCURl: null == fetchingEntityKYCURl
          ? _value.fetchingEntityKYCURl
          : fetchingEntityKYCURl // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingEntityKYC: null == verifyingEntityKYC
          ? _value.verifyingEntityKYC
          : verifyingEntityKYC // ignore: cast_nullable_to_non_nullable
              as bool,
      entityKYCFailure: null == entityKYCFailure
          ? _value.entityKYCFailure
          : entityKYCFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccountNumber: null == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      bankIFSC: null == bankIFSC
          ? _value.bankIFSC
          : bankIFSC // ignore: cast_nullable_to_non_nullable
              as String,
      submittingBankAccountDetails: null == submittingBankAccountDetails
          ? _value.submittingBankAccountDetails
          : submittingBankAccountDetails // ignore: cast_nullable_to_non_nullable
              as bool,
      disbursedCancellationFee: null == disbursedCancellationFee
          ? _value.disbursedCancellationFee
          : disbursedCancellationFee // ignore: cast_nullable_to_non_nullable
              as String,
      sanctionedCancellationFee: null == sanctionedCancellationFee
          ? _value.sanctionedCancellationFee
          : sanctionedCancellationFee // ignore: cast_nullable_to_non_nullable
              as String,
      fetchingRepaymentSetupUrl: null == fetchingRepaymentSetupUrl
          ? _value.fetchingRepaymentSetupUrl
          : fetchingRepaymentSetupUrl // ignore: cast_nullable_to_non_nullable
              as bool,
      checkingRepaymentSetupSuccess: null == checkingRepaymentSetupSuccess
          ? _value.checkingRepaymentSetupSuccess
          : checkingRepaymentSetupSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      repaymentSetupFailure: null == repaymentSetupFailure
          ? _value.repaymentSetupFailure
          : repaymentSetupFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      fetchingLoanAgreementForm: null == fetchingLoanAgreementForm
          ? _value.fetchingLoanAgreementForm
          : fetchingLoanAgreementForm // ignore: cast_nullable_to_non_nullable
              as bool,
      verifyingLoanAgreementSuccess: null == verifyingLoanAgreementSuccess
          ? _value.verifyingLoanAgreementSuccess
          : verifyingLoanAgreementSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      loanAgreementFailure: null == loanAgreementFailure
          ? _value.loanAgreementFailure
          : loanAgreementFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      generatingMonitoringConsent: null == generatingMonitoringConsent
          ? _value.generatingMonitoringConsent
          : generatingMonitoringConsent // ignore: cast_nullable_to_non_nullable
              as bool,
      generateMonitoringConsentErr: null == generateMonitoringConsentErr
          ? _value.generateMonitoringConsentErr
          : generateMonitoringConsentErr // ignore: cast_nullable_to_non_nullable
              as bool,
      validatingMonitoringConsentSuccess: null ==
              validatingMonitoringConsentSuccess
          ? _value.validatingMonitoringConsentSuccess
          : validatingMonitoringConsentSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      monitoringConsentError: null == monitoringConsentError
          ? _value.monitoringConsentError
          : monitoringConsentError // ignore: cast_nullable_to_non_nullable
              as bool,
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoanRequestStateDataImpl implements _LoanRequestStateData {
  const _$LoanRequestStateDataImpl(
      {required this.requestingNewLoan,
      required this.currentState,
      required this.transactionId,
      required this.gstDataDownloadTime,
      required this.downloadingGSTData,
      required this.gstInvoicesFetchedTime,
      required this.selectedAA,
      required this.aaConsentSuccess,
      required final List<Invoice> invoices,
      required this.loadingInvoices,
      required this.submittingInvoicesForOffers,
      required this.selectedInvoice,
      required this.selectedOffer,
      required this.fetchingInvoiceWithOffers,
      required this.offerSelected,
      required final List<LoanDetails> invoicesWithOffers,
      required this.invoiceWithOffersFetchTime,
      required this.loanUpdateFormSubmitted,
      required this.multipleSubmissionsForOfferUpdateForm,
      required this.skipAadharKyc,
      required this.fetchingAadharKYCURl,
      required this.verifyingAadharKYC,
      required this.aadharKYCFailure,
      required this.skipEntityKyc,
      required this.fetchingEntityKYCURl,
      required this.verifyingEntityKYC,
      required this.entityKYCFailure,
      required this.bankName,
      required this.bankAccountNumber,
      required this.bankIFSC,
      required this.submittingBankAccountDetails,
      required this.disbursedCancellationFee,
      required this.sanctionedCancellationFee,
      required this.fetchingRepaymentSetupUrl,
      required this.checkingRepaymentSetupSuccess,
      required this.repaymentSetupFailure,
      required this.fetchingLoanAgreementForm,
      required this.verifyingLoanAgreementSuccess,
      required this.loanAgreementFailure,
      required this.generatingMonitoringConsent,
      required this.generateMonitoringConsentErr,
      required this.validatingMonitoringConsentSuccess,
      required this.monitoringConsentError,
      required this.loanId})
      : _invoices = invoices,
        _invoicesWithOffers = invoicesWithOffers;

  @override
  final bool requestingNewLoan;
  @override
  final LoanRequestProgress currentState;
  @override
  final String transactionId;
  @override
  final String gstDataDownloadTime;
  @override
  final bool downloadingGSTData;
  @override
  final int gstInvoicesFetchedTime;
//
  @override
  final AccountAggregatorInfo selectedAA;
  @override
  final bool aaConsentSuccess;
  final List<Invoice> _invoices;
  @override
  List<Invoice> get invoices {
    if (_invoices is EqualUnmodifiableListView) return _invoices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoices);
  }

  @override
  final bool loadingInvoices;
  @override
  final bool submittingInvoicesForOffers;
//
  @override
  final LoanDetails selectedInvoice;
  @override
  final OfferDetails selectedOffer;
  @override
  final bool fetchingInvoiceWithOffers;
  @override
  final bool offerSelected;
  final List<LoanDetails> _invoicesWithOffers;
  @override
  List<LoanDetails> get invoicesWithOffers {
    if (_invoicesWithOffers is EqualUnmodifiableListView)
      return _invoicesWithOffers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoicesWithOffers);
  }

  @override
  final int invoiceWithOffersFetchTime;
  @override
  final bool loanUpdateFormSubmitted;
  @override
  final bool multipleSubmissionsForOfferUpdateForm;
//
  @override
  final bool skipAadharKyc;
  @override
  final bool fetchingAadharKYCURl;
  @override
  final bool verifyingAadharKYC;
  @override
  final bool aadharKYCFailure;
  @override
  final bool skipEntityKyc;
  @override
  final bool fetchingEntityKYCURl;
  @override
  final bool verifyingEntityKYC;
  @override
  final bool entityKYCFailure;
//
  @override
  final String bankName;
  @override
  final String bankAccountNumber;
  @override
  final String bankIFSC;
  @override
  final bool submittingBankAccountDetails;
//
  @override
  final String disbursedCancellationFee;
  @override
  final String sanctionedCancellationFee;
  @override
  final bool fetchingRepaymentSetupUrl;
  @override
  final bool checkingRepaymentSetupSuccess;
  @override
  final bool repaymentSetupFailure;
//
  @override
  final bool fetchingLoanAgreementForm;
  @override
  final bool verifyingLoanAgreementSuccess;
  @override
  final bool loanAgreementFailure;
  @override
  final bool generatingMonitoringConsent;
  @override
  final bool generateMonitoringConsentErr;
  @override
  final bool validatingMonitoringConsentSuccess;
  @override
  final bool monitoringConsentError;
  @override
  final String loanId;

  @override
  String toString() {
    return 'LoanRequestStateData(requestingNewLoan: $requestingNewLoan, currentState: $currentState, transactionId: $transactionId, gstDataDownloadTime: $gstDataDownloadTime, downloadingGSTData: $downloadingGSTData, gstInvoicesFetchedTime: $gstInvoicesFetchedTime, selectedAA: $selectedAA, aaConsentSuccess: $aaConsentSuccess, invoices: $invoices, loadingInvoices: $loadingInvoices, submittingInvoicesForOffers: $submittingInvoicesForOffers, selectedInvoice: $selectedInvoice, selectedOffer: $selectedOffer, fetchingInvoiceWithOffers: $fetchingInvoiceWithOffers, offerSelected: $offerSelected, invoicesWithOffers: $invoicesWithOffers, invoiceWithOffersFetchTime: $invoiceWithOffersFetchTime, loanUpdateFormSubmitted: $loanUpdateFormSubmitted, multipleSubmissionsForOfferUpdateForm: $multipleSubmissionsForOfferUpdateForm, skipAadharKyc: $skipAadharKyc, fetchingAadharKYCURl: $fetchingAadharKYCURl, verifyingAadharKYC: $verifyingAadharKYC, aadharKYCFailure: $aadharKYCFailure, skipEntityKyc: $skipEntityKyc, fetchingEntityKYCURl: $fetchingEntityKYCURl, verifyingEntityKYC: $verifyingEntityKYC, entityKYCFailure: $entityKYCFailure, bankName: $bankName, bankAccountNumber: $bankAccountNumber, bankIFSC: $bankIFSC, submittingBankAccountDetails: $submittingBankAccountDetails, disbursedCancellationFee: $disbursedCancellationFee, sanctionedCancellationFee: $sanctionedCancellationFee, fetchingRepaymentSetupUrl: $fetchingRepaymentSetupUrl, checkingRepaymentSetupSuccess: $checkingRepaymentSetupSuccess, repaymentSetupFailure: $repaymentSetupFailure, fetchingLoanAgreementForm: $fetchingLoanAgreementForm, verifyingLoanAgreementSuccess: $verifyingLoanAgreementSuccess, loanAgreementFailure: $loanAgreementFailure, generatingMonitoringConsent: $generatingMonitoringConsent, generateMonitoringConsentErr: $generateMonitoringConsentErr, validatingMonitoringConsentSuccess: $validatingMonitoringConsentSuccess, monitoringConsentError: $monitoringConsentError, loanId: $loanId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanRequestStateDataImpl &&
            (identical(other.requestingNewLoan, requestingNewLoan) ||
                other.requestingNewLoan == requestingNewLoan) &&
            (identical(other.currentState, currentState) ||
                other.currentState == currentState) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.gstDataDownloadTime, gstDataDownloadTime) ||
                other.gstDataDownloadTime == gstDataDownloadTime) &&
            (identical(other.downloadingGSTData, downloadingGSTData) ||
                other.downloadingGSTData == downloadingGSTData) &&
            (identical(other.gstInvoicesFetchedTime, gstInvoicesFetchedTime) ||
                other.gstInvoicesFetchedTime == gstInvoicesFetchedTime) &&
            (identical(other.selectedAA, selectedAA) ||
                other.selectedAA == selectedAA) &&
            (identical(other.aaConsentSuccess, aaConsentSuccess) ||
                other.aaConsentSuccess == aaConsentSuccess) &&
            const DeepCollectionEquality().equals(other._invoices, _invoices) &&
            (identical(other.loadingInvoices, loadingInvoices) ||
                other.loadingInvoices == loadingInvoices) &&
            (identical(other.submittingInvoicesForOffers, submittingInvoicesForOffers) ||
                other.submittingInvoicesForOffers ==
                    submittingInvoicesForOffers) &&
            (identical(other.selectedInvoice, selectedInvoice) ||
                other.selectedInvoice == selectedInvoice) &&
            (identical(other.selectedOffer, selectedOffer) ||
                other.selectedOffer == selectedOffer) &&
            (identical(other.fetchingInvoiceWithOffers, fetchingInvoiceWithOffers) ||
                other.fetchingInvoiceWithOffers == fetchingInvoiceWithOffers) &&
            (identical(other.offerSelected, offerSelected) ||
                other.offerSelected == offerSelected) &&
            const DeepCollectionEquality()
                .equals(other._invoicesWithOffers, _invoicesWithOffers) &&
            (identical(other.invoiceWithOffersFetchTime, invoiceWithOffersFetchTime) ||
                other.invoiceWithOffersFetchTime ==
                    invoiceWithOffersFetchTime) &&
            (identical(other.loanUpdateFormSubmitted, loanUpdateFormSubmitted) ||
                other.loanUpdateFormSubmitted == loanUpdateFormSubmitted) &&
            (identical(other.multipleSubmissionsForOfferUpdateForm, multipleSubmissionsForOfferUpdateForm) ||
                other.multipleSubmissionsForOfferUpdateForm ==
                    multipleSubmissionsForOfferUpdateForm) &&
            (identical(other.skipAadharKyc, skipAadharKyc) ||
                other.skipAadharKyc == skipAadharKyc) &&
            (identical(other.fetchingAadharKYCURl, fetchingAadharKYCURl) ||
                other.fetchingAadharKYCURl == fetchingAadharKYCURl) &&
            (identical(other.verifyingAadharKYC, verifyingAadharKYC) ||
                other.verifyingAadharKYC == verifyingAadharKYC) &&
            (identical(other.aadharKYCFailure, aadharKYCFailure) ||
                other.aadharKYCFailure == aadharKYCFailure) &&
            (identical(other.skipEntityKyc, skipEntityKyc) ||
                other.skipEntityKyc == skipEntityKyc) &&
            (identical(other.fetchingEntityKYCURl, fetchingEntityKYCURl) ||
                other.fetchingEntityKYCURl == fetchingEntityKYCURl) &&
            (identical(other.verifyingEntityKYC, verifyingEntityKYC) ||
                other.verifyingEntityKYC == verifyingEntityKYC) &&
            (identical(other.entityKYCFailure, entityKYCFailure) ||
                other.entityKYCFailure == entityKYCFailure) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankAccountNumber, bankAccountNumber) || other.bankAccountNumber == bankAccountNumber) &&
            (identical(other.bankIFSC, bankIFSC) || other.bankIFSC == bankIFSC) &&
            (identical(other.submittingBankAccountDetails, submittingBankAccountDetails) || other.submittingBankAccountDetails == submittingBankAccountDetails) &&
            (identical(other.disbursedCancellationFee, disbursedCancellationFee) || other.disbursedCancellationFee == disbursedCancellationFee) &&
            (identical(other.sanctionedCancellationFee, sanctionedCancellationFee) || other.sanctionedCancellationFee == sanctionedCancellationFee) &&
            (identical(other.fetchingRepaymentSetupUrl, fetchingRepaymentSetupUrl) || other.fetchingRepaymentSetupUrl == fetchingRepaymentSetupUrl) &&
            (identical(other.checkingRepaymentSetupSuccess, checkingRepaymentSetupSuccess) || other.checkingRepaymentSetupSuccess == checkingRepaymentSetupSuccess) &&
            (identical(other.repaymentSetupFailure, repaymentSetupFailure) || other.repaymentSetupFailure == repaymentSetupFailure) &&
            (identical(other.fetchingLoanAgreementForm, fetchingLoanAgreementForm) || other.fetchingLoanAgreementForm == fetchingLoanAgreementForm) &&
            (identical(other.verifyingLoanAgreementSuccess, verifyingLoanAgreementSuccess) || other.verifyingLoanAgreementSuccess == verifyingLoanAgreementSuccess) &&
            (identical(other.loanAgreementFailure, loanAgreementFailure) || other.loanAgreementFailure == loanAgreementFailure) &&
            (identical(other.generatingMonitoringConsent, generatingMonitoringConsent) || other.generatingMonitoringConsent == generatingMonitoringConsent) &&
            (identical(other.generateMonitoringConsentErr, generateMonitoringConsentErr) || other.generateMonitoringConsentErr == generateMonitoringConsentErr) &&
            (identical(other.validatingMonitoringConsentSuccess, validatingMonitoringConsentSuccess) || other.validatingMonitoringConsentSuccess == validatingMonitoringConsentSuccess) &&
            (identical(other.monitoringConsentError, monitoringConsentError) || other.monitoringConsentError == monitoringConsentError) &&
            (identical(other.loanId, loanId) || other.loanId == loanId));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        requestingNewLoan,
        currentState,
        transactionId,
        gstDataDownloadTime,
        downloadingGSTData,
        gstInvoicesFetchedTime,
        selectedAA,
        aaConsentSuccess,
        const DeepCollectionEquality().hash(_invoices),
        loadingInvoices,
        submittingInvoicesForOffers,
        selectedInvoice,
        selectedOffer,
        fetchingInvoiceWithOffers,
        offerSelected,
        const DeepCollectionEquality().hash(_invoicesWithOffers),
        invoiceWithOffersFetchTime,
        loanUpdateFormSubmitted,
        multipleSubmissionsForOfferUpdateForm,
        skipAadharKyc,
        fetchingAadharKYCURl,
        verifyingAadharKYC,
        aadharKYCFailure,
        skipEntityKyc,
        fetchingEntityKYCURl,
        verifyingEntityKYC,
        entityKYCFailure,
        bankName,
        bankAccountNumber,
        bankIFSC,
        submittingBankAccountDetails,
        disbursedCancellationFee,
        sanctionedCancellationFee,
        fetchingRepaymentSetupUrl,
        checkingRepaymentSetupSuccess,
        repaymentSetupFailure,
        fetchingLoanAgreementForm,
        verifyingLoanAgreementSuccess,
        loanAgreementFailure,
        generatingMonitoringConsent,
        generateMonitoringConsentErr,
        validatingMonitoringConsentSuccess,
        monitoringConsentError,
        loanId
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanRequestStateDataImplCopyWith<_$LoanRequestStateDataImpl>
      get copyWith =>
          __$$LoanRequestStateDataImplCopyWithImpl<_$LoanRequestStateDataImpl>(
              this, _$identity);
}

abstract class _LoanRequestStateData implements LoanRequestStateData {
  const factory _LoanRequestStateData(
      {required final bool requestingNewLoan,
      required final LoanRequestProgress currentState,
      required final String transactionId,
      required final String gstDataDownloadTime,
      required final bool downloadingGSTData,
      required final int gstInvoicesFetchedTime,
      required final AccountAggregatorInfo selectedAA,
      required final bool aaConsentSuccess,
      required final List<Invoice> invoices,
      required final bool loadingInvoices,
      required final bool submittingInvoicesForOffers,
      required final LoanDetails selectedInvoice,
      required final OfferDetails selectedOffer,
      required final bool fetchingInvoiceWithOffers,
      required final bool offerSelected,
      required final List<LoanDetails> invoicesWithOffers,
      required final int invoiceWithOffersFetchTime,
      required final bool loanUpdateFormSubmitted,
      required final bool multipleSubmissionsForOfferUpdateForm,
      required final bool skipAadharKyc,
      required final bool fetchingAadharKYCURl,
      required final bool verifyingAadharKYC,
      required final bool aadharKYCFailure,
      required final bool skipEntityKyc,
      required final bool fetchingEntityKYCURl,
      required final bool verifyingEntityKYC,
      required final bool entityKYCFailure,
      required final String bankName,
      required final String bankAccountNumber,
      required final String bankIFSC,
      required final bool submittingBankAccountDetails,
      required final String disbursedCancellationFee,
      required final String sanctionedCancellationFee,
      required final bool fetchingRepaymentSetupUrl,
      required final bool checkingRepaymentSetupSuccess,
      required final bool repaymentSetupFailure,
      required final bool fetchingLoanAgreementForm,
      required final bool verifyingLoanAgreementSuccess,
      required final bool loanAgreementFailure,
      required final bool generatingMonitoringConsent,
      required final bool generateMonitoringConsentErr,
      required final bool validatingMonitoringConsentSuccess,
      required final bool monitoringConsentError,
      required final String loanId}) = _$LoanRequestStateDataImpl;

  @override
  bool get requestingNewLoan;
  @override
  LoanRequestProgress get currentState;
  @override
  String get transactionId;
  @override
  String get gstDataDownloadTime;
  @override
  bool get downloadingGSTData;
  @override
  int get gstInvoicesFetchedTime;
  @override //
  AccountAggregatorInfo get selectedAA;
  @override
  bool get aaConsentSuccess;
  @override
  List<Invoice> get invoices;
  @override
  bool get loadingInvoices;
  @override
  bool get submittingInvoicesForOffers;
  @override //
  LoanDetails get selectedInvoice;
  @override
  OfferDetails get selectedOffer;
  @override
  bool get fetchingInvoiceWithOffers;
  @override
  bool get offerSelected;
  @override
  List<LoanDetails> get invoicesWithOffers;
  @override
  int get invoiceWithOffersFetchTime;
  @override
  bool get loanUpdateFormSubmitted;
  @override
  bool get multipleSubmissionsForOfferUpdateForm;
  @override //
  bool get skipAadharKyc;
  @override
  bool get fetchingAadharKYCURl;
  @override
  bool get verifyingAadharKYC;
  @override
  bool get aadharKYCFailure;
  @override
  bool get skipEntityKyc;
  @override
  bool get fetchingEntityKYCURl;
  @override
  bool get verifyingEntityKYC;
  @override
  bool get entityKYCFailure;
  @override //
  String get bankName;
  @override
  String get bankAccountNumber;
  @override
  String get bankIFSC;
  @override
  bool get submittingBankAccountDetails;
  @override //
  String get disbursedCancellationFee;
  @override
  String get sanctionedCancellationFee;
  @override
  bool get fetchingRepaymentSetupUrl;
  @override
  bool get checkingRepaymentSetupSuccess;
  @override
  bool get repaymentSetupFailure;
  @override //
  bool get fetchingLoanAgreementForm;
  @override
  bool get verifyingLoanAgreementSuccess;
  @override
  bool get loanAgreementFailure;
  @override
  bool get generatingMonitoringConsent;
  @override
  bool get generateMonitoringConsentErr;
  @override
  bool get validatingMonitoringConsentSuccess;
  @override
  bool get monitoringConsentError;
  @override
  String get loanId;
  @override
  @JsonKey(ignore: true)
  _$$LoanRequestStateDataImplCopyWith<_$LoanRequestStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
