import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/utils/functions.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleInvoiceDetailsScreen extends ConsumerWidget {
  final Invoice invoice;

  const SingleInvoiceDetailsScreen({super.key, required this.invoice});

  Future<void> _shareInvoice() async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ref.watch(invoiceLoanEventsProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            padding: EdgeInsets.only(top: RelativeSize.height(30, height)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize.width(20, width)),
                  child: GestureDetector(
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      ref.read(routerProvider).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: 25,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SpacerWidget(
                  height: 45,
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.only(
                      left: RelativeSize.width(40, width),
                      right: RelativeSize.width(40, width),
                      top: RelativeSize.height(20, height),
                      bottom: RelativeSize.height(45, height)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 320,
                        width: width,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 320,
                              width: width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 250,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.only(
                                        top: RelativeSize.height(60, height),
                                        bottom: RelativeSize.height(20, height),
                                        left: 5,
                                        right: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: "Rs. ",
                                            style: TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: AppFontSizes.h3,
                                              fontWeight: AppFontWeights.medium,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "${invoice.amount}",
                                                style: TextStyle(
                                                  fontFamily: fontFamily,
                                                  fontSize: AppFontSizes.h1,
                                                  fontWeight:
                                                      AppFontWeights.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SpacerWidget(
                                          height: 6,
                                        ),
                                        Text(
                                          "GST: ${invoice.companyGST}",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b2,
                                            fontWeight: AppFontWeights.normal,
                                            color: const Color.fromRGBO(
                                                110, 110, 110, 1),
                                          ),
                                        ),
                                        const SpacerWidget(
                                          height: 5,
                                        ),
                                        const Divider(
                                          height: 2,
                                          color:
                                              Color.fromRGBO(164, 164, 164, 1),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top:
                                                RelativeSize.height(20, height),
                                            right:
                                                RelativeSize.width(17, width),
                                            left: RelativeSize.width(17, width),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Unique Id",
                                                    style: TextStyle(
                                                      fontFamily: fontFamily,
                                                      fontSize: AppFontSizes.b1,
                                                      fontWeight:
                                                          AppFontWeights.medium,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      invoice.irn.isNotEmpty
                                                          ? invoice.irn
                                                          : invoice.inum,
                                                      softWrap: true,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        fontSize:
                                                            AppFontSizes.b1,
                                                        fontWeight:
                                                            AppFontWeights
                                                                .medium,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SpacerWidget(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Company Name",
                                                    style: TextStyle(
                                                      fontFamily: fontFamily,
                                                      fontSize: AppFontSizes.b1,
                                                      fontWeight:
                                                          AppFontWeights.medium,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      invoice.companyName,
                                                      softWrap: true,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        fontSize:
                                                            AppFontSizes.b1,
                                                        fontWeight:
                                                            AppFontWeights
                                                                .medium,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SpacerWidget(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Date",
                                                    style: TextStyle(
                                                      fontFamily: fontFamily,
                                                      fontSize: AppFontSizes.b1,
                                                      fontWeight:
                                                          AppFontWeights.medium,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      invoice.idt,
                                                      softWrap: true,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        fontSize:
                                                            AppFontSizes.b1,
                                                        fontWeight:
                                                            AppFontWeights
                                                                .medium,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SpacerWidget(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "State",
                                                    style: TextStyle(
                                                      fontFamily: fontFamily,
                                                      fontSize: AppFontSizes.b1,
                                                      fontWeight:
                                                          AppFontWeights.medium,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      getStateNameFromStateCode(
                                                          invoice.pos),
                                                      softWrap: true,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        fontSize:
                                                            AppFontSizes.b1,
                                                        fontWeight:
                                                            AppFontWeights
                                                                .medium,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    width: 100,
                                    height: 3,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -45,
                              left: 0,
                              right: 0,
                              child: SizedBox(
                                width: width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 220,
                                      child: Image.asset(
                                          "assets/images/invoice_loan/new_loan_request/invoice.png",
                                          fit: BoxFit.contain),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpacerWidget(
                        height: 30,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: invoice.invoiceItems.length,
                          itemBuilder: (ctx, idx) {
                            var invoiceitem = invoice.invoiceItems[idx];
                            return SizedBox(
                              width: width,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Details: Item no ${idx + 1}",
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.h3,
                                          fontWeight: AppFontWeights.medium,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SpacerWidget(
                                    height: 10,
                                  ),
                                  Container(
                                    width: width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            RelativeSize.width(25, width),
                                        vertical:
                                            RelativeSize.height(20, height)),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "TXVAL",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                            Text(
                                              "Rs. ${invoiceitem.itemDetails.txval}",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SpacerWidget(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "CAMT",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                            Text(
                                              "Rs. ${invoiceitem.itemDetails.camt}",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SpacerWidget(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "SAMT",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                            Text(
                                              "Rs. ${invoiceitem.itemDetails.samt}",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SpacerWidget(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "IAMT",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                            Text(
                                              "Rs. ${invoiceitem.itemDetails.iamt}",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SpacerWidget(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "CESS",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                            Text(
                                              "Rs. ${invoiceitem.itemDetails.csamt}",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b1,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                      const SpacerWidget(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              _shareInvoice();
                            },
                            child: Container(
                              height: 40,
                              width: RelativeSize.width(252, width),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Share Invoice",
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.h3,
                                      fontWeight: AppFontWeights.medium,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SpacerWidget(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.share_outlined,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
