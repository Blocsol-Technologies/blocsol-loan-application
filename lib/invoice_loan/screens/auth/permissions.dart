import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class InvoiceLoanAppPermissions extends ConsumerStatefulWidget {
  const InvoiceLoanAppPermissions({super.key});

  @override
  ConsumerState<InvoiceLoanAppPermissions> createState() =>
      _InvoiceLoanAppPermissionsState();
}

class _InvoiceLoanAppPermissionsState
    extends ConsumerState<InvoiceLoanAppPermissions> {
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.mediaLibrary,
      Permission.notification,
      Permission.sms
    ].request();

    var allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
      }
    });

    if (!allGranted && mounted) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Please allow all permissions to continue.",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    if (mounted) context.go(InvoiceLoanIndexRouter.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: RelativeSize.width(20, width),
              vertical: RelativeSize.height(40, height)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "GRANT ACCESS",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
              const SpacerWidget(
                height: 5,
              ),
              SizedBox(
                width: 250,
                child: Text(
                  "we need the following permissions to proceed",
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.h1,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
              ),
              const SpacerWidget(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(224, 234, 253, 1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            width: 65,
                            child: Image.asset(
                              'assets/images/invoice_loan/permissions/p1.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SpacerWidget(
                    width: 15,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "push notification permission",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "to notify you regarding the new loan offers and lenders on time",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(208, 242, 146, 1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            width: 65,
                            child: Image.asset(
                              'assets/images/invoice_loan/permissions/p2.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SpacerWidget(
                    width: 15,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "location permission",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "to show to offers and alerts exclusive to your location",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(253, 216, 255, 1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            width: 65,
                            child: Image.asset(
                              'assets/images/invoice_loan/permissions/p3.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SpacerWidget(
                    width: 15,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "media permission",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "to enable seamless KYC process and verification",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      _requestPermissions();
                    },
                    child: Container(
                      height: 40,
                      width: RelativeSize.width(252, width),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Allow Permissions",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: AppFontWeights.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
