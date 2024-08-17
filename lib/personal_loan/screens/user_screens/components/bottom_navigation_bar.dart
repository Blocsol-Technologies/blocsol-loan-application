import 'package:blocsol_loan_application/personal_loan/contants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/nav/user/bottom_nav_bar/bottom_nav_bar_state.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BorrowerBottomNavigationBar extends ConsumerWidget {
  const BorrowerBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNavStateRef = ref.watch(personalLoanBottomNavStateProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: BottomNavigationBar(
        currentIndex: bottomNavStateRef.index,
        onTap: (index) {
          switch (index) {
            case 0:
              ref
                  .read(personalLoanBottomNavStateProvider.notifier)
                  .changeItem(BorrowerBottomNavItems.home);

              context.go(PersonalLoanIndexRouter.dashboard);
              break;
            case 1:
              ref
                  .read(personalLoanBottomNavStateProvider.notifier)
                  .changeItem(BorrowerBottomNavItems.loans);
              context.go(PersonalLoanIndexRouter.liabilities_screen);
            case 2:
              ref
                  .read(personalLoanBottomNavStateProvider.notifier)
                  .changeItem(BorrowerBottomNavItems.profile);
              context.go(PersonalLoanIndexRouter.support_home);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        selectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: AppFontSizes.b1,
          fontWeight: AppFontWeights.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: AppFontSizes.b1,
          fontWeight: AppFontWeights.bold,
        ),
        selectedItemColor: Theme.of(context).colorScheme.secondaryContainer,
        unselectedItemColor: Theme.of(context).colorScheme.onTertiary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: const SizedBox(
              height: 25,
              width: 40,
              child: ActiveNavigationItem(
                key: Key("msme_home_bottom_nav_item"),
                icon: Icon(
                  Icons.home,
                  size: 25,
                ),
                label: "Home",
              ),
            ),
            icon: SizedBox(
              height: 25,
              width: 40,
              child: Icon(
                Icons.home_filled,
                size: 25,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            activeIcon: const SizedBox(
              height: 25,
              width: 40,
              child: ActiveNavigationItem(
                key: Key("msme_loans_bottom_nav_item"),
                icon: Icon(
                  Icons.wallet_travel_sharp,
                  size: 25,
                ),
                label: "Loans",
              ),
            ),
            icon: SizedBox(
              height: 25,
              width: 40,
              child: Icon(
                Icons.wallet_travel_sharp,
                size: 25,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            label: "Loans",
          ),
          BottomNavigationBarItem(
            activeIcon: const SizedBox(
              height: 25,
              width: 40,
              child: ActiveNavigationItem(
                key: Key("msme_profile_bottom_nav_item"),
                icon: Icon(
                  Icons.support_agent,
                  size: 25,
                ),
                label: "Support",
              ),
            ),
            icon: SizedBox(
              height: 25,
              width: 40,
              child: Icon(
                Icons.supervised_user_circle_outlined,
                size: 25,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            label: "Support",
          ),
        ],
      ),
    );
  }
}

class ActiveNavigationItem extends StatelessWidget {
  final Widget icon;
  final String label;

  const ActiveNavigationItem(
      {super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [
            0,
            1,
          ],
          colors: bottomNavBarIconsGradientColors[0],
          tileMode: TileMode.repeated,
        ).createShader(bounds);
      },
      child: icon,
    );
  }
}
