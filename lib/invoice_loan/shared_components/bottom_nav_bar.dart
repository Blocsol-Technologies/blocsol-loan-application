import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/ui/nav/bottom_nav_bar/bottom_nav_state.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanBottomNavBar extends ConsumerWidget {
  const InvoiceLoanBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNavStateRef = ref.watch(bottomNavStateProvider);

    return BottomNavigationBar(
      currentIndex: bottomNavStateRef.index,
      onTap: (index) {
        switch (index) {
          case 0:
            ref
                .read(bottomNavStateProvider.notifier)
                .changeItem(BottomNavItems.home);

            context.go(InvoiceLoanIndexRouter.dashboard);
            break;
          case 1:
            ref
                .read(bottomNavStateProvider.notifier)
                .changeItem(BottomNavItems.loans);
            context.go(InvoiceLoanIndexRouter.liabilities);
             case 2:
            ref
                .read(bottomNavStateProvider.notifier)
                .changeItem(BottomNavItems.invoices);
            context.go(InvoiceLoanIndexRouter.invoices);
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      selectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: AppFontSizes.b2,
          fontWeight: AppFontWeights.bold,
          color: Theme.of(context).colorScheme.secondary),
      unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: AppFontSizes.b2,
          fontWeight: AppFontWeights.normal,
          color: const Color.fromRGBO(78, 78, 78, 1)),
      iconSize: 70,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor:
          Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: 25,
            width: 25,
            child: Image.asset(
              "assets/images/invoice_loan/bottom_nav_bar/home_active.png",
              fit: BoxFit.cover,
            ),
          ),
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: 25,
            width: 25,
            child: Image.asset(
              "assets/images/invoice_loan/bottom_nav_bar/home_inactive.png",
              fit: BoxFit.cover,
            ),
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          activeIcon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: 25,
            width: 25,
            child: Image.asset(
              "assets/images/invoice_loan/bottom_nav_bar/loans_active.png",
              fit: BoxFit.cover,
            ),
          ),
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: 25,
            width: 25,
            child: Image.asset(
              "assets/images/invoice_loan/bottom_nav_bar/loans_inactive.png",
              fit: BoxFit.cover,
            ),
          ),
          label: "Loans",
        ),
        // BottomNavigationBarItem(
        //   activeIcon: Container(
        //     margin: const EdgeInsets.only(bottom: 5),
        //     height: 25,
        //     width: 25,
        //     child: Image.asset(
        //       "assets/images/invoice_loan/bottom_nav_bar/invoices_active.png",
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   icon: Container(
        //     margin: const EdgeInsets.only(bottom: 5),
        //     height: 25,
        //     width: 25,
        //     child: Image.asset(
        //       "assets/images/invoice_loan/bottom_nav_bar/invoices_inactive.png",
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   label: "Invoices",
        // ),
      ],
    );
  }
}
