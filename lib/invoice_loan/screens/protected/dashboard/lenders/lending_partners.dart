import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AnimationDirection { LtR, RtL }

List<String> lenders = [
  // "assets/images/lender_logos/axis.png",
  // "assets/images/lender_logos/central-bank.png",
  "assets/images/lender_logos/kotak.png",
  "assets/images/lender_logos/dmi.png",
  "assets/images/lender_logos/kbank.png",
  "assets/images/lender_logos/ftcash.png",
  // "assets/images/lender_logos/hdfc.png",
  // "assets/images/lender_logos/icici.png",
  // "assets/images/lender_logos/idfc.jpeg",
  // "assets/images/lender_logos/indusind.png",
  // "assets/images/lender_logos/punjab-national.png",
  // "assets/images/lender_logos/sidbi.png",
  // "assets/images/lender_logos/uco.png",
  // "assets/images/lender_logos/union.png",
];

class LendersOnBoard extends StatefulWidget {
  const LendersOnBoard({super.key});

  @override
  State<LendersOnBoard> createState() => _LendersOnBoardState();
}

class _LendersOnBoardState extends State<LendersOnBoard>
    with SingleTickerProviderStateMixin {
  // late AnimationController _animationController;
  // late Animation<double> _animation;
  // final ScrollController _scrollController = ScrollController();

  // AnimationDirection _direction = AnimationDirection.RtL;
  // int _scrollPosition = 0;

  // void playAnimation() async {
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 1),
  //   );

  //   _animation = CurvedAnimation(
  //       parent:
  //           Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
  //             ..addListener(() {
  //               if (_scrollController.hasClients) {
  //                 if (_direction == AnimationDirection.LtR) {
  //                   _scrollController
  //                       .jumpTo(_scrollPosition - _animation.value * 100);
  //                 } else {
  //                   _scrollController
  //                       .jumpTo(_scrollPosition + _animation.value * 100);
  //                 }
  //               }
  //             })
  //             ..addStatusListener((status) {
  //               if (_direction == AnimationDirection.LtR) {
  //                 if (_scrollPosition == 0) {
  //                   setState(() {
  //                     _direction = AnimationDirection.RtL;
  //                   });

  //                   if (status == AnimationStatus.completed) {
  //                     _scrollPosition += 100;
  //                     _animationController.reset();
  //                     Future.delayed(const Duration(seconds: 1), () {
  //                       if (mounted) {
  //                         _animationController.forward();
  //                       }
  //                     });
  //                   }

  //                   return;
  //                 } else {
  //                   if (status == AnimationStatus.completed) {
  //                     _scrollPosition -= 100;
  //                     _animationController.reset();
  //                     Future.delayed(const Duration(seconds: 1), () {
  //                       if (mounted) {
  //                         _animationController.forward();
  //                       }
  //                     });
  //                   }

  //                   return;
  //                 }
  //               }

  //               if (_direction == AnimationDirection.RtL) {
  //                 if (_scrollPosition == 1000) {
  //                   setState(() {
  //                     _direction = AnimationDirection.LtR;
  //                   });

  //                   if (status == AnimationStatus.completed) {
  //                     _scrollPosition -= 100;
  //                     _animationController.reset();
  //                     Future.delayed(const Duration(seconds: 1), () {
  //                       if (mounted) {
  //                         _animationController.forward();
  //                       }
  //                     });
  //                   }

  //                   return;
  //                 } else {
  //                   if (status == AnimationStatus.completed) {
  //                     _scrollPosition += 100;
  //                     _animationController.reset();
  //                     Future.delayed(const Duration(seconds: 1), () {
  //                       if (mounted) {
  //                         _animationController.forward();
  //                       }
  //                     });
  //                   }

  //                   return;
  //                 }
  //               }
  //             }),
  //       curve: Curves.easeInOut);

  //   _animationController.forward();
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // playAnimation();
    });
    super.initState();
  }

  @override
  void dispose() {
    // _animationController.dispose();
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RelativeSize.width(15, width)),
      child: Container(
        width: width,
        padding: EdgeInsets.only(
          top: RelativeSize.height(25, height),
          bottom: RelativeSize.height(20, height),
          right: RelativeSize.width(20, width),
          left: RelativeSize.width(20, width),
        ),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(243, 251, 255, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Our Banking Partners",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.h3,
                    fontWeight: AppFontWeights.medium,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SpacerWidget(
              height: 20,
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                // controller: _scrollController,
                itemBuilder: (ctx, idx) {
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(right: RelativeSize.width(35, width)),
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Image.asset(
                        lenders[idx],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                itemCount: lenders.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
