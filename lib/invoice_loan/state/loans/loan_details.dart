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

class Invoice {
  final String companyName;
  final String companyGST;
  final num amount;
  final List<InvoiceItems> invoiceItems;
  final String flag;
  final String irn;
  final String updby;
  final String irngendate;
  final String cflag;
  final String inum;
  final String invTyp;
  final String pos;
  final String srctyp;
  final String idt;
  final String rchrg;
  final String chksum;

  Invoice({
    required this.companyName,
    required this.companyGST,
    required this.amount,
    required this.invoiceItems,
    this.flag = "",
    this.irn = "",
    this.updby = "",
    this.irngendate = "",
    this.cflag = "",
    this.inum = "",
    this.invTyp = "",
    this.pos = "",
    this.srctyp = "",
    this.idt = "",
    this.rchrg = "",
    this.chksum = "",
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    try {
      final List<InvoiceItems> invoiceItems = [];
      if (json['invoiceDetails']?['itms'] != null) {
        final List<dynamic> jsonItems = json['invoiceDetails']['itms'];
        invoiceItems.addAll(
          jsonItems.map((item) => InvoiceItems.fromJson(item)).toList(),
        );
      }

      return Invoice(
        companyName: json['name'],
        companyGST: json['gstin'],
        invoiceItems: invoiceItems,
        amount: json['invoiceDetails']?['val'] ?? "",
        flag: json['invoiceDetails']?['flag'] ?? "",
        irn: json['invoiceDetails']?['irn'] ?? "",
        updby: json['invoiceDetails']?['updby'] ?? "",
        irngendate: json['invoiceDetails']?['irngendate'] ?? "",
        cflag: json['invoiceDetails']?['cflag'] ?? "",
        inum: json['invoiceDetails']?['inum'] ?? "",
        invTyp: json['invoiceDetails']?['inv_typ'] ?? "",
        pos: json['invoiceDetails']?['pos'] ?? "",
        srctyp: json['invoiceDetails']?['srctyp'] ?? "",
        idt: json['invoiceDetails']?['idt'] ?? "",
        rchrg: json['invoiceDetails']?['rchrg'] ?? "",
        chksum: json['invoiceDetails']?['chksum'] ?? "",
      );
    } catch (e, stackTrace) {
      ErrorInstance(
              message:
                  "Err when parsing invoice information on the loan details",
              exception: e,
              trace: stackTrace)
          .reportError();

      return demo();
    }
  }

  static Invoice demo() {
    return Invoice(
      companyName: "",
      companyGST: "",
      amount: 0,
      invoiceItems: [],
      flag: "",
      irn: "",
      updby: "",
      irngendate: "",
      cflag: "",
      inum: "",
      invTyp: "",
      pos: "",
      srctyp: "",
      idt: "",
      rchrg: "",
      chksum: "",
    );
  }
}

class InvoiceItems {
  final int itemNumber;
  final InvoiceItemsDetails itemDetails;

  InvoiceItems({
    required this.itemNumber,
    required this.itemDetails,
  });

  factory InvoiceItems.fromJson(Map<String, dynamic> json) {
    try {
      return InvoiceItems(
        itemNumber: json['num'],
        itemDetails: InvoiceItemsDetails.fromJson(json['itm_det']),
      );
    } catch (e, stackTrace) {
      ErrorInstance(
              message:
                  "Err when parsing invoice items information on the loan details",
              exception: e,
              trace: stackTrace)
          .reportError();
      return demo();
    }
  }

  static InvoiceItems demo() {
    return InvoiceItems(
      itemNumber: 0,
      itemDetails: InvoiceItemsDetails.demo(),
    );
  }
}

class InvoiceItemsDetails {
  final num csamt;
  final num samt;
  final num rt;
  final num txval;
  final num camt;
  final num iamt;

  InvoiceItemsDetails({
    required this.csamt,
    required this.samt,
    required this.rt,
    required this.txval,
    required this.camt,
    required this.iamt,
  });

