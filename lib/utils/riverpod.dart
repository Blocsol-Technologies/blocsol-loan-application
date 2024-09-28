import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension CacheForExtension on AutoDisposeRef<Object?> {
  void cacheFor(Duration duration, Function callback) {
    final link = keepAlive();

    Timer? cancelTimer;

    onCancel(() {
      cancelTimer = Timer(duration, () {
        link.close();
      });
    });


    onResume(() {
      cancelTimer?.cancel();
    });


    onDispose(() {
      callback();
    });
  }
}