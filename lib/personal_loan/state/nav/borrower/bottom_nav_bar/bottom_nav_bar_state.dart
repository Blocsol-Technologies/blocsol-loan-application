import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_nav_bar_state.g.dart';

enum BorrowerBottomNavItems {
  home,
  loans,
  profile,
}

@riverpod
class BorrowerBottomNavState extends _$BorrowerBottomNavState {
  @override
  BorrowerBottomNavItems build() {
    return BorrowerBottomNavItems.home;
  }

  void changeItem(BorrowerBottomNavItems item) {
    state = item;
  }
}