  factory InvoiceItemsDetails.fromJson(Map<String, dynamic> json) {
    try {
      return InvoiceItemsDetails(
        csamt: json['csamt'],
        samt: json['samt'],
        rt: json['rt'],
        txval: json['txval'],
        camt: json['camt'],
        iamt: json['iamt'],
      );
    } catch (e, stackTrace) {
      ErrorInstance(
              message:
                  "Err when parsing invoice items details info on the loan details",
              exception: e,
              trace: stackTrace)
          .reportError();
      return demo();
    }
  }

  static InvoiceItemsDetails demo() {
    return InvoiceItemsDetails(
      csamt: 0,
      samt: 0,
      rt: 0,
      txval: 0,
      camt: 0,
      iamt: 0,
    );
  }
}

class OfferPaymentDetails {
  final String paymentId;
  final List<OfferPayments> paymentDetails;

  const OfferPaymentDetails({
    required this.paymentDetails,
    required this.paymentId,
  });

  factory OfferPaymentDetails.fromJson(Map<String, dynamic> json) {
    try {
      List<OfferPayments> formattedPayments = [];
      List<dynamic> listItems = json['payments'] ?? [];

      for (var val in listItems) {
        var paymentDetails = OfferPayments.fromJson(val);

        if (paymentDetails.amount.isEmpty ||
            paymentDetails.type == "ON_ORDER") {
          continue;
        }

        formattedPayments.add(paymentDetails);
      }

      return OfferPaymentDetails(
        paymentId: json['paymentId'] ?? "",
        paymentDetails: formattedPayments,
      );
    } catch (err, stackTrace) {
      var errorInstance = ErrorInstance(
        message: "Error in OfferPaymentDetails.fromJson",
        exception: err,
        trace: stackTrace,
      );

      errorInstance.reportError();

      return demo();
    }
  }

  static OfferPaymentDetails demo() {
    return const OfferPaymentDetails(
      paymentDetails: [],
      paymentId: "",
    );
  }
}

class OfferPayments {
  final String type;
  final String url;
  final String amount;
  final String id;
  final LoanPaymentStatus status;
  final String collectedBy;
  final String timeLabel;
  final String startTime;
  final String endTime;

  const OfferPayments({
    required this.amount,
    required this.type,
    required this.url,
    required this.id,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.timeLabel,
    required this.collectedBy,
  });

  factory OfferPayments.fromJson(Map<String, dynamic> json) {
    try {
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

      return OfferPayments(
        type: json['type'] ?? "",
        url: json['url'] ?? "",
        amount: json['params']?['amount'] ?? "",
        id: json['id'] ?? "",
        status: status,
        collectedBy: json['collected_by'] ?? "",
        timeLabel: json['time']?['label'] ?? "",
        startTime: json['time']?['range']?['start'] ?? "",
        endTime: json['time']?['range']?['end'] ?? "",
      );
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error in OfferPayments.fromJson",
        exception: e,
        trace: stackTrace,
      ).reportError();

      return demo();
    }
  }

  static OfferPayments demo() {
    return const OfferPayments(
      type: "",
      url: "",
      amount: "",
      id: "",
      status: LoanPaymentStatus.pending,
      startTime: "",
      endTime: "",
      timeLabel: "",
      collectedBy: "",
    );
  }
}

class OfferDocument {
  final DocumentDescriptor descriptor;
  final String mimeType;
  final String url;

  const OfferDocument({
    required this.descriptor,
    required this.mimeType,
    required this.url,
  });

