import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/state/loan_events_state.dart';
import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';

import 'package:eventflux/eventflux.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';

part 'sse.g.dart';

@riverpod
class ServerSentEvents extends _$ServerSentEvents {
  @override
  void build() {
    ref.keepAlive();

    var (_, token) = ref.read(authProvider.notifier).getAuthTokens();

    EventFlux.instance.connect(
      EventFluxConnectionType.get,
      '$serverUrl/ondc/events',
      header: {"Authorization": token, "Keep-Alive": "true"},
      onSuccessCallback: (EventFluxResponse? response) {
        response?.stream?.listen((data) async {
          var serverSentData = data.data;

          Map<String, dynamic> jsonData = json.decode(serverSentData);

          LoanEvent loanEvent = LoanEvent.fromJson(jsonData);

          ref.read(loanEventsProvider.notifier).consumeEvent(loanEvent);
        });
      },
      onError: (e) {
        ErrorInstance(
          message: "Error occured in sse stream handler",
          exception: e.toString(),
          trace: StackTrace.current,
        ).reportError();
      },
      autoReconnect: true,
    );
    return;
  }
}
