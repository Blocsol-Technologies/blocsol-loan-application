import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/state/loan_events_state.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/logger.dart';

import 'package:eventflux/eventflux.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';

part 'sse.g.dart';

@riverpod
class PersonalLoanServerSentEvents extends _$PersonalLoanServerSentEvents {
  @override
  void build() {
    ref.keepAlive();

    var (_, token) = ref.read(authProvider.notifier).getAuthTokens();

    logger.w("Starting SSE Connection");

    EventFlux.instance.connect(
      EventFluxConnectionType.get,
      '$personalLoanServerUrl/ondc/events',
      header: {"Authorization": token, "Keep-Alive": "true"},
      onSuccessCallback: (EventFluxResponse? response) {

        logger.w("SSE Connection established");

        response?.stream?.listen((data) async {
          var serverSentData = data.data;

          Map<String, dynamic> jsonData = json.decode(serverSentData);

          PersonalLoanEvent loanEvent = PersonalLoanEvent.fromJson(jsonData);

          ref.read(personalLoanEventsProvider.notifier).consumeEvent(loanEvent);
        });
      },
      onError: (e) {
        ErrorInstance(
          message: "Error occured in sse stream handler",
          exception: e.toString(),
          trace: StackTrace.current,
        ).reportError();
      },
      reconnectConfig: ReconnectConfig(mode: ReconnectMode.linear, interval: const Duration(seconds: 5), maxAttempts: 5),
      autoReconnect: true,
    );

    return;
  }
}
