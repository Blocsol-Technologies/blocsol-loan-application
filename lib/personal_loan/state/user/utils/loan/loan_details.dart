import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum LoanRepaymentStatus {
  pending,
  missedPayment,
  closed,
}

enum LoanPaymentStatus {
  pending,
  success,
  missed,
  deferred,
}

enum EndUse {
  consumerDurablePurchase,
  education,
  travel,
  health,
  other,
}

class LSPContactInfo {
  final String name;
  final String email;
  final String phone;
  final String address;

  LSPContactInfo({
    required this.name,
    required this.email,
    required this.phone,
    this.address = "",
  });

  factory LSPContactInfo.fromJson(Map<String, dynamic> json) {
    return LSPContactInfo(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['number'] ?? "",
      address: json['address'] ?? "",
    );
  }

  static LSPContactInfo demoContactInfo() {
    return LSPContactInfo(
      name: "",
      email: "",
      phone: "",
      address: "",
    );
  }
}

class ContactInfo {
  final String name;
  final String email;
  final String phone;
  final String customerSupportLink;
  final String customerSupportEmail;
  final String customerSupportContact;

  ContactInfo({
    required this.name,
    required this.email,
    required this.phone,
    this.customerSupportEmail = "",
    this.customerSupportLink = "",
    this.customerSupportContact = "",
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        phone: json['contact_number'] ?? "",
        customerSupportLink: json['customer_support_link'] ?? "",
        customerSupportEmail: json['customer_support_email'] ?? "",
        customerSupportContact: json["customer_support_contact_number"] ?? "");
  }

  static ContactInfo demoContactInfo() {
    return ContactInfo(
      name: "",
      email: "",
      phone: "",
      customerSupportEmail: "",
      customerSupportLink: "",
    );
  }
}

class PaymentsMade {
  final String paymentId;
  final String paymentAmount;
  final num paymentTime;

  PaymentsMade({
    required this.paymentId,
    required this.paymentAmount,
    required this.paymentTime,
  });

  factory PaymentsMade.fromJson(Map<String, dynamic> json) {
    return PaymentsMade(
      paymentId: json['payment_id'] ?? "",
      paymentAmount: json['amount'] ?? "",
      paymentTime: json['time'] ?? "",
    );
  }
}

class CancellationTerm {
  final String sanctionedFee;
  final String disbursementFee;

  CancellationTerm({
    required this.sanctionedFee,
    required this.disbursementFee,
  });

  static CancellationTerm demoCancellationTerm() {
    return CancellationTerm(
      sanctionedFee: "",
      disbursementFee: "",
    );
  }

  factory CancellationTerm.fromJson(Map<String, dynamic> json) {
    try {
      return CancellationTerm(
        sanctionedFee: json['sanction_fee'] ?? "",
        disbursementFee: json['disbursed_fee'] ?? "",
      );
    } catch (e) {
      return CancellationTerm(
        sanctionedFee: "",
        disbursementFee: "",
      );
    }
  }
}

class DocumentDetails {
  final String code;
  final String name;
  final String shortDesc;
  final String longDesc;
  final String mimeType;
  final String url;

  DocumentDetails({
    this.code = "",
    this.name = "",
    this.shortDesc = "",
    this.longDesc = "",
    this.mimeType = "",
    this.url = "",
  });

  factory DocumentDetails.fromJson(Map<String, dynamic> json) {
    return DocumentDetails(
      code: json['descriptor']?['code'] ?? "",
      name: json['descriptor']?['name'] ?? "",
      shortDesc: json['descriptor']?['short_desc'] ?? "",
      longDesc: json['descriptor']?['long_desc'] ?? "",
      mimeType: json['mime_type'] ?? "",
      url: json['url'] ?? "",
    );
  }
}

class LenderDetails {
  final String lenderName;
  final String lenderId;
  final String lenderContact;
  final String lenderEmail;

