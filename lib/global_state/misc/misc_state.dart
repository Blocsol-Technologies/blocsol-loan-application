import 'package:freezed_annotation/freezed_annotation.dart';

part 'misc_state.freezed.dart';

enum ActiveState {
  none,
  invoiceLoan, 
  personalLoan
}

@freezed
class MiscState with _$MiscState {
  const factory MiscState({
    required ActiveState currentState
  }) = _MiscState;

  factory MiscState.initialize() => const MiscState(
        currentState: ActiveState.none,
      );
}
