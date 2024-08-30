import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_check.g.dart';

@riverpod
class InternetCheck extends _$InternetCheck {
  @override
  bool build() {
    ref.keepAlive();

    final subscription = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        if (status == InternetConnectionStatus.connected) {
          state = true;
        } else {
          state = false;
        }
      },
    );

    ref.onDispose(subscription.cancel);

    return false;
  }
}
