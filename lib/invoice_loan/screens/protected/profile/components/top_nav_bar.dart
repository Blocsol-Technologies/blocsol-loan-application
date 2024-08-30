import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanProfileTopNav extends ConsumerWidget {
  const InvoiceLoanProfileTopNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetailsRef = ref.watch(invoiceLoanUserProfileDetailsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            try {
              ref.read(routerProvider).pop();
            } catch (e) {
              context.go(InvoiceLoanIndexRouter.dashboard);
            }
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
            size: 22,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ref.read(invoiceLoanUserProfileDetailsProvider.notifier).setNotificationSeen(true);
                  context.go(InvoiceLoanIndexRouter.notifications);
                },
                child: Icon(
                  Icons.notifications_active,
                  color: userDetailsRef.notificationSeen ? Theme.of(context).colorScheme.onSurface : Colors.amber.shade300,
                  size: 22,
                ),
              ),
              const SpacerWidget(
                width: 25,
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  context.go(InvoiceLoanIndexRouter.support);
                },
                child: Icon(
                  Icons.support_agent_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
