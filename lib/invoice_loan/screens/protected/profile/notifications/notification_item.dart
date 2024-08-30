import 'package:blocsol_loan_application/invoice_loan/state/user/profile/state/notification.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final IbcNotification notification;
  const NotificationItem({super.key, required this.notification});
  

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: RelativeSize.height(80, height),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getNotificationWidget(notification.type),
          const SpacerWidget(
            width: 18,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notification.title,
                softWrap: true,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: AppFontSizes.h3,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                height: 2,
                width: width,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              ),
              Text(
                notification.message,
                softWrap: true,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: AppFontSizes.b2,
                  fontWeight: AppFontWeights.normal,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          )),
          const SpacerWidget(
            width: 18,
          ),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: notification.seen
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
    );
  }
}

Widget getNotificationWidget(Notificationtype type) {
  switch (type) {
    case Notificationtype.info:
      return const Icon(
        Icons.info_rounded,
        color: Colors.blue,
        size: 22,
      );
    case Notificationtype.success:
      return const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
        size: 22,
      );

    case Notificationtype.error:
      return const Icon(
        Icons.error_rounded,
        color: Colors.red,
        size: 22,
      );
  }
}