  LenderDetails({
    required this.lenderName,
    required this.lenderId,
    required this.lenderContact,
    required this.lenderEmail,
  });

  factory LenderDetails.fromJson(Map<String, dynamic> json) {
    return LenderDetails(
      lenderName: json['lenderName'] ?? "",
      lenderId: json['lenderId'] ?? "",
      lenderContact: json['lenderContact'] ?? "",
      lenderEmail: json['lenderEmail'] ?? "",
    );
  }

  static LenderDetails demoLender() {
    return LenderDetails(
      lenderName: "",
      lenderId: "",
      lenderContact: "",
      lenderEmail: "",
    );
  }
}

class PaymentDetails {
  final String id;
  final String amount;
  final String type;
  final LoanPaymentStatus status;
  final String dueDate;
  final String paymentURL;
  final String timeLabel;

  PaymentDetails({
    required this.id,
    required this.amount,
    required this.status,
    required this.dueDate,
    required this.paymentURL,
    required this.type,
    required this.timeLabel,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    String statusVal = json['status'] ?? "";
    LoanPaymentStatus status = LoanPaymentStatus.pending;

    switch (statusVal) {
      case "PAID":
        status = LoanPaymentStatus.success;
        break;
      case "NOT_PAID":
        status = LoanPaymentStatus.pending;
        break;
      case "DELAYED":
        status = LoanPaymentStatus.missed;
        break;
      case "DEFERRED":
        status = LoanPaymentStatus.deferred;
        break;
    }

    return PaymentDetails(
      id: json['id'] ?? "",
      amount: json['params']?['amount'] ?? "",
      status: status,
      dueDate: json['time']?['range']['end'] ?? "",
      paymentURL: json['url'] ?? "",
      type: json['type'] ?? "",
      timeLabel: json['time']?['label'] ?? "",
    );
  }

  static PaymentDetails demoPayment() {
    return PaymentDetails(
      id: "",
      amount: "",
      status: LoanPaymentStatus.pending,
      dueDate: "",
      paymentURL: "",
      type: "",
      timeLabel: "",
    );
  }
}

// Modify the LoanPaymentDetails class to match ConfirmPayments
class LoanPaymentDetails {
  final String paymentId;
  final String totalPaymentAmount;
  final List<PaymentDetails> paymentDetails;

  LoanPaymentDetails({
    required this.paymentId,
    required this.totalPaymentAmount,
    required this.paymentDetails,
  });

  factory LoanPaymentDetails.fromJson(Map<String, dynamic> json) {
    List<PaymentDetails> formattedPayments = [];
    List<dynamic> listItems = json['payments'] ?? [];

    for (var val in listItems) {
      var paymentDetails = PaymentDetails.fromJson(val);

      if (paymentDetails.amount.isEmpty || paymentDetails.type == "ON_ORDER") {
        continue;
      }

      formattedPayments.add(paymentDetails);
    }

    var totalPayment = 0.0;

    for (var payment in formattedPayments) {
      if (payment.type == "ON_ORDER") {
        continue;
      }
      totalPayment += double.parse(extractNumericValue(payment.amount));
    }

    return LoanPaymentDetails(
      paymentId: json['paymentId'] ?? "",
      totalPaymentAmount: '$totalPayment',
      paymentDetails: formattedPayments,
    );
  }

  static LoanPaymentDetails demoPayment() {
    return LoanPaymentDetails(
      paymentId: "",
      totalPaymentAmount: "",
      paymentDetails: [],
    );
  }

