// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/nav/bottom_nav_bar/bottom_nav_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class UserBottomNavBar extends ConsumerWidget {
//   const UserBottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bottomNavStateRef = ref.watch(bottomNavStateProvider);

//     return BottomNavigationBar(
//       currentIndex: bottomNavStateRef.index,
//       onTap: (index) {
//         switch (index) {
//           case 0:
//             ref
//                 .read(bottomNavStateProvider.notifier)
//                 .changeItem(BottomNavItems.home);

//             context.go(AppRoutes.msme_home_screen);
//             break;
//           case 1:
//             ref
//                 .read(bottomNavStateProvider.notifier)
//                 .changeItem(BottomNavItems.loans);
//             context.go(AppRoutes.msme_liabilities_home);
//           case 2:
//             ref
//                 .read(bottomNavStateProvider.notifier)
//                 .changeItem(BottomNavItems.support);
//             context.go(AppRoutes.msme_all_tickets);
//         }
//       },
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       selectedLabelStyle: TextStyle(
//         fontFamily: fontFamily,
//         fontSize: AppFontSizes.body2,
//         fontWeight: AppFontWeights.bold,
//       ),
//       // unselectedLabelStyle: TextStyle(
//         fontFamily: fontFamily,
//         fontSize: AppFontSizes.body2,
//         fontWeight: AppFontWeights.bold,
//       ),
//       iconSize: 70,
//       selectedItemColor: Theme.of(context).colorScheme.onSurface,
//       unselectedItemColor:
//           Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
//       items: <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           activeIcon: const SizedBox(
//             height: 30,
//             width: 40,
//             child: ActiveNavigationItem(
//               key: Key("msme_home_bottom_nav_item"),
//               icon: Icon(
//                 Icons.home_outlined,
//                 size: 30,
//               ),
//               label: "Home",
//             ),
//           ),
//           icon: SizedBox(
//             height: 30,
//             width: 40,
//             child: Icon(
//               Icons.home,
//               size: 30,
//               color:
//                   Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//             ),
//           ),
//           label: "Home",
//         ),
//         BottomNavigationBarItem(
//           activeIcon: const SizedBox(
//             height: 30,
//             width: 40,
//             child: ActiveNavigationItem(
//               key: Key("msme_loans_bottom_nav_item"),
//               icon: Icon(
//                 Icons.wallet_travel_sharp,
//                 size: 30,
//               ),
//               label: "Loans",
//             ),
//           ),
//           icon: SizedBox(
//             height: 30,
//             width: 40,
//             child: Icon(
//               Icons.wallet_travel_sharp,
//               size: 30,
//               color:
//                   Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//             ),
//           ),
//           label: "Loans",
//         ),
//         BottomNavigationBarItem(
//           activeIcon: const SizedBox(
//             height: 30,
//             width: 40,
//             child: ActiveNavigationItem(
//               key: Key("msme_support_bottom_nav_item"),
//               icon: Icon(
//                 Icons.support_agent_rounded,
//                 size: 30,
//               ),
//               label: "Support",
//             ),
//           ),
//           icon: SizedBox(
//             height: 30,
//             width: 40,
//             child: Icon(
//               Icons.support_agent_rounded,
//               size: 30,
//               color:
//                   Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//             ),
//           ),
//           label: "Support",
//         ),
//       ],
//     );
//   }
// }

// class ActiveNavigationItem extends StatelessWidget {
//   final Widget icon;
//   final String label;

//   const ActiveNavigationItem(
//       {super.key, required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       blendMode: BlendMode.srcATop,
//       shaderCallback: (Rect bounds) {
//         return LinearGradient(
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//           stops: const [
//             0,
//             1,
//           ],
//           colors: bottomNavBarIconsGradientColors[0],
//           tileMode: TileMode.repeated,
//         ).createShader(bounds);
//       },
//       child: icon,
//     );
//   }
// }
