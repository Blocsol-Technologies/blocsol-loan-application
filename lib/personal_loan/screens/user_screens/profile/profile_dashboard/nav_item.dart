import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNavItem extends ConsumerWidget {
  final String text;
  final String route;
  const ProfileNavItem({super.key, required this.text, required this.route});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: RelativeSize.height(70, height),
      padding: EdgeInsets.only(bottom: RelativeSize.height(15, height)),
      margin: EdgeInsets.only(bottom: RelativeSize.height(15, height)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              ref.read(routerProvider).push(route);
            },
            child: Container(
              height: RelativeSize.height(50, height),
              width: width,
              padding: const EdgeInsets.only(
                  top: 17, bottom: 17, left: 17, right: 9),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(228, 247, 255, 1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 17,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