  PaymentDetails getOfferPaymentDetails(PersonalLoanInitiatedActionType initiatedAction, String id ) {
    if (initiatedAction == PersonalLoanInitiatedActionType.none) {
      return PaymentDetails.demoPayment();
    }

    if (initiatedAction == PersonalLoanInitiatedActionType.missedEmi) {
      for (var payment in paymentDetails) {
        if (payment.id == id && payment.status == LoanPaymentStatus.success) {
            return payment;
        }

        return PaymentDetails.demoPayment();
      }
    }

    if (initiatedAction == PersonalLoanInitiatedActionType.prepayment) {
      for (var payment in paymentDetails) {
        if (payment.id == id && payment.status == LoanPaymentStatus.success) {
            return payment;
        }

        return PaymentDetails.demoPayment();
      }
    }

     if (initiatedAction == PersonalLoanInitiatedActionType.foreclosure) {
      for (var payment in paymentDetails) {
        if (payment.timeLabel == "FORECLOSURE" && payment.status == LoanPaymentStatus.success) {
            return payment;
        }

        return PaymentDetails.demoPayment();
      }
    }
     return PaymentDetails.demoPayment();
  }

  
}

enum PersonalLoanInitiatedActionType {
  none,
  prepayment,
  foreclosure,
  missedEmi,
}

String extractNumericValue(String input) {
  if (input.isEmpty) return "0";

  RegExp regex = RegExp(r'[\d.]+');
  Iterable<Match> matches = regex.allMatches(input);
  String extracted = '';

  for (Match match in matches) {
    extracted += match.group(0)!; // Append matched substring
  }

  return extracted;
}

class PersonalLoanDetails {
  final String state;
  final String offerId;
  final String offerProviderId;
  final String bankName;
  final String bankLogoURL;
  final String transactionId;
  final String fulfillmentStatus;

  final EndUse endUse;
  final String emi;
  final bool disbursementErr;
  final bool allPaid;
  final bool paymentMissed;
  final String totalRepaymentAmount;
  final String netDisbursedAmount;
  final String deposit;
  final String interest;
  final String interestRate;
  final String interestRateType;
  final String interestRateConversionCharge;
  final String processingFee;
  final String tenure;
  final String lateCharge;
  final String prepaymentPenalty;
  final String applicationFee;
  final String otherPenaltyFee;
  final String otherCharges;
  final String terms;
  final String annualPercentageRate;
  final String insuranceCharges;
  final String numInstallments;
  final String coolOffPeriod;
  final String repaymentFrequency;

  final List<DocumentDetails> docList;
  final CancellationTerm cancellationTerms;
  final List<PaymentsMade> paymentsMade;
  final ContactInfo contactDetails;
  final LSPContactInfo lspContactDetails;

  final LoanRepaymentStatus loanStatus;
  final LoanPaymentDetails loanPayments;

  PersonalLoanDetails({
    required this.offerId,
    required this.state,
    required this.endUse,
    required this.offerProviderId,
    required this.bankName,
    this.bankLogoURL = "",
    required this.transactionId,
    this.fulfillmentStatus = "INITIATED",
    this.totalRepaymentAmount = "",
    this.interest = "",
    required this.interestRate,
    this.netDisbursedAmount = "",
    this.allPaid = false,
    this.paymentMissed = false,
    required this.interestRateType,
    this.interestRateConversionCharge = "",
    required this.processingFee,
    required this.tenure,
    required this.deposit,
    required this.lateCharge,
    required this.disbursementErr,
    required this.prepaymentPenalty,
    this.applicationFee = "",
    this.otherPenaltyFee = "",
    this.otherCharges = "",
    this.terms = "",
    this.emi = "",
    required this.loanStatus,
    required this.loanPayments,
    required this.docList,
    required this.cancellationTerms,
    required this.contactDetails,
    required this.paymentsMade,
    required this.lspContactDetails,
    this.annualPercentageRate = "",
    this.insuranceCharges = "",
    this.numInstallments = "",
    this.repaymentFrequency = "MONTHLY",
    this.coolOffPeriod = "",
  });

