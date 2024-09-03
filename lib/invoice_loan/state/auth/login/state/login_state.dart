import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class InvoiceLoanLoginState with _$InvoiceLoanLoginState {
  const factory InvoiceLoanLoginState({
    required String phoneNumber,
    required String deviceId,
  }) = _InvoiceLoanLoginState;

  factory InvoiceLoanLoginState.initialize() => const InvoiceLoanLoginState(
        phoneNumber: "",
        deviceId: "",
      );
}