import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/index_router.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class NotFoundPage extends ConsumerWidget {
  final bool invoiceLoanPage;
  const NotFoundPage({super.key, required this.invoiceLoanPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: RelativeSize.height(50, height),
            horizontal: RelativeSize.width(30, width),
          ),
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/animations/under_construction.json",
                height: RelativeSize.height(300, height),
                width: RelativeSize.width(300, width),
              ),
              Text(
                "Work in Progress",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(height: 30,),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  if (invoiceLoanPage) {
                    context.go(InvoiceLoanIndexRouter.dashboard);
                  } else {
                    context.go(PersonalLoanIndexRouter.dashboard);
                  }
                },
                child: Container(
                  height: 40,
                  width: RelativeSize.width(250, width),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Go Back",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b1,
                        fontWeight: AppFontWeights.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
