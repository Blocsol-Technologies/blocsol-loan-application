import 'dart:async';

import 'package:blocsol_loan_application/global_state/auth/auth.dart';
// import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/state/loan_events_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/single/liability.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loan_events.g.dart';

@riverpod
class InvoiceLoanEvents extends _$InvoiceLoanEvents {
  @override
  Future<LoanEventsState> build() async {
    ref.keepAlive();

    logger.d("refetching the latest event");

    final cancelToken = CancelToken();

    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = ref.read(invoiceNewLoanRequestProvider).transactionId;
    var providerId =
        ref.read(invoiceNewLoanRequestProvider).selectedOffer.offerProviderId;

    if (transactionId == "" || providerId == "") {
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

    logger.d(
        "transactionId: $transactionId, providerId: $providerId, authToken: $authToken");

    if (authToken.isEmpty || transactionId.isEmpty || providerId.isEmpty) {
      return LoanEventsState.initial;
    }

    Timer(const Duration(seconds: 5), () {
      logger.d("invalidating loan event state");
      ref.invalidateSelf();
    });

    try {
      logger.d("making request to server for the latest event");
      var httpService = HttpService();
      var response = await httpService
          .get("/ondc/get-latest-event", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      if (!response.data['success']) {
        if (state.hasValue) {
          return state.value!;
        } else {
          return LoanEventsState.initial;
        }
      }

      var latestEvent = LoanEvent.fromJson(response.data['data']['event']);

      await consumeEvent(latestEvent);

      return LoanEventsState(
        latestEvent: latestEvent,
      );
    } catch (e, stackTrace) {
      ErrorInstance(
        message:
            "Error occured when fetching latest loan events! Contact Support...",
        exception: e,
        trace: stackTrace,
      ).reportError();

      if (state.hasValue) {
        return state.value!;
      } else {
        return LoanEventsState.initial;
      }
    }
  }

  Future<void> consumeEvent(LoanEvent event) async {
    final cancelToken = CancelToken();

    String context = event.context;
    num stepNumber = event.stepNumber;
    bool success = event.success;
    String message = event.message;

    logger.d("Message received from the server: $message \n, Step number received from the server: $stepNumber \n, Success received from the server: $success");

    if (state.hasValue) {
      var prevEvent = state.value!.latestEvent;

      if (prevEvent.messageId == event.messageId && prevEvent.consumed) {
        return;
      }

      if (prevEvent.timeStamp > event.timeStamp) {
        return;
      }

      if (prevEvent.priority > event.priority) {
        return;
      }
    }

    switch (context) {
      case "select":
        // on_select_01
        if (stepNumber == 1) {
          await setEventConsumed(event.messageId);
          if (success) {
            var response = await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .refetchSelectedOfferDetails(cancelToken);

            if (!response.success) {
              // ref.read(routerProvider).go(
              //     AppRoutes.msme_new_loan_process_error,
              //     extra: response.message);

              return;
            }

            // ref
            //     .read(routerProvider)
            //     .go(AppRoutes.msme_new_loan_single_loan_offer_details);

            // if (message == "update_form_not_submitted") {
            //   var response = await ref
            //       .read(invoiceNewLoanRequestProvider.notifier)
            //       .refetchSelectedOfferDetails(cancelToken);

            //   if (!response.success) {
            //     ref.read(routerProvider).go(
            //         AppRoutes.msme_new_loan_process_error,
            //         extra: response.message);

            //     return;
            //   }

            //   ref
            //       .read(routerProvider)
            //       .go(AppRoutes.msme_new_loan_single_loan_offer_details);
            // } else {
            //   ref
            //       .read(routerProvider)
            //       .go(AppRoutes.msme_new_loan_update_offer_details);
            // }
            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Unable to select the offer from the lender");
            return;
          }
        }

        // on_select_02
        if (stepNumber == 2) {
          await setEventConsumed(event.messageId);
          if (success) {
            await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .refetchSelectedOfferDetails(cancelToken);

            // TODO: Mechanism to refetch aadhar kyc url again

            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Error on the on_select_02");

            return;
          }
        }

        // details regarding the KYC form success
        if (stepNumber == 3) {
          await setEventConsumed(event.messageId);
          if (success) {
            var response = await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .checkAadharKycSuccess(cancelToken);

            if (!response.success) {
              ref.read(invoiceNewLoanRequestProvider.notifier).setAadharKYCFailure(true);
              return;
            }

            return;
          } else {
            ref.read(invoiceNewLoanRequestProvider.notifier).setAadharKYCFailure(true);
            return;
          }
        }

        break;
      case "init":
        // on_init_01 response
        if (stepNumber == 1) {
          await setEventConsumed(event.messageId);
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.aadharKycCompleted);
            // ref.read(routerProvider).go(AppRoutes.msme_new_loan_process);
            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Error on the on_init_02");
            return;
          }
        }

        // udyam kyc response
        if (stepNumber == 2) {
          await setEventConsumed(event.messageId);
          if (success) {
            var response = await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .checkUdyamKycFormSuccess(cancelToken);

            if (!response.success) {
              // ref.read(routerProvider).go(
              //     AppRoutes.msme_new_loan_process_error,
              //     extra:
              //         "Error when checking form 04 success ${response.message}");
              return;
            }
            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Error on the udyam kyc status check");
            return;
          }
        }

        // on_init_02 response
        if (stepNumber == 3) {
          await setEventConsumed(event.messageId);

          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.entityKycCompleted);
            // ref.read(routerProvider).go(AppRoutes.msme_new_loan_process);
            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Error on the on_init_02");
            return;
          }
        }