  factory PersonalLoanDetails.fromJson(Map<String, dynamic> json) {
    try {
      var endUse = EndUse.other;

      switch (json['endUse']) {
        case "consumerDurablePurchase":
          endUse = EndUse.consumerDurablePurchase;
          break;
        case "education":
          endUse = EndUse.education;
          break;
        case "travel":
          endUse = EndUse.travel;
          break;
        case "health":
          endUse = EndUse.health;
          break;
        case "other":
          endUse = EndUse.other;
          break;
      }

      bool allPaid = json['allPaid'] ?? false;
      bool paymentMissed = json['paymentDelayed'] ?? false;

      ContactInfo contactDetails =
          ContactInfo.fromJson(json['contact_info'] ?? {});
      LSPContactInfo lspContactDetails =
          LSPContactInfo.fromJson(json['lsp_contact_info'] ?? {});
      List<DocumentDetails> formattedDocList = [];
      CancellationTerm formattedCancellationTerms =
          CancellationTerm.fromJson(json['confirm_cancellation_terms']);
      List<PaymentsMade> formattedPaymentsMade = [];

      List<dynamic> listItems = json['documents'] ?? [];

      formattedDocList =
          listItems.map((item) => DocumentDetails.fromJson(item)).toList();

      listItems = json['payments_made'] ?? [];
      formattedPaymentsMade =
          listItems.map((item) => PaymentsMade.fromJson(item)).toList();

      return PersonalLoanDetails(
        offerId: json['id'] ?? "",
        state: json['state'] ?? "",
        endUse: endUse,
        offerProviderId: json['offerProviderId'] ?? "",
        bankName: json['bankName'] ?? "",
        bankLogoURL: json['bankLogoURL'] ?? "",
        transactionId: json['transactionId'] ?? "",
        fulfillmentStatus: json['fulfillment_status'] ?? "INITIATED",
        deposit: json['deposit'] ?? "",
        totalRepaymentAmount: json['totalRepaymentAmount'] ?? "",
        interest: json['interest'] ?? "",
        interestRate: json['interestRate'] ?? "",
        interestRateType: json['interestRateType'] ?? "",
        interestRateConversionCharge:
            json['interestRateConversionCharge'] ?? "",
        applicationFee: json['applicationFee'] ?? "",
        processingFee: json['processingFee'] ?? "",
        tenure: json['tenure'] ?? "",
        lateCharge: json['lateCharge'] ?? "",
        prepaymentPenalty: json['prepaymentPenalty'] ?? "",
        otherPenaltyFee: json['otherPenaltyFee'] ?? "",
        otherCharges: json['otherCharges'] ?? "",
        terms: json['termsAndConditon'] ?? "",
        netDisbursedAmount: json['netDisbursedAmount'] ?? "",
        emi: json['emi'] ?? "",
        disbursementErr: json['disbursement_err'] ?? false,
        allPaid: allPaid,
        paymentMissed: paymentMissed,
        loanStatus: allPaid
            ? LoanRepaymentStatus.closed
            : paymentMissed
                ? LoanRepaymentStatus.missedPayment
                : LoanRepaymentStatus.pending,
        loanPayments: LoanPaymentDetails.fromJson(json['payments']),
        docList: formattedDocList,
        cancellationTerms: formattedCancellationTerms,
        paymentsMade: formattedPaymentsMade,
        contactDetails: contactDetails,
        lspContactDetails: lspContactDetails,
        annualPercentageRate: json['annualPercentageRate'] ?? "",
        insuranceCharges: json['insuranceCharges'] ?? "",
        numInstallments: json['numInstallments'] ?? "",
        repaymentFrequency: (json['repaymentFrequency'] as String).isEmpty
            ? "MONTHLY"
            : json['repaymentFrequency'],
        coolOffPeriod: json['coolOffPeriod'] ?? "",
      );
    } catch (e, stackTrace) {
      ErrorInstance(
        message: e.toString(),
        trace: stackTrace,
      ).reportError();

      return demoOffer();
    }
  }

