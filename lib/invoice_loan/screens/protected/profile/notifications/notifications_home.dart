import 'dart:io';

import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/notifications/notification_item.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanNotifications extends ConsumerStatefulWidget {
  const InvoiceLoanNotifications({super.key});

  @override
  ConsumerState<InvoiceLoanNotifications> createState() =>
      _InvoiceLoanNotificationsState();
}

class _InvoiceLoanNotificationsState
    extends ConsumerState<InvoiceLoanNotifications> {
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
        .read(invoiceLoanUserProfileDetailsProvider.notifier)
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
    final userDetailsRef = ref.watch(invoiceLoanUserProfileDetailsProvider);

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
              const InvoiceLoanProfileTopNav(),
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
                      "You have ${ref.read(invoiceLoanUserProfileDetailsProvider.notifier).getNumUnseenNotifications()} unseen notifications",
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
                        return NotificationItem(
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
