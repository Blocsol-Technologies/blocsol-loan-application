import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_check.g.dart';

@riverpod
class InternetCheck extends _$InternetCheck {
  @override
  bool build() {
    ref.keepAlive();

    final subscription = InternetConnection().onStatusChange.listen(
      (InternetStatus status) {
        if (status == InternetStatus.connected) {
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
