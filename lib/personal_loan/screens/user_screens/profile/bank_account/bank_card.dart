import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';

class PlBankDetailsCard extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String accountHolderName;
  final bool isPrimary;
  const PlBankDetailsCard(
      {super.key,
      required this.bankName,
      required this.accountNumber,
      required this.ifscCode,
      required this.isPrimary,
      required this.accountHolderName});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(200, 200, 200, 1),
          width: 1,
        ),
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: RelativeSize.width(18, width),
                right: RelativeSize.width(10, width),
                bottom: RelativeSize.height(10, height),
                top: RelativeSize.height(10, height)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: RelativeSize.height(50, height),
                  width: RelativeSize.width(60, width),
                  child: getLenderDetailsAssetURL(
                      bankName, "https://picsum.photos/150"),
                ),
                const SpacerWidget(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bankName,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.medium,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SpacerWidget(
                        height: 8,
                      ),
                      Text(
                        "A/C no.: $accountNumber",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          fontWeight: AppFontWeights.medium,
                          color: const Color.fromRGBO(130, 130, 130, 1),
                        ),
                      ),
                      const SpacerWidget(
                        height: 8,
                      ),
                      Text(
                        "IFSC: $ifscCode",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          fontWeight: AppFontWeights.medium,
                          color: const Color.fromRGBO(130, 130, 130, 1),
                        ),
                      ),
                      const SpacerWidget(
                        height: 8,
                      ),
                      Text(
                        "A/C Holder Name.: $accountHolderName",
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          fontWeight: AppFontWeights.medium,
                          color: const Color.fromRGBO(130, 130, 130, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  width: 3,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              top: 5,
              right: 8,
              child: isPrimary
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(207, 255, 184, 1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      child: Center(
                        child: Text(
                          "Primary",
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b3,
                              fontWeight: AppFontWeights.bold,
                              color: Colors.green.shade900),
                        ),
                      ),
                    )
                  : const SizedBox())
        ],
      ),
    );
  }
}
