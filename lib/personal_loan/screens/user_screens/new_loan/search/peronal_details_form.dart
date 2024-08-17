import 'package:blocsol_loan_application/personal_loan/contants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/search/utils.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PCNewLoanPersonalDetailsForm extends ConsumerStatefulWidget {
  const PCNewLoanPersonalDetailsForm({super.key});

  @override
  ConsumerState<PCNewLoanPersonalDetailsForm> createState() =>
      _PCNewLoanPersonalDetailsFormState();
}

class _PCNewLoanPersonalDetailsFormState
    extends ConsumerState<PCNewLoanPersonalDetailsForm> {
  final _cancelToken = CancelToken();
  final _incomeTextInputController = TextEditingController();
  String _selectedEmploymentVal = "";
  String _selectedEmploymentType = "";
  String _selectedEndUseVal = "";
  String _selectedEndUse = "";

  void _handleNotificationBellPress() {
    print("Notification Bell Pressed");
  }

  @override
  void initState() {
    _selectedEmploymentType = SearchUtils.employmentType[0].text;
    _selectedEmploymentVal = SearchUtils.employmentType[0].value;
    _selectedEndUseVal = SearchUtils.endUse[0].value;
    _selectedEndUse = SearchUtils.endUse[0].text;
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _incomeTextInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final borrowerAccountDetailsRef =
        ref.watch(personalLoanAccountDetailsProvider);
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: RelativeSize.height(250, height),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: RelativeSize.height(20, height)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                context.go(PersonalNewLoanRequestRouter.new_loan_process);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      _handleNotificationBellPress();
                                    },
                                    icon: Icon(
                                      Icons.notifications_active,
                                      size: 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                  const SpacerWidget(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.network(
                                          borrowerAccountDetailsRef
                                                  .imageURL.isEmpty
                                              ? "https://placehold.co/30x30/000000/FFFFFF.png"
                                              : borrowerAccountDetailsRef
                                                  .imageURL,
                                          fit: BoxFit.cover,
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
                      const SpacerWidget(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(50, width)),
                        child: SizedBox(
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Enter your Details",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h1,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                              const SpacerWidget(
                                height: 10,
                              ),
                              Text(
                                "These are required by the lenders to provide you offers",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  letterSpacing: 0.24,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.start,
                          maxLength: 10,
                          controller: _incomeTextInputController,
                          onChanged: (val) {
                            ref
                                .read(personalNewLoanRequestProvider.notifier)
                                .updateAnnualIncome(val);
                          },
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textDirection: TextDirection.ltr,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: 'Annual Income (in INR)',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            hintStyle: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                            fillColor: const Color.fromRGBO(236, 236, 236, 1),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: SizedBox(
                            width: width,
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 40,
                                width: width,
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
                                      _selectedEmploymentType,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              items: SearchUtils.employmentType
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.text,
                                        child: Text(
                                          item.text,
                                          style: TextStyle(
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: _selectedEmploymentType,
                              onChanged: (String? value) {
                                _selectedEmploymentVal = SearchUtils
                                    .employmentType
                                    .firstWhere(
                                        (element) => element.text == value)
                                    .value;

                                ref
                                    .read(personalNewLoanRequestProvider.notifier)
                                    .updateEmploymentType(
                                        _selectedEmploymentVal);

                                setState(() {
                                  _selectedEmploymentType = value ?? "";
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 40,
                                width: width,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromRGBO(236, 236, 236, 1),
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromRGBO(236, 236, 236, 1),
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
                            )),
                      ),
                      const SpacerWidget(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: SizedBox(
                            width: width,
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 40,
                                width: width,
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
                                      _selectedEndUse,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              items: SearchUtils.endUse
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.text,
                                        child: Text(
                                          item.text,
                                          style: TextStyle(
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: _selectedEndUse,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedEndUseVal = SearchUtils.endUse
                                      .firstWhere(
                                          (element) => element.text == value)
                                      .value;

                                  ref
                                      .read(personalNewLoanRequestProvider.notifier)
                                      .updateEndUse(_selectedEndUseVal);
                                  _selectedEndUse = value ?? "";
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 40,
                                width: width,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromRGBO(236, 236, 236, 1),
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromRGBO(236, 236, 236, 1),
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
                            )),
                      ),
                      const SpacerWidget(
                        height: 185,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <GestureDetector>[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();

                              if (_incomeTextInputController.text.isEmpty ||
                                  int.parse(_incomeTextInputController.text) <=
                                      10000) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Annual Income cannot be less than ₹ 10000",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.medium,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            RelativeSize.width(30, width),
                                        vertical:
                                            RelativeSize.height(10, height)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                );
                                return;
                              }

                              ref
                                  .read(personalNewLoanRequestProvider.notifier)
                                  .updateState(PersonalLoanRequestProgress.formGenerated);
                              context.go(PersonalNewLoanRequestRouter.new_loan_process);
                              return;
                            },
                            child: Container(
                              width: RelativeSize.width(252, width),
                              height: RelativeSize.height(40, height),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.medium),
                                ),
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
