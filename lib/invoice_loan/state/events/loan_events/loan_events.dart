import 'dart:async';
import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/constants.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/state/loan_events_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/single/liability.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/riverpod.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loan_events.g.dart';

@riverpod
class InvoiceLoanEvents extends _$InvoiceLoanEvents {
  @override
  LoanEvent build() {
    var timer = Timer.periodic(
        Duration(seconds: refetchInvoiceLoanEventsInterval), (timer) async {
      await fetchLatestEventForConsumption();
    });

    ref.cacheFor(const Duration(seconds: 30), () {
      timer.cancel();
    });

    return LoanEvent.demo();
  }

  void reset() {
    ref.invalidateSelf();
  }

  Future<void> fetchLatestEventForConsumption() async {
    try {
      final cancelToken = CancelToken();

      var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

      var transactionId = ref.read(invoiceNewLoanRequestProvider).transactionId;
      var providerId =
          ref.read(invoiceNewLoanRequestProvider).selectedOffer.offerProviderId;

      if (authToken.isEmpty) {
        return;
      }

      if (transactionId.isEmpty || providerId.isEmpty) {
        transactionId = ref
            .read(invoiceLoanLiabilityProvider)
            .selectedLiability
            .offerDetails
            .transactionId;
        providerId = ref
            .read(invoiceLoanLiabilityProvider)
            .selectedLiability
            .offerDetails
            .offerProviderId;
      }

      if (transactionId.isEmpty || providerId.isEmpty) {
        return;
      }

      var httpService = HttpService(service: ServiceType.InvoiceLoan);
      var response = await httpService
          .post("/ondc/get-latest-event", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (!response.data['success']) {
        return;
      }

      var latestEvent = LoanEvent.fromJson(response.data['data']['event']);

      await consumeEvent(latestEvent);

      return;
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching latest loan events! Contact Support...",
        exception: e,
        trace: stackTrace,
      ).reportError();
    }
  }

  Future<void> consumeEvent(LoanEvent event) async {
    final cancelToken = CancelToken();

    String context = event.context;
    num stepNumber = event.stepNumber;
    bool success = event.success;
    String message = event.message;

    logger.w(
        "Message received from the server: $message \n, Step number received from the server: $stepNumber \n, Success received from the server: $success, Consumed ${event.consumed}");

    if (event.consumed) {
      return;
    }

    var prevEvent = state;

    if (prevEvent.messageId == event.messageId && prevEvent.consumed) {
      return;
    }

    if (prevEvent.timeStamp > event.timeStamp) {
      return;
    }

    if (prevEvent.priority > event.priority) {
      return;
    }

    switch (context) {
      case "select":
        // on_select_01
        if (stepNumber == 1) {
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .setUpdateMultipleSubmissionsEnabled(event.nextStepNumber == 1);

            await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .refetchSelectedOfferDetails(cancelToken);

            ref.read(routerProvider).pushReplacement(
                InvoiceNewLoanRequestRouter.loan_key_fact_sheet);

            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.unable_to_select_offer);
            break;
          }
        }

