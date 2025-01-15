import 'dart:io';

import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/notifications/notification_item.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class PlNotifications extends ConsumerStatefulWidget {
  const PlNotifications({super.key});

  @override
  ConsumerState<PlNotifications> createState() =>
      _PlNotificationsState();
}

class _PlNotificationsState
    extends ConsumerState<PlNotifications> {
  final _cancelToken = CancelToken();

  Future<void> _setNotificationsRead() async {
    var deviceId = "";

    final deviceInfoPlugin = DeviceInfoPlugin();

    bool isAndroid = Platform.isAndroid;
    bool isIos = Platform.isIOS;

    if (isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      if (!mounted || !context.mounted) return;
      deviceId = androidInfo.toString();
    } else if (isIos) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      if (!mounted || !context.mounted) return;
      deviceId = iosInfo.toString();
    } else {
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      if (!mounted || !context.mounted) return;
      deviceId = deviceInfo.data.toString();
    }

    await ref
        .read(personalLoanAccountDetailsProvider.notifier)
        .markNotificationsRead(deviceId, _cancelToken);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setNotificationsRead();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userDetailsRef = ref.watch(personalLoanAccountDetailsProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: RelativeSize.height(25, height),
            horizontal: RelativeSize.width(25, width),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PlProfileTopNav(),
              const SpacerWidget(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _setNotificationsRead();
                      },
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                            fontSize: AppFontSizes.heading,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    Text(
                      "You have ${ref.read(personalLoanAccountDetailsProvider.notifier).getNumUnseenNotifications()} unseen notifications",
                      style: TextStyle(
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.medium,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              const SpacerWidget(
                height: 30,
              ),
              userDetailsRef.notifications.isEmpty
                  ? SizedBox(
                      width: width,
                      child: Column(
                        children: [
                          Lottie.asset(
                            "assets/animations/404.json",
                            width: RelativeSize.width(250, width),
                          ),
                          Text(
                            "No notifications",
                            style: TextStyle(
                                fontSize: AppFontSizes.b1,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, idx) {
                        return PlNotificationItem(
                            notification: userDetailsRef.notifications[idx]);
                      },
                      itemCount: userDetailsRef.notifications.length,
                      physics: const NeverScrollableScrollPhysics(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
