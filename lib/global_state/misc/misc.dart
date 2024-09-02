import 'package:blocsol_loan_application/global_state/misc/misc_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'misc.g.dart';

@riverpod
class Misc extends _$Misc {
  @override
  MiscState build()  {
   

    ref.keepAlive();
    return MiscState.initialize();
  }

  void updateState (ActiveState newState) {
    state = state.copyWith(currentState: newState);
  }
}