        // on_select_02
        if (stepNumber == 2) {
          if (success) {
            await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .refetchSelectedOfferDetails(cancelToken);

            if (ref
                .read(invoiceNewLoanRequestProvider)
                .multipleSubmissionsForOfferUpdateForm) {
              ref
                  .read(invoiceNewLoanRequestProvider.notifier)
                  .setSkipAadharKyc(event.nextStepNumber == 4);

              ref.read(routerProvider).pushReplacement(
                  InvoiceNewLoanRequestRouter.loan_key_fact_sheet);

              break;
            }

            if (event.nextStepNumber == 3) {
              ref
                  .read(invoiceNewLoanRequestProvider.notifier)
                  .setSkipAadharKyc(false);
              // ref
              //     .read(routerProvider)
              //     .pushReplacement(InvoiceNewLoanRequestRouter.aadhar_kyc);
              break;
            }

            if (event.nextStepNumber == 4) {
              final cancelToken = CancelToken();

              ref
                  .read(invoiceNewLoanRequestProvider.notifier)
                  .performInitRequest(cancelToken);

              break;
            }

            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.on_select_02_error);
            break;
          }
        }

        // kyc form response
        if (stepNumber == 3) {
          if (success) {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.kyc_verified,
                extra: IBCKycType.aadhar);

            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.aadhar_kyc_failed);
            break;
          }
        }

        break;
      case "init":
        // on_init_01 response
        if (stepNumber == 1) {
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.aadharKycCompleted);

            ref
                .read(routerProvider)
                .pushReplacement(InvoiceNewLoanRequestRouter.entity_kyc);
            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.init_01_error);
            break;
          }
        }

        // entity kyc response
        if (stepNumber == 2) {
          if (success) {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.kyc_verified,
                extra: IBCKycType.entity);
            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.entity_kyc_error);
            break;
          }
        }

        // on_init_02 response
        if (stepNumber == 3) {
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.entityKycCompleted);

            ref.read(routerProvider).pushReplacement(
                InvoiceNewLoanRequestRouter.bank_account_details);

            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.init_02_failed);
            break;
          }
        }

        // on_init_03 response
        if (stepNumber == 5) {
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.bankAccountDetailsProvided);

            ref
                .read(routerProvider)
                .pushReplacement(InvoiceNewLoanRequestRouter.repayment_setup);
            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.init_03_failed);
            break;
          }
        }

        // repayment setup response
        if (stepNumber == 6) {
          if (success) {
            var response = await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .checkRepaymentSetupSuccess(cancelToken);

            if (!response.success) {
              ref.read(routerProvider).push(
                  InvoiceNewLoanRequestRouter.loan_service_error,
                  extra: InvoiceLoanServiceErrorCodes.repayment_setup_failed);
              break;
            }
            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.repayment_setup_failed);
            break;
          }
        }

        // on_init_04 response
        if (stepNumber == 7) {
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.repaymentSetupCompleted);

            ref
                .read(routerProvider)
                .pushReplacement(InvoiceNewLoanRequestRouter.loan_agreement);
            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.init_04_failed);
            break;
          }
        }

        // loan agreement response
        if (stepNumber == 8) {
          if (success) {
            var response = await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .checkLoanAgreementSuccess(cancelToken);

            if (!response.success) {
              ref.read(routerProvider).push(
                  InvoiceNewLoanRequestRouter.loan_service_error,
                  extra: InvoiceLoanServiceErrorCodes.loan_agreement_failed);
              break;
            }
            return;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.loan_agreement_failed);
            break;
          }
        }

        break;
      case "confirm":
        // on_confirm_01 response
        if (stepNumber == 1) {
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.loanAgreementCompleted);

            ref
                .read(routerProvider)
                .pushReplacement(InvoiceNewLoanRequestRouter.final_processing);

            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.confirm_01_failed);
            break;
          }
        }

        if (stepNumber == 2) {
          if (success) {
            ref.read(routerProvider).pushReplacement(
                InvoiceNewLoanRequestRouter.generate_monitoring_consent);

            break;
          } else {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.on_update_01_failed);
            break;
          }
        }

        // Loan Sanctioned
        if (stepNumber == 3 || stepNumber == 4) {
          if (!success) {
            ref.read(routerProvider).push(
                InvoiceNewLoanRequestRouter.loan_service_error,
                extra: InvoiceLoanServiceErrorCodes.confirm_01_failed);
            break;
          }
        }

        break;
      case "payments":
        if (stepNumber == 2) {
          if (success) {
            await ref
                .read(invoiceLoanLiabilityProvider.notifier)
                .fetchSingleLiabilityDetails(cancelToken);
            ref.read(routerProvider).go(
                InvoiceLoanLiabilitiesRouter.payment_success_overview,
                extra: true);
          } else {
            ref.read(routerProvider).pushReplacement(
                InvoiceLoanLiabilitiesRouter.payment_success_overview,
                extra: false);
          }
        }
      default:
        logger.d("No context found");
        break;
    }

    state = LoanEvent(
        messageId: event.messageId,
        transactionId: event.transactionId,
        providerId: event.providerId,
        gst: event.gst,
        message: message,
        success: success,
        context: context,
        stepNumber: stepNumber,
        nextStepNumber: event.nextStepNumber,
        consumed: true,
        timeStamp: event.timeStamp,
        priority: event.priority);

    await setEventConsumed(event.messageId);
    return;
  }

  Future<void> setEventConsumed(String messageId) async {
    final cancelToken = CancelToken();

    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = ref.read(invoiceNewLoanRequestProvider).transactionId;
    var providerId =
        ref.read(invoiceNewLoanRequestProvider).selectedOffer.offerProviderId;

    if (authToken.isEmpty || transactionId.isEmpty || providerId.isEmpty) {
      return;
    }

    try {
      var httpService = HttpService(service: ServiceType.InvoiceLoan);

      await httpService.post("/ondc/consume-event", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "message_id": messageId,
      });

      return;
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching latest loan events! Contact Support...",
        exception: e,
        trace: stackTrace,
      ).reportError();

      return;
    }
  }
}
