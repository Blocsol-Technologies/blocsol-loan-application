import 'dart:async';

import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/all/all_liabilities_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/all/http_controller.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_liabilities.g.dart';

@riverpod
class InvoiceLoanLiabilities extends _$InvoiceLoanLiabilities {
  @override
  AllLiabilitiesState build() {
    ref.keepAlive();

    // var timer = Timer.periodic(const Duration(seconds: 10), (_) async {
    //   await fetchAllLiabilities(CancelToken());
    //   await fetchAllClosedLiabilities(CancelToken());
    // });

    // ref.onDispose(() {
    //   timer.cancel();
    // });

    return AllLiabilitiesState.initial;
  }

  Future<ServerResponse> fetchAllLiabilities(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    if (state.liabilities.isEmpty) {
      state = state.copyWith(fetchingLiabilitiess: true);
    }

    var response = await InvoiceLoanAllLiabilitiesHttpController()
        .fetchLiabilities(authToken, cancelToken);

    state = state.copyWith(
        fetchingLiabilitiess: false,
        liabilitiessFetchTime: DateTime.now().millisecondsSinceEpoch ~/ 1000);

    if (response.success) {
      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
              state.liabilitiessFetchTime >
          900) {
        state = state.copyWith(
            liabilities: response.data,
            liabilitiessFetchTime:
                DateTime.now().millisecondsSinceEpoch ~/ 1000);
      } else {
        state = state.copyWith(
          liabilities: response.data,
        );
      }
    }

    return response;
  }

  Future<ServerResponse> fetchAllClosedLiabilities(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    if (state.liabilities.isEmpty) {
      state = state.copyWith(fetchingClosedLiabilities: true);
    }

    var response = await InvoiceLoanAllLiabilitiesHttpController()
        .fetchAllClosedLiabilities(authToken, cancelToken);

    state = state.copyWith(
        fetchingClosedLiabilities: false,
        closedLiabilitiessFetchTime:
            DateTime.now().millisecondsSinceEpoch ~/ 1000);

    if (response.success) {
      if (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
              state.liabilitiessFetchTime >
          900) {
        state = state.copyWith(
            closedLiabilities: response.data,
            closedLiabilitiessFetchTime:
                DateTime.now().millisecondsSinceEpoch ~/ 1000);
      } else {
        state = state.copyWith(
          closedLiabilities: response.data,
        );
      }
    }

    return response;
  }
}