  String extractNumericValue(String input) {
    if (input.isEmpty) return "0";

    RegExp regex = RegExp(r'[\d.]+');
    Iterable<Match> matches = regex.allMatches(input);
    String extracted = '';

    for (Match match in matches) {
      extracted += match.group(0)!; // Append matched substring
    }

    return extracted;
  }

  double getInterestRate() {
    try {
      return double.parse(extractNumericValue(interestRate));
    } catch (e) {
      return 0;
    }
  }

  String getNumericalValOrDefault(String val) {
    try {
      return extractNumericValue(val);
    } catch (e) {
      return "0";
    }
  }

  bool isLoanDisbursed() {
    return fulfillmentStatus == "DISBURSED";
  }

  bool isLoanClosed() {
    return fulfillmentStatus == "COMPLETED";
  }

  String getBalanceLeft() {
    try {
      double amount = double.parse(totalRepaymentAmount);
      double paid = 0;

      for (var payment in loanPayments.paymentDetails) {
        if (payment.type == "ON_ORDER") {
          continue;
        }
        if (payment.status == LoanPaymentStatus.success) {
          paid += double.parse(payment.amount);
        }
      }

      var totalVal = (amount - paid).roundToDouble();

      if (totalVal < 0) {
        return "0";
      }

      return (totalVal).toString();
    } catch (e) {
      return "0";
    }
  }

  double getAmountPaidPercentage() {
    double amountPaid = 0;

    for (var payment in loanPayments.paymentDetails) {
      if (payment.type == "ON_ORDER") {
        continue;
      }
      if (payment.status == LoanPaymentStatus.success) {
        amountPaid += double.parse(payment.amount);
      }
    }

    var totalAmount = 0.0;

    try {
      totalAmount = double.parse(totalRepaymentAmount);

      var percent = amountPaid / totalAmount;

      if (percent < 0) {
        return 0;
      }

      if (percent > 1) {
        return 1;
      }

      return percent;
    } catch (err, stackTrace) {
      var errorInstance = ErrorInstance(
        message: err.toString(),
        trace: stackTrace,
      );

      errorInstance.reportError();

      return 0;
    }
  }

  String getAmountPaid() {
    double amountPaid = 0;

    for (var payment in loanPayments.paymentDetails) {
      if (payment.type == "ON_ORDER") {
        continue;
      }
      if (payment.status == LoanPaymentStatus.success) {
        amountPaid += double.parse(payment.amount);
      }
    }

    return amountPaid.toString();
  }

  String getNextDueDate() {
    try {
      bool isClosed = isLoanClosed();

      if (isClosed) {
        return "-";
      }

      var payments = loanPayments.paymentDetails;

      payments.sort((a, b) {
        return parseDateTimeString(a.dueDate)
            .compareTo(parseDateTimeString(b.dueDate));
      });

      String date = "";

      DateFormat formatter = DateFormat('dd MMM, yy');

      for (var payment in payments) {
        if (payment.type == "ON_ORDER") {
          continue;
        }
        if (payment.status == LoanPaymentStatus.pending) {
          date = formatter.format(parseDateTimeString(payment.dueDate));
          break;
        }
      }

      if (date.isEmpty) {
        return "NA";
      }

      return date;
    } catch (e) {
      return "";
    }
  }

  String getNextPayment() {
    try {
      bool isClosed = isLoanClosed();

      if (isClosed) {
        return "-";
      }

      var payments = loanPayments.paymentDetails;

      payments.sort((a, b) {
        return parseDateTimeString(a.dueDate)
            .compareTo(parseDateTimeString(b.dueDate));
      });

      String amount = "";

      for (var payment in payments) {
        if (payment.type == "ON_ORDER") {
          continue;
        }

        if (payment.status == LoanPaymentStatus.pending) {
          amount = double.parse(payment.amount).toString();
          break;
        }
      }

      if (amount.isEmpty) {
        return "0";
      }

      return amount;
    } catch (e) {
      return "";
    }
  }

