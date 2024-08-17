import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_nav_bar_state.g.dart';

enum BorrowerBottomNavItems {
  home,
  loans,
  profile,
}

@riverpod
class PersonalLoanBottomNavState extends _$PersonalLoanBottomNavState {
  @override
  BorrowerBottomNavItems build() {
    ref.keepAlive();
    return BorrowerBottomNavItems.home;
  }

  void changeItem(BorrowerBottomNavItems item) {
    state = item;
  }
}
