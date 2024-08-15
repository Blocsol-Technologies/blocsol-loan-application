import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/support/utils.dart';
import 'package:blocsol_loan_application/invoice_loan/state/support/support.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
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

class _InvoiceLoanRaiseNewTicketState extends ConsumerState<InvoiceLoanRaiseNewTicket> {
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
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: "Unable to select images",
            contentType: ContentType.failure,
          ),
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

    if (response.success) {
      _mediaFileList.clear();
      _messageController.clear();
      categorySelectedName = categories[0].name;
      subCategorySelectedName = categories[0].subCategories[0].name;

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: "Support Ticket Raised. View in 'My Tickets'",
          contentType: ContentType.success,
        ),
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
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: response.message,
          contentType: ContentType.failure,
        ),
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
    final supportRef = ref.watch(invoiceLoanSupportProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              ref.read(routerProvider).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Raise a Ticket',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: AppFontWeights.medium,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: AppFontSizes.h1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Please provide the details of your issue below. Our support team will get back to you as soon as possible.',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Category',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton2<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.category,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                        hint: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Category",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        items: categories
                            .map((Category item) => DropdownMenuItem<String>(
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

                            subCategorySelectedName = subCategories[0].name;
                          });
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
                      const SizedBox(height: 20),
                      Text(
                        'Sub-Category',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 20),
                      Text(
                        'Images (optional)',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                              width: 200,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.add_a_photo,
                                color: Theme.of(context).colorScheme.primary,
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
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.h3,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: _mediaFileList.isEmpty ? 20 : 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          key: UniqueKey(),
                          itemBuilder: (BuildContext context, int index) {
                            return Semantics(
                                label: 'image_picker_example_picked_image',
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Image.file(
                                    File(_mediaFileList[index].path),
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
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
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          _raiseSupportTicket();
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 1,
                            ),
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                          ),
                        ),
                      )
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
      underline: const SizedBox(),
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