  double getPaidEMIPercentage() {
    try {
      var payments = loanPayments.paymentDetails;

      var paidEMIs = 0;

      for (var payment in payments) {
        if (payment.status == LoanPaymentStatus.success) {
          paidEMIs += 1;
        }
      }

      return (paidEMIs / payments.length);
    } catch (e) {
      return 0;
    }
  }

  int getNumEMIS() {
    try {
      return loanPayments.paymentDetails.length;
    } catch (e) {
      return 0;
    }
  }

  int getNumPaidEMIS() {
    try {
      var payments = loanPayments.paymentDetails;

      var paidEMIs = 0;

      for (var payment in payments) {
        if (payment.status == LoanPaymentStatus.success ||
            payment.status == LoanPaymentStatus.deferred) {
          paidEMIs += 1;
        }
      }

      bool isClosed = isLoanClosed();

      return isClosed ? payments.length : paidEMIs;
    } catch (e) {
      return 0;
    }
  }

  String formatDate(String dateTime) {
    try {
      String date = "";

      DateFormat formatter = DateFormat('dd MMM, yy');

      date = formatter.format(parseDateTimeString(dateTime));

      return date;
    } catch (e) {
      return "";
    }
  }

  String getPaymentStatus(LoanPaymentStatus status) {
    switch (status) {
      case LoanPaymentStatus.pending:
        return "Unpaid";
      case LoanPaymentStatus.success:
        return "Paid";
      case LoanPaymentStatus.missed:
        return "Missed";
      case LoanPaymentStatus.deferred:
        return "Deferred";
    }
  }

  Color getPaymentStatusColor(LoanPaymentStatus status) {
    switch (status) {
      case LoanPaymentStatus.pending:
        return Colors.orange;
      case LoanPaymentStatus.success:
        return Colors.green;
      case LoanPaymentStatus.missed:
        return Colors.red;
      case LoanPaymentStatus.deferred:
        return Colors.blue;
    }
  }

  num getNumericalValue(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0;
    }
  }

  num getTotalDisbursedAmount() {
    try {
      if (netDisbursedAmount.isNotEmpty) {
        return getNumericalValue(netDisbursedAmount);
      }

      num depositVal = getNumericalValue(deposit);
      num applicationFeeVal = getNumericalValue(applicationFee);
      num processingFeeVal = getNumericalValue(processingFee);
      num insuranceChargesVal = getNumericalValue(insuranceCharges);
      num otherChargesVal = getNumericalValue(otherCharges);

      return (((depositVal -
                      applicationFeeVal -
                      processingFeeVal -
                      insuranceChargesVal -
                      otherChargesVal) *
                  100)
              .round()) /
          100;
    } catch (e) {
      return 0;
    }
  }

  static PersonalLoanDetails demoOffer() {
    return PersonalLoanDetails(
      offerId: "",
      state: "",
      endUse: EndUse.other,
      offerProviderId: "",
      bankName: "",
      bankLogoURL: "",
      transactionId: "",
      disbursementErr: false,
      interestRate: "",
      interestRateType: "",
      processingFee: "",
      tenure: "",
      deposit: "",
      lateCharge: "",
      prepaymentPenalty: "",
      loanStatus: LoanRepaymentStatus.pending,
      loanPayments: LoanPaymentDetails.demoPayment(),
      docList: [],
      cancellationTerms: CancellationTerm.demoCancellationTerm(),
      paymentsMade: [],
      contactDetails: ContactInfo.demoContactInfo(),
      lspContactDetails: LSPContactInfo.demoContactInfo(),
    );
  }
}

DateTime parseDateTimeString(String dateTime) {
  try {
    // Try a normal parse
    try {
      return DateTime.parse(dateTime);
    } catch (e) {
      // If it fails, try to remove the milliseconds
      return DateTime.parse(dateTime.substring(0, dateTime.indexOf('.')));
    }
  } catch (e) {
    return DateTime.now().add(const Duration(days: 36500));
  }
}
