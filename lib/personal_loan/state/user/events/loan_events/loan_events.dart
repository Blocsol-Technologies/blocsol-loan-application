import 'dart:async';
import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/state/loan_events_state.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/old_loans.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loan_events.g.dart';

@riverpod
class PersonalLoanEvents extends _$PersonalLoanEvents {
  @override
  PersonalLoanEventState build() {
    ref.keepAlive();

    var timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await fetchLatestEventForConsumption();
    });

    ref.onDispose(() {
      timer.cancel();
    });

    return PersonalLoanEventState.initial;
  }

  void reset() {
    ref.invalidateSelf();
  }

  Future<void> fetchLatestEventForConsumption() async {
    try {
      logger.i("Fetching latest personal loan events");

      final cancelToken = CancelToken();

      var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

      var transactionId =
          ref.read(personalNewLoanRequestProvider).transactionId;
      var providerId = ref
          .read(personalNewLoanRequestProvider)
          .selectedOffer
          .offerProviderId;

      logger.i("authToken is $authToken");
      logger.i("transactionId is $transactionId");
      logger.i("providerId is $providerId");

      if (authToken.isEmpty) {
        return;
      }

      if (transactionId.isEmpty || providerId.isEmpty) {
        transactionId = ref
            .read(personalLoanLiabilitiesProvider)
            .selectedOldOffer
            .transactionId;
        providerId = ref
            .read(personalLoanLiabilitiesProvider)
            .selectedOldOffer
            .offerProviderId;
      }

      if (transactionId.isEmpty || providerId.isEmpty) {
        return;
      }

      var httpService = HttpService(service: ServiceType.PersonalLoan);

      var response = await httpService
          .get("/ondc/get-latest-event", authToken, cancelToken, {
        "transaction_id": transactionId,
        "provider_id": providerId,
      });

      logger.i("Latest event response: ${response.data}");

      if (!response.data['success']) {
        return;
      }

      var latestEvent =
          PersonalLoanEvent.fromJson(response.data['data']['event']);

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

  Future<void> consumeEvent(PersonalLoanEvent event) async {
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

    var prevEvent = state.latestEvent;

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
      // Customer will reperform the select request again and again to refetch the offer details change form
      case "select":
        // on_select_01. Cant have on_select_01 and on_select_02 because these are multi lender submissions
        // if (stepNumber == 1) {
        //   if (success) {
        //     ref
        //         .read(personalNewLoanRequestProvider.notifier)
        //         .updateState(PersonalLoanRequestProgress.formGenerated);
        //     ref
        //         .read(routerProvider)
        //         .push(PersonalNewLoanRequestRouter.new_loan_process);
        //     return;
        //   } else {
        //     ref.read(routerProvider).push(PersonalNewLoanRequestRouter.new_loan_error,
        //         extra: "Unable to select the offer from the lender");
        //     return;
        //   }
        // }

        // on_select_02
        // if (stepNumber == 2) {
        //   if (success) {
        //     ref
        //         .read(routerProvider)
        //         .push(PersonalNewLoanRequestRouter.new_loan_update_offer_screen);
        //   } else {
        //     ref.read(routerProvider).push(PersonalNewLoanRequestRouter.new_loan_error,
        //         extra: "Error when fetching the loan update form");

        //     return;
        //   }
        // }

        // on_select_03
        if (stepNumber == 3) {
          if (success) {
            if (ref.read(personalNewLoanRequestProvider).aadharKYCFailure) {
              ref
                  .read(personalNewLoanRequestProvider.notifier)
                  .updateState(PersonalLoanRequestProgress.loanOfferSelect);
              ref
                  .read(personalNewLoanRequestProvider.notifier)
                  .setAadharKYCFailure(false);

              ref
                  .read(routerProvider)
                  .push(PersonalNewLoanRequestRouter.new_loan_process);
              return;
            }

            return;
          } else {
            ref.read(routerProvider).push(
                PersonalNewLoanRequestRouter.new_loan_error,
                extra:
                    "Unable to refetch the updated loan offer from the lender. OnInit03 failed");
            return;
          }
        }

        if (stepNumber == 4) {
          if (success) {
            var response = await ref
                .read(personalNewLoanRequestProvider.notifier)
                .checkAadharKYCSuccess(cancelToken);

            if (!response.success) {
              ref.read(routerProvider).push(
                  PersonalNewLoanRequestRouter.new_loan_error,
                  extra:
                      "Error when checking aadhar kyc success ${response.message}");
              return;
            }
            return;
          } else {
            ref
                .read(personalNewLoanRequestProvider.notifier)
                .setAadharKYCFailure(true);
            return;
          }
        }

        break;
      case "init":
        // on_init_01 response
        if (stepNumber == 1) {
          if (success) {
            ref
                .read(personalNewLoanRequestProvider.notifier)
                .updateState(PersonalLoanRequestProgress.aadharKYC);
            ref
                .read(routerProvider)
                .push(PersonalNewLoanRequestRouter.new_loan_process);
            return;
          } else {
            ref.read(routerProvider).push(
                PersonalNewLoanRequestRouter.new_loan_error,
                extra: "Error on the on_init_01");
            return;
          }
        }

        if (stepNumber == 2) {
          if (success) {
            ref
                .read(personalNewLoanRequestProvider.notifier)
                .updateState(PersonalLoanRequestProgress.bankAccountDetails);
            ref
                .read(routerProvider)
                .push(PersonalNewLoanRequestRouter.new_loan_process);
            return;
          } else {
            ref.read(routerProvider).push(
                PersonalNewLoanRequestRouter.new_loan_error,
                extra: "Error on the on_init_02");
            return;
          }
        }

        // repayment response
        if (stepNumber == 3) {
          if (success) {
            var response = await ref
                .read(personalNewLoanRequestProvider.notifier)
                .checkRepaymentSuccess(cancelToken);

            if (!response.success) {
              ref
                  .read(personalNewLoanRequestProvider.notifier)
                  .updateRepaymentSetupFailure(true);
              ref.read(routerProvider).push(
                  PersonalNewLoanRequestRouter.new_loan_error,
                  extra:
                      "Error when checking loan repayment success ${response.message}");
              return;
            }
            ref
                .read(personalNewLoanRequestProvider.notifier)
                .updateRepaymentSetupFailure(false);
            return;
          } else {
            ref
                .read(personalNewLoanRequestProvider.notifier)
                .updateRepaymentSetupFailure(true);
            ref.read(routerProvider).push(
                PersonalNewLoanRequestRouter.new_loan_error,
                extra: "Error on the checking loan repayment status check");
            return;
          }
        }

        // on_init_03 response
        if (stepNumber == 4) {
          if (success) {
            ref
                .read(personalNewLoanRequestProvider.notifier)
                .updateState(PersonalLoanRequestProgress.repaymentSetup);
            ref
                .read(routerProvider)
                .push(PersonalNewLoanRequestRouter.new_loan_process);
            return;
          } else {
            ref.read(routerProvider).push(
                PersonalNewLoanRequestRouter.new_loan_error,
                extra: "Error on the on_init_03");
            return;
          }
        }

        // loan agreement
        if (stepNumber == 5) {
          if (success) {
            var response = await ref
                .read(personalNewLoanRequestProvider.notifier)
                .checkLoanAgreementSuccess(cancelToken);

            if (!response.success) {
              ref
                  .read(personalNewLoanRequestProvider.notifier)
                  .updateLoanAgreementFailure(true);
              return;
            }
            ref
                .read(personalNewLoanRequestProvider.notifier)
                .updateLoanAgreementFailure(false);
            return;
          } else {
            ref
                .read(personalNewLoanRequestProvider.notifier)
                .updateLoanAgreementFailure(true);
            return;
          }
        }

        break;
      case "confirm":
        // on_confirm_01 response
        if (stepNumber == 1) {
          if (success) {
            ref
                .read(personalNewLoanRequestProvider.notifier)
                .updateState(PersonalLoanRequestProgress.loanAgreement);
            ref
                .read(routerProvider)
                .push(PersonalNewLoanRequestRouter.new_loan_process);
            return;
          } else {
            ref.read(routerProvider).push(
                PersonalNewLoanRequestRouter.new_loan_error,
                extra: "Error on the on_confirm_01");
            return;
          }
        }
        break;
      default:
        break;
    }

    state = PersonalLoanEventState(
        latestEvent: PersonalLoanEvent(
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
            priority: event.priority));

    await setEventConsumed(event.messageId);
    return;
  }

  Future<void> setEventConsumed(String messageId) async {
    final cancelToken = CancelToken();

    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    var transactionId = ref.read(personalNewLoanRequestProvider).transactionId;
    var providerId =
        ref.read(personalNewLoanRequestProvider).selectedOffer.offerProviderId;

    if (authToken.isEmpty || transactionId.isEmpty || providerId.isEmpty) {
      return;
    }

    try {
      var httpService = HttpService(service: ServiceType.PersonalLoan);

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