  factory OfferDocument.fromJson(Map<String, dynamic> json) {
    try {
      final descriptor = DocumentDescriptor(
        code: json['code'] ?? "",
        name: json['name'] ?? "",
        shortDesc: json['short_desc'] ?? "",
        longDesc: json['long_desc'] ?? "",
      );
      final mimetype = json['mime_type'] ?? "";
      final url = json['url'] ?? "";

      return OfferDocument(
        descriptor: descriptor,
        mimeType: mimetype,
        url: url,
      );
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error in OfferDocument.fromJson",
        exception: e,
        trace: stackTrace,
      ).reportError();

      return demo();
    }
  }

  static OfferDocument demo() {
    return const OfferDocument(
      descriptor: DocumentDescriptor(
        code: "",
        name: "",
        shortDesc: "",
        longDesc: "",
      ),
      mimeType: "",
      url: "",
    );
  }
}

class DocumentDescriptor {
  final String code;
  final String name;
  final String shortDesc;
  final String longDesc;

  const DocumentDescriptor({
    required this.code,
    required this.name,
    required this.shortDesc,
    required this.longDesc,
  });

  factory DocumentDescriptor.fromJson(Map<String, dynamic> json) {
    try {
      final code = json['code'] ?? "";
      final name = json['name'] ?? "";
      final shortdesc = json['short_desc'] ?? "";
      final longdesc = json['long_desc'] ?? "";

      return DocumentDescriptor(
          code: code, name: name, shortDesc: shortdesc, longDesc: longdesc);
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error in DocumentDescriptor.fromJson",
        exception: e,
        trace: stackTrace,
      ).reportError();

      return demo();
    }
  }

  static DocumentDescriptor demo() {
    return const DocumentDescriptor(
      code: "",
      name: "",
      shortDesc: "",
      longDesc: "",
    );
  }
}

class OfferCancellationTerms {
  final String sanctionedCancellationPercent;
  final String disbursedCancellationPercent;

  const OfferCancellationTerms({
    required this.sanctionedCancellationPercent,
    required this.disbursedCancellationPercent,
  });

  factory OfferCancellationTerms.fromJson(Map<String, dynamic> json) {
    try {
      final sanctioned = json['sanction_fee'] ?? "";
      final disbursed = json['disbursed_fee'] ?? "";

      return OfferCancellationTerms(
        sanctionedCancellationPercent: sanctioned,
        disbursedCancellationPercent: disbursed,
      );
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error in OfferCancellationTerms.fromJson",
        exception: e,
        trace: stackTrace,
      ).reportError();
      return demo();
    }
  }

  static OfferCancellationTerms demo() {
    return const OfferCancellationTerms(
      sanctionedCancellationPercent: "",
      disbursedCancellationPercent: "",
    );
  }
}

class OfferPaymentsMade {
  final String paymentId;
  final String amount;
  final num time;

  const OfferPaymentsMade({
    required this.paymentId,
    required this.amount,
    required this.time,
  });

  factory OfferPaymentsMade.fromJson(Map<String, dynamic> json) {
    try {
      final paymentId = json['payment_id'] ?? "";
      final amount = json['amount'] ?? "";
      final time = json['time'] ?? 0;

      return OfferPaymentsMade(
        paymentId: paymentId,
        amount: amount,
        time: time,
      );
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error in OfferPaymentsMade.fromJson",
        exception: e,
        trace: stackTrace,
      ).reportError();

      return demo();
    }
  }

  static OfferPaymentsMade demo() {
    return const OfferPaymentsMade(
      paymentId: "",
      amount: "",
      time: 0,
    );
  }
}

class ContactInfo {
  final String name;
  final String email;
  final String contactNumber;
  final String customerSupportLink;
  final String customerSupportNumber;
  final String customerSupportEmail;

  const ContactInfo(
      {required this.name,
      required this.email,
      required this.contactNumber,
      this.customerSupportLink = "",
      required this.customerSupportNumber,
      required this.customerSupportEmail});

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    try {
      final name = json['name'] ?? "";
      final email = json['email'] ?? "";
      final contactNumber = json['contact_number'] ?? "";
      final customerSupportLink = json['customer_support_link'] ?? "";
      final customerSupportNumber =
          json['customer_support_contact_number'] ?? "";
      final customerSupportEmail = json['customer_support_email'] ?? "";

      return ContactInfo(
        name: name,
        email: email,
        contactNumber: contactNumber,
        customerSupportLink: customerSupportLink,
        customerSupportNumber: customerSupportNumber,
        customerSupportEmail: customerSupportEmail,
      );
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error in ContactInfo.fromJson",
        exception: e,
        trace: stackTrace,
      ).reportError();

