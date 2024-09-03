import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_nav_state.g.dart';

enum BottomNavItems { home, loans, invoices }

@riverpod
class InvoiceLoanBottomNavState extends _$InvoiceLoanBottomNavState {
  @override
  BottomNavItems build() {
    ref.keepAlive();
    return BottomNavItems.home;
  }

  void changeItem(BottomNavItems item) {
    state = item;
  }

  void reset() {
    ref.invalidateSelf();
  }
}