        // on_init_03 response
        if (stepNumber == 5) {
          await setEventConsumed(event.messageId);
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.bankAccountDetailsProvided);
            // ref.read(routerProvider).go(AppRoutes.msme_new_loan_process);
            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Error on the on_init_03");
            return;
          }
        }

        // repayment setup response
        if (stepNumber == 6) {
          await setEventConsumed(event.messageId);
          if (success) {
            if (ref.read(invoiceNewLoanRequestProvider).checkingRepaymentSetupSuccess) {
              return;
            }

            var response = await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .checkRepaymentSetupSuccess(cancelToken);

            if (!response.success) {
              // ref.read(routerProvider).go(
              //     AppRoutes.msme_new_loan_process_error,
              //     extra:
              //         "Error when checking form06 success ${response.message}");
              return;
            }
            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Error on the repayment status check");
            return;
          }
        }

        // on_init_04 response
        if (stepNumber == 7) {
          await setEventConsumed(event.messageId);
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.repaymentSetupCompleted);
            // ref.read(routerProvider).go(AppRoutes.msme_new_loan_process);
            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Error on the on_init_04");
            return;
          }
        }

        // loan agreement response
        if (stepNumber == 8) {
          await setEventConsumed(event.messageId);
          if (success) {
            var response = await ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .checkLoanAgreementSuccess(cancelToken);

            if (!response.success) {
              // ref.read(routerProvider).go(
              //     AppRoutes.msme_new_loan_process_error,
              //     extra:
              //         "Error when checking form07 submission ${response.message}");
              return;
            }
            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Error on the loan agreement status check");
            return;
          }
        }

        break;
      case "confirm":
        // on_confirm_01 response
        if (stepNumber == 1) {
          await setEventConsumed(event.messageId);
          if (success) {
            ref
                .read(invoiceNewLoanRequestProvider.notifier)
                .updateState(LoanRequestProgress.loanAgreementCompleted);
            // ref.read(routerProvider).go(AppRoutes.msme_new_loan_process);
            return;
          } else {
            // ref.read(routerProvider).go(
            //     AppRoutes.msme_new_loan_process_error,
            //     extra: "Error on the on_confirm_01");
            return;
          }
        }
        break;
      default:
        logger.d("No context found");
        break;
    }

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
      var httpService = HttpService();

      var response = await httpService
          .post("/ondc/consume-event", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
        "message_id": messageId,
      });

      if (response.data['success'] && state.hasValue) {
        var currentValue = state.value!.latestEvent;

        currentValue.updateConsumed(true);

        state = state.copyWithPrevious(
          AsyncValue.data(LoanEventsState(latestEvent: currentValue)),
        );
      }

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