      return demo();
    }
  }

  static ContactInfo demo() {
    return const ContactInfo(
      name: "",
      email: "",
      contactNumber: "",
      customerSupportLink: "",
      customerSupportNumber: "",
      customerSupportEmail: "",
    );
  }
}

class LSPContactInfo {
  final String name;
  final String email;
  final String number;
  final String address;

  const LSPContactInfo({
    required this.name,
    required this.email,
    required this.number,
    required this.address,
  });

  factory LSPContactInfo.fromJson(Map<String, dynamic> json) {
    try {
      final name = json['name'] ?? "";
      final email = json['email'] ?? "";
      final number = json['number'] ?? "";
      final address = json['address'] ?? "";

      return LSPContactInfo(
        name: name,
        email: email,
        number: number,
        address: address,
      );
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error in LSPContactInfo.fromJson",
        exception: e,
        trace: stackTrace,
      ).reportError();

      return demo();
    }
  }

  static LSPContactInfo demo() {
    return const LSPContactInfo(
      name: "",
      email: "",
      number: "",
      address: "",
    );
  }
}

class OfferDetails {
  final String offerId;
  final String offerProviderId;
  final String bankName;
  final String bankLogoURL;
  final String transactionId;
  final String state;
  final bool disbursementErr;

  final String totalRepayment;
  final String deposit;
  final String netDisbursedAmount;
  final String interest;
  final String annualPercentageRate;
  final String interestRate;
  final String interestRateType;
  final String interestRateConversionCharge;

  final String insuranceCharges;
  final String applicationFee;
  final String processingFee;
  final String tenure;
  final String lateCharge;
  final String prepaymentPenalty;
  final String otherPenaltyFee;
  final String otherCharges;
  final String numInstallments;
  final String installmentAmount;
  final String coolOffPeriod;
  final String terms;
  final bool allPaid;
  final String repaymentFrequency;

  final OfferPaymentDetails payments;
  final List<OfferDocument> documents;
  final OfferCancellationTerms cancellationTerms;
  final List<OfferPaymentsMade> paymentsMade;

  final ContactInfo contactInfo;
  final LSPContactInfo lspContactInfo;

  OfferDetails({
    this.offerId = "",
    required this.offerProviderId,
    required this.bankName,
    this.disbursementErr = false,
    this.state = "",
    this.totalRepayment = "",
    this.netDisbursedAmount = "",
    this.annualPercentageRate = "",
    this.insuranceCharges = "",
    this.repaymentFrequency = "MONTHLY",
    this.bankLogoURL = "",
    this.applicationFee = "0",
    required this.transactionId,
    required this.deposit,
    this.interest = "0",
    this.otherPenaltyFee = "0",
    this.otherCharges = "0",
    this.numInstallments = "0",
    this.installmentAmount = "0",
    this.coolOffPeriod = "",
    required this.interestRate,
    required this.interestRateType,
    this.interestRateConversionCharge = "",
    required this.processingFee,
    required this.tenure,
    required this.lateCharge,
    required this.prepaymentPenalty,
    required this.terms,
    this.allPaid = false,
    required this.payments,
    required this.documents,
    required this.cancellationTerms,
    required this.paymentsMade,
    required this.contactInfo,
    required this.lspContactInfo,
  });

