import 'dart:ui';

import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewLoanAlertDialog extends ConsumerWidget {
  final String text;
  final Function onConfirm;
  const NewLoanAlertDialog(
      {super.key, required this.text, required this.onConfirm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: const Color.fromRGBO(234, 234, 234, 1),
                    width: 1,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Alert! Choose your action",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.h3,
                        fontWeight: AppFontWeights.medium,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SpacerWidget(
                      height: 5,
                    ),
                    Text(
                      text,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b1,
                        fontWeight: AppFontWeights.normal,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.heavyImpact();
                        Navigator.of(context).pop(true);
                        await onConfirm();
                      },
                      child: Container(
                        height: 32,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            "YES",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        height: 32,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            "GO BACK",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                     const SpacerWidget(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        ref.read(routerProvider).pushReplacement(InvoiceNewLoanRequestRouter.loan_offer_select);
                      },
                      child: Container(
                        height: 32,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            "Select other offer",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
