import 'dart:io';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/inward_curve_painter.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/support/utils.dart';
import 'package:blocsol_loan_application/invoice_loan/state/support/support.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';

class InvoiceLoanRaiseNewTicket extends ConsumerStatefulWidget {
  const InvoiceLoanRaiseNewTicket({super.key});

  @override
  ConsumerState<InvoiceLoanRaiseNewTicket> createState() =>
      _InvoiceLoanRaiseNewTicketState();
}

class _InvoiceLoanRaiseNewTicketState
    extends ConsumerState<InvoiceLoanRaiseNewTicket> {
  final cancelToken = CancelToken();
  final ImagePicker _picker = ImagePicker();
  final _messageController = TextEditingController();

  List<XFile> _mediaFileList = <XFile>[];
  String categorySelectedName = categories[0].name;
  List<Subcategory> subCategories = categories[0].subCategories;
  String subCategorySelectedName = categories[0].subCategories[0].name;

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        final List<XFile> pickedFileList = await _picker.pickMultiImage();
        setState(() {
          _mediaFileList = pickedFileList;
        });
      } catch (e) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: getSnackbarNotificationWidget(
              message: "unable to select images",
              notifType: SnackbarNotificationType.error),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      }
    }
  }

  Future<void> _raiseSupportTicket() async {
    if (ref.read(invoiceLoanSupportProvider).generatingSupportTicket) return;

    List<String> imageBase64 = [];

    for (int i = 0; i < _mediaFileList.length; i++) {
      final File file = File(_mediaFileList[i].path);
      final List<int> imageBytes = file.readAsBytesSync();
      final String base64Image = base64Encode(imageBytes);
      imageBase64.add(base64Image);
    }

    var category = categories
        .firstWhere((Category element) => element.name == categorySelectedName);

    var subCategoryCode = categories
        .firstWhere((Category element) => element.name == categorySelectedName)
        .subCategories
        .firstWhere((element) => element.name == subCategorySelectedName)
        .value;

    final response =
        await ref.read(invoiceLoanSupportProvider.notifier).raiseSupportIssue(
              category.value,
              subCategoryCode,
              "OPEN",
              _messageController.text,
              imageBase64,
              cancelToken,
            );

    if (!mounted) return;

    logFirebaseEvent("invoice_loan_liabilities", {
      "step": "raising_support_ticket_request",
      "gst": ref.read(invoiceLoanUserProfileDetailsProvider).gstNumber,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (response.success) {
      _mediaFileList.clear();
      _messageController.clear();
      categorySelectedName = categories[0].name;
      subCategorySelectedName = categories[0].subCategories[0].name;

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Support Ticket Raised. View in 'My Tickets'",
            notifType: SnackbarNotificationType.success),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      ref.read(routerProvider).push(InvoiceLoanIndexRouter.support);
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.error),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final supportRef = ref.watch(invoiceLoanSupportProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          body: SingleChildScrollView(
            child: Container(
              width: width,
              padding: EdgeInsets.fromLTRB(
                  RelativeSize.width(35, width),
                  RelativeSize.height(20, height),
                  RelativeSize.width(35, width),
                  0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const InvoiceLoanProfileTopNav(),
                  const SpacerWidget(
                    height: 45,
                  ),
                  Text(
                    'New Request',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h1,
                      fontWeight: AppFontWeights.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SpacerWidget(
                    height: 5,
                  ),
                  Text(
                    'Please provide us the necessary details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.b1,
                      fontWeight: AppFontWeights.medium,
                      color: const Color.fromRGBO(80, 80, 80, 1),
                    ),
                  ),
                  const SpacerWidget(
                    height: 20,
                  ),
                  SizedBox(
                    height: RelativeSize.height(630, height),
                    width: width,
                    child: CustomPaint(
                      painter: InwardCurvePainter(
                          color: Theme.of(context).colorScheme.surface),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 50,
                            left: RelativeSize.width(30, width),
                            right: RelativeSize.width(30, width)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SpacerWidget(height: 10),
                            DropdownButton2<String>(
                              isExpanded: true,
                              underline: const SpacerWidget(),
                              iconStyleData: IconStyleData(
                                icon: Icon(
                                  Icons.category,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 20,
                                ),
                              ),
                              hint: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .scrim
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Category",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              items: categories
                                  .map((Category item) =>
                                      DropdownMenuItem<String>(
                                        value: item.name,
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: categorySelectedName,
                              onChanged: (String? value) {
                                setState(() {
                                  categorySelectedName = value ?? "";

                                  subCategories = categories
                                      .firstWhere((Category element) =>
                                          element.name == categorySelectedName)
                                      .subCategories;

                                  subCategorySelectedName =
                                      subCategories[0].name;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(5),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 10, right: 10),
                              ),
                            ),
                            const SpacerWidget(height: 20),
                            Text(
                              'Sub-Category',
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SpacerWidget(height: 10),
                            SubCategorySelector(
                              onSubCategorySelected: (String val) {
                                setState(() {
                                  subCategorySelectedName = val;
                                });
                              },
                              selectedSubCategory: subCategorySelectedName,
                              subCategories: categories
                                  .firstWhere((Category element) =>
                                      element.name == categorySelectedName)
                                  .subCategories,
                            ),
                            const SpacerWidget(height: 20),
                            Text(
                              'Images (optional)',
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SpacerWidget(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _onImageButtonPressed(
                                      ImageSource.gallery,
                                      context: context,
                                    );
                                  },
                                  child: Container(
                                    height: 35,
                                    width: RelativeSize.width(180, width),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                        child: Icon(
                                      Icons.add_a_photo,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 20,
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    setState(() {
                                      _mediaFileList.clear();
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Reset',
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.h3,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SpacerWidget(height: 10),
                            SizedBox(
                              height: _mediaFileList.isEmpty ? 20 : 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                key: UniqueKey(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Semantics(
                                      label:
                                          'image_picker_example_picked_image',
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Image.file(
                                          File(_mediaFileList[index].path),
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return const Center(
                                                child: Text(
                                                    'This image type is not supported'));
                                          },
                                        ),
                                      ));
                                },
                                itemCount: _mediaFileList.length,
                              ),
                            ),
                            Text(
                              'Message',
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SpacerWidget(height: 10),
                            TextField(
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              controller: _messageController,
                              maxLines: 5,
                            ),
                            const SpacerWidget(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    _raiseSupportTicket();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: RelativeSize.width(252, width),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: supportRef.generatingSupportTicket
                                          ? Lottie.asset(
                                              "assets/animations/loading_spinner.json",
                                              height: 50,
                                              width: 50,
                                            )
                                          : Text(
                                              'Raise Ticket',
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.h3,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
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
    );
  }
}

class SubCategorySelector extends StatefulWidget {
  final Function(String) onSubCategorySelected;
  final String selectedSubCategory;
  final List<Subcategory> subCategories;
  const SubCategorySelector({
    required this.onSubCategorySelected,
    required this.selectedSubCategory,
    required this.subCategories,
    super.key,
  });

  @override
  State<SubCategorySelector> createState() => _SubCategorySelectorState();
}

class _SubCategorySelectorState extends State<SubCategorySelector> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton2<String>(
      isExpanded: true,
      underline: const SpacerWidget(),
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.catching_pokemon,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 20,
        ),
      ),
      hint: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Sub Category",
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.b1,
                fontWeight: AppFontWeights.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      items: widget.subCategories
          .map((Subcategory item) => DropdownMenuItem<String>(
                value: item.name,
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      value: widget.selectedSubCategory,
      onChanged: (String? value) {
        widget.onSubCategorySelected(value ?? "");
      },
      buttonStyleData: ButtonStyleData(
        height: 40,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.primary,
        ),
        offset: const Offset(0, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(5),
          thumbVisibility: WidgetStateProperty.all<bool>(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.only(left: 10, right: 10),
      ),
    );
  }
}