  factory OfferDetails.fromJson(Map<String, dynamic> json, String state) {
    try {
      final payments = OfferPaymentDetails.fromJson(json['payments']);

      final List<OfferDocument> documents = [];
      if (json['documents'] != null) {
        final List<dynamic> documentItems = json['documents'];
        documents.addAll(
          documentItems.map((item) => OfferDocument.fromJson(item)).toList(),
        );
      }

      final List<OfferPaymentsMade> paymentsMade = [];
      if (json['payments_made'] != null) {
        final List<dynamic> paymentsTermsList = json['payments_made'];
        paymentsMade.addAll(
          paymentsTermsList
              .map((item) => OfferPaymentsMade.fromJson(item))
              .toList(),
        );
      }

      final cancellationTerms =
          OfferCancellationTerms.fromJson(json['confirm_cancellation_terms']);
      final contactInfo = ContactInfo.fromJson(json['contact_info']);
      final lspContactInfo = LSPContactInfo.fromJson(json['lsp_contact_info']);

      return OfferDetails(
        state: state,
        offerId: json['offerId'],
        offerProviderId: json['offerProviderId'],
        bankName: json['bankName'],
        bankLogoURL: json['bankLogoURL'],
        transactionId: json['transactionId'],
        disbursementErr: json['disbursement_err'] ?? false,

        // Loan Details
        totalRepayment: json['totalRepaymentAmount'] ?? "",
        deposit: json['deposit'],
        netDisbursedAmount: json['netDisbursement'] ?? "",
        interest: json['interest'] ?? "",
        annualPercentageRate: json['annualPercentageRate'] ?? "",
        interestRate: json['interestRate'],
        interestRateConversionCharge:
            json['interestRateConversionCharge'] ?? "",
        interestRateType: json['interestRateType'],

        // Charges and Penalties
        insuranceCharges: json['insuranceCharges'] ?? "",
        applicationFee: json['applicationFee'] ?? "",
        processingFee: json['processingFee'] ?? "",
        tenure: json['tenure'],
        lateCharge: json['lateCharge'],
        prepaymentPenalty: json['prepaymentPenalty'],
        otherPenaltyFee: json['otherPenaltyFee'] ?? "",
        otherCharges: json['otherCharges'] ?? "",

        // Misc
        terms: json['termsAndConditon'] ?? "",
        numInstallments: json['numInstallments'] ?? "",
        installmentAmount: json['installmentAmount'] ?? "",
        coolOffPeriod: json['coolOffPeriod'] ?? "",
        repaymentFrequency: json['repaymentFrequency'] ?? "MONTHLY",

        allPaid: json['allPaid'] ?? false,
        payments: payments,
        cancellationTerms: cancellationTerms,
        documents: documents,
        paymentsMade: paymentsMade,
        contactInfo: contactInfo,
        lspContactInfo: lspContactInfo,
      );
    } catch (e, stackTrace) {
      ErrorInstance(
              message: "Err when parsing offer details on the loan details",
              exception: e,
              trace: stackTrace)
          .reportError();
      return demo();
    }
  }

  static OfferDetails demo() {
    return OfferDetails(
      offerProviderId: "",
      bankName: "",
      bankLogoURL: "",
      transactionId: "",
      interestRate: "",
      interestRateType: "",
      processingFee: "",
      tenure: "",
      deposit: "",
      lateCharge: "",
      prepaymentPenalty: "",
      terms: "",
      payments: OfferPaymentDetails.demo(),
      cancellationTerms: OfferCancellationTerms.demo(),
      documents: [],
      paymentsMade: [],
      contactInfo: ContactInfo.demo(),
      lspContactInfo: LSPContactInfo.demo(),
    );
  }

  bool isLoanDisbursed() {
    return (state == "final_confirmation" || state == "closed") &&
        !disbursementErr;
  }

  bool isLoanClosed() {
    return state == "closed" || allPaid;
  }

  num getNumericalValue(String value) {
    try {
      return num.parse(value);
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error in getNumericalValue",
        exception: e,
        trace: stackTrace,
      ).reportError();
      return 0;
    }
  }

  num getLoanPercentOfTotalValue(num invoiceAmount) {
    try {
      return (((num.parse(deposit) / invoiceAmount) * 10000).round()) / 100;
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error in getLoanPercentOfTotalValue",
        exception: e,
        trace: stackTrace,
      ).reportError();
      return 0;
    }
  }

  bool checkIfPaymentIsMissedPayment(String paymentStatus) {
    if (paymentStatus == "DELAYED" || paymentStatus == "DEFERRED") {
      return true;
    }
    return false;
  }

  String getBalanceLeft() {
    try {
      num amount = num.parse(totalRepayment);
      double paid = 0;

      for (var payment in payments.paymentDetails) {
        if (payment.type == "ON_ORDER") {
          continue;
        }
        if (payment.status == LoanPaymentStatus.success) {
          paid += num.parse(payment.amount);
        }
      }

      var paidAmount = (amount - paid).roundToDouble();

      if (paidAmount < 0) {
        return "0";
      }

      return (paidAmount).toString();
    } catch (e) {
      return "0";
    }
  }

  String getNextDueDate() {
    try {
      bool isClosed = isLoanClosed();

      if (isClosed) {
        return "-";
      }

      var allPayments = payments.paymentDetails;

      allPayments.sort((a, b) {
        return parseDateTimeString(a.endTime)
            .compareTo(parseDateTimeString(b.endTime));
      });

      String date = "";

      DateFormat formatter = DateFormat('dd MMM, yy');

      for (var payment in allPayments) {
        if (payment.type == "ON_ORDER") {
          continue;
        }

        if (payment.status == LoanPaymentStatus.pending) {
          date = formatter.format(parseDateTimeString(payment.endTime));
          break;
        }
      }

      return date.isEmpty ? "NA" : date;
    } catch (e) {
      return "NA";
    }
  }

  String getAmountPaid() {
    double amountPaid = 0;

    for (var payment in payments.paymentDetails) {
      if (payment.type == "ON_ORDER") {
        continue;
      }
      if (payment.status == LoanPaymentStatus.success) {
        amountPaid += num.parse(payment.amount);
      }
    }

    return amountPaid.toString();
  }

  double getPaidEMIPercentage() {
    try {
      var allPayments = payments.paymentDetails;

      var paidEMIs = 0;

      for (var payment in allPayments) {
        if (payment.status == LoanPaymentStatus.success) {
          paidEMIs += 1;
        }
      }

      return (paidEMIs / allPayments.length);
    } catch (e) {
      return 0;
    }
  }

  int getNumPaidEMIS() {
    try {
      var allPayments = payments.paymentDetails;

      var paidEMIs = 0;

      for (var payment in allPayments) {
        if (payment.status == LoanPaymentStatus.success ||
            payment.status == LoanPaymentStatus.deferred) {
          paidEMIs += 1;
        }
      }

      bool isClosed = isLoanClosed();

      return isClosed ? allPayments.length : paidEMIs;
    } catch (e) {
      return 0;
    }
  }

  int getNumEMIS() {
    try {
      return payments.paymentDetails.length;
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

  String getNumericalValOrDefault(String val) {
    try {
      return extractNumericValue(val);
    } catch (e) {
      return "0";
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

  double getAmountPaidPercentage() {
    num amountPaid = 0;

    for (var payment in payments.paymentDetails) {
      if (payment.type == "ON_ORDER") {
        continue;
      }
      if (payment.status == LoanPaymentStatus.success) {
        amountPaid += num.parse(payment.amount);
      }
    }

    num totalAmount;

    try {
      totalAmount = num.parse(totalRepayment);

      var percent = amountPaid / totalAmount;

      if (percent > 1) {
        return 1;
      }

      if (percent < 0) {
        return 0;
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

  String getNextPayment() {
    try {
      bool isClosed = isLoanClosed();

      if (isClosed) {
        return "0";
      }

      var allPayments = payments.paymentDetails;

      allPayments.sort((a, b) {
        return parseDateTimeString(a.endTime)
            .compareTo(parseDateTimeString(b.endTime));
      });

      String amount = "";

      for (var payment in allPayments) {
        if (payment.type == "ON_ORDER") {
          continue;
        }

        if (payment.status == LoanPaymentStatus.pending) {
          amount = num.parse(payment.amount).toString();
          break;
        }
      }

      return amount.isEmpty ? "0" : amount;
    } catch (e) {
      return "0";
    }
  }
}

class LoanDetails extends Invoice {
  final OfferDetails offerDetails;
  final List<OfferDetails> offerDetailsList;

  LoanDetails({
    required super.companyName,
    required super.companyGST,
    required super.amount,
    required super.invoiceItems,
    required super.pos,
    super.flag,
    super.updby,
    super.irn,
    super.irngendate,
    super.cflag,
    super.inum,
    super.invTyp,
    super.srctyp,
    super.idt,
    super.rchrg,
    super.chksum,
    required this.offerDetails,
    required this.offerDetailsList,
  });

  factory LoanDetails.fromJson(Map<String, dynamic> json) {
    try {
      // Extracting common fields from the JSON
      final companyName = json['name'];
      final companyGST = json['gstin'];
      final amount = json['invoiceDetails']?['val'] ?? "";
      final flag = json['invoiceDetails']?['flag'] ?? "";
      final irn = json['invoiceDetails']?['irn'] ?? "";
      final updby = json['invoiceDetails']?['updby'] ?? "";
      final irngendate = json['invoiceDetails']?['irngendate'] ?? "";
      final cflag = json['invoiceDetails']?['cflag'] ?? "";
      final inum = json['invoiceDetails']?['inum'] ?? "";
      final invTyp = json['invoiceDetails']?['inv_typ'] ?? "";
      final pos = json['invoiceDetails']?['pos'] ?? "";
      final srctyp = json['invoiceDetails']?['srctyp'] ?? "";
      final idt = json['invoiceDetails']?['idt'] ?? "";
      final rchrg = json['invoiceDetails']?['rchrg'] ?? "";
      final chksum = json['invoiceDetails']?['chksum'] ?? "";

      // Extracting InvoiceItems list
      final List<InvoiceItems> invoiceItems = [];
      if (json['invoiceDetails']?['itms'] != null) {
        final List<dynamic> jsonItems = json['invoiceDetails']['itms'];
        invoiceItems.addAll(
          jsonItems.map((item) => InvoiceItems.fromJson(item)).toList(),
        );
      }

      var offerDet = OfferDetails.demo();

      if (json['offerDetails'] != null) {
        offerDet =
            OfferDetails.fromJson(json['offerDetails'], json["state"] ?? "");
      }

      final List<OfferDetails> offerDetailsList = [];

      if (json['multipleOfferDetails'] != null) {
        final List<dynamic> offerDetailsListItems =
            json['multipleOfferDetails'];

        offerDetailsList.addAll(
          offerDetailsListItems
              .map((item) => OfferDetails.fromJson(item, json["state"] ?? ""))
              .toList(),
        );
      }

      return LoanDetails(
        companyName: companyName,
        companyGST: companyGST,
        amount: amount,
        invoiceItems: invoiceItems,
        flag: flag,
        irn: irn,
        updby: updby,
        irngendate: irngendate,
        cflag: cflag,
        inum: inum,
        invTyp: invTyp,
        pos: pos,
        srctyp: srctyp,
        idt: idt,
        rchrg: rchrg,
        chksum: chksum,
        offerDetails: offerDet,
        offerDetailsList: offerDetailsList,
      );
    } catch (e, stackTrace) {
      ErrorInstance(
          message: "Err when parsing loan details on the loan details",
          exception: e,
          trace: stackTrace);

      return demo();
    }
  }

  static LoanDetails demo() {
    return LoanDetails(
      companyName: "",
      companyGST: "",
      amount: 0,
      invoiceItems: [],
      pos: "",
      offerDetails: OfferDetails.demo(),
      offerDetailsList: [],
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
