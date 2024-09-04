import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/auth/signup/utils.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class PCSignupPersonalDetails extends ConsumerStatefulWidget {
  const PCSignupPersonalDetails({super.key});

  @override
  ConsumerState<PCSignupPersonalDetails> createState() =>
      _PCSignupPersonalDetailsState();
}

class _PCSignupPersonalDetailsState
    extends ConsumerState<PCSignupPersonalDetails> {
  final _cancelToken = CancelToken();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _panController = TextEditingController();
  final _panFocudNode = FocusNode();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinController = TextEditingController();
  final _udyamController = TextEditingController();
  final _udyanFocusNode = FocusNode();

  bool _creatingAccount = false;
  bool _verifyingUdyam = false;

  String _selectedGender = "";
  String _selectedState = "";

  void _pickDate() async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      // initialDate: DateTime(2020),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.surface,
    );

    String formattedDate = DateFormat('dd-MM-yyyy').format(datePicked!);

    _dobController.text = formattedDate;

    setState(() {});
  }

  Future<void> _verifyUdyamDetails() async {
    if (_verifyingUdyam ||
        ref.read(personalLoanSignupProvider).udyamValidated) {
      return;
    }

    setState(() {
      _verifyingUdyam = true;
    });

    var response = await ref
        .read(personalLoanSignupProvider.notifier)
        .verifyUdyamNumber(_udyamController.text, _cancelToken);

    if (!mounted) return;

    setState(() {
      _verifyingUdyam = false;
    });

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(message: response.message, notifType: SnackbarNotificationType.error), 
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    return;
  }

  Future<void> _verifyPersonalDetails() async {
    if (_creatingAccount) return;

    setState(() {
      _creatingAccount = true;
    });

    if (ref.read(personalLoanSignupProvider).udyamValidationRequired &&
        !ref.read(personalLoanSignupProvider).udyamValidated) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(message: "please verify msme number first", notifType: SnackbarNotificationType.warning), 
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      setState(() {
        _creatingAccount = false;
      });

      return;
    }

    if (!ref.read(personalLoanSignupProvider).personalDetailsValidated) {
      // Step 1: Save Personal Details
      var response = await ref
          .read(personalLoanSignupProvider.notifier)
          .setPersonalDetails(
              _firstNameController.text.trim(),
              _lastNameController.text.trim(),
              _dobController.text,
              _selectedGender,
              _panController.text,
              _cancelToken);

      if (!response.success) {
        if (mounted) {
          setState(() {
            _creatingAccount = false;
          });
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: getSnackbarNotificationWidget(message: response.message, notifType: SnackbarNotificationType.error), 
            duration: const Duration(seconds: 5),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          return;
        }
      }
    }

    // Step 2: Save Address Detail
    var response = await ref
        .read(personalLoanSignupProvider.notifier)
        .addAddressDetails(_addressController.text, _cityController.text,
            _selectedState, _pinController.text, _cancelToken);

    setState(() {
      _creatingAccount = false;
    });

    if (!mounted) return;

    if (response.success) {
      ref.read(routerProvider).push(PersonalLoanSignupRouter.password);
      return;
    }

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: getSnackbarNotificationWidget(message: response.message, notifType: SnackbarNotificationType.error),  
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    return;
  }

  @override
  void initState() {
    setState(() {
      _selectedGender = SignupUtils.genderList[0];
      _selectedState = SignupUtils.states[0];
    });

    _panController.addListener(() {
      if (RegexProvider.panRegex.hasMatch(_panController.text)) {
        _panFocudNode.unfocus();
      }
    });

    _udyamController.addListener(() {
      if (RegexProvider.udyamRegex.hasMatch(_panController.text)) {
        _udyanFocusNode.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _panController.dispose();
    _panFocudNode.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pinController.dispose();
    _udyamController.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final signupStateRef = ref.watch(personalLoanSignupProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            RelativeSize.width(25, width),
            RelativeSize.height(30, height),
            RelativeSize.width(35, width),
            RelativeSize.height(30, height),
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 30,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        ref.read(routerProvider).pushReplacement(
                            PersonalLoanSignupRouter.mobile_auth);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.support_agent_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 30,
                      ),
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        const whatsappUrl = "https://wa.me/918360458365";

                        await launchUrl(Uri.parse(whatsappUrl));
                      },
                    ),
                  ],
                ),
              ),
              const SpacerWidget(height: 45),
              Text(
                "Personal Details",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h1,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(height: 5),
              Text(
                "These detais will be used by the lenders to generate loan offers. Please ensure that the details are accurate and up to date.",
                softWrap: true,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.normal,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(height: 30),
              // First Name
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                controller: _firstNameController,
                readOnly: signupStateRef.personalDetailsValidated,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: signupStateRef.personalDetailsValidated
                      ? signupStateRef.firstName
                      : 'First Name',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintStyle: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.normal,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                  fillColor:
                      Theme.of(context).colorScheme.scrim.withOpacity(0.1),
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
              const SpacerWidget(height: 20),
              // Last Name
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                controller: _lastNameController,
                readOnly: signupStateRef.personalDetailsValidated,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: signupStateRef.personalDetailsValidated
                      ? signupStateRef.lastName
                      : 'Last Name',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintStyle: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.normal,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                  fillColor:
                      Theme.of(context).colorScheme.scrim.withOpacity(0.1),
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
              const SpacerWidget(height: 20),
              // Pan
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                controller: _panController,
                focusNode: _panFocudNode,
                maxLength: 10,
                readOnly: signupStateRef.personalDetailsValidated,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: signupStateRef.personalDetailsValidated
                      ? signupStateRef.pan
                      : 'Pan',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintStyle: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.normal,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                  fillColor:
                      Theme.of(context).colorScheme.scrim.withOpacity(0.1),
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
              const SpacerWidget(height: 20),
              // DOB
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();

                  if (signupStateRef.personalDetailsValidated) return;

                  _pickDate();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 40,
                  width: width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _dobController.text.isEmpty
                            ? signupStateRef.personalDetailsValidated
                                ? signupStateRef.dob
                                : 'DOB'
                            : _dobController.text,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Icon(
                        Icons.calendar_month_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SpacerWidget(height: 20),
              // Gender
              DropdownButton2<String>(
                isExpanded: true,
                underline: const SizedBox(),
                iconStyleData: IconStyleData(
                  icon: Icon(
                    _selectedGender.isEmpty
                        ? Icons.man_2_sharp
                        : _selectedGender == "Male"
                            ? Icons.male
                            : _selectedGender == "Female"
                                ? Icons.female
                                : Icons.transgender_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                hint: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 40,
                  width: width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        signupStateRef.personalDetailsValidated
                            ? signupStateRef.gender
                            : _selectedGender.isEmpty
                                ? 'Gender'
                                : _selectedGender,
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
                items: SignupUtils.genderList
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: _selectedGender,
                onChanged: (String? value) {
                  if (signupStateRef.personalDetailsValidated) return;

                  setState(() {
                    _selectedGender = value ?? "";
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 40,
                  width: width,
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
                    thumbVisibility: WidgetStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, right: 10),
                ),
              ),
              const SpacerWidget(height: 20),
              // Address
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                controller: _addressController,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: 'Address',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintStyle: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.normal,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                  fillColor:
                      Theme.of(context).colorScheme.scrim.withOpacity(0.1),
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
              const SpacerWidget(height: 20),
              // City and State
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: width * 0.4,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      controller: _cityController,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b1,
                        fontWeight: AppFontWeights.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: 'City',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        hintStyle: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: Theme.of(context).colorScheme.scrim,
                        ),
                        fillColor: Theme.of(context)
                            .colorScheme
                            .scrim
                            .withOpacity(0.1),
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
                  SizedBox(
                      width: width * 0.4,
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 40,
                          width: width * 0.4,
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
                                signupStateRef.personalDetailsValidated
                                    ? signupStateRef.state
                                    : _selectedState.isEmpty
                                        ? 'State'
                                        : _selectedState,
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
                        items: SignupUtils.states
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
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
                        value: _selectedState,
                        onChanged: (String? value) {
                          if (signupStateRef.personalDetailsValidated) return;

                          setState(() {
                            _selectedState = value ?? "";
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          width: width * 0.4,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: width * 0.4,
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
                      )),
                ],
              ),
              const SpacerWidget(height: 20),
              // Pincode
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                controller: _pinController,
                maxLength: 8,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: "",
                  hintText: 'Pincode',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintStyle: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.normal,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                  fillColor:
                      Theme.of(context).colorScheme.scrim.withOpacity(0.1),
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
              const SpacerWidget(height: 20),
              // Udyam Details
              Text(
                "Do you have a Company? If yes, enter MSME No.",
                softWrap: true,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.normal,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(height: 5),
              Container(
                height: 40,
                width: width,
                padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      width: RelativeSize.width(220, width),
                      child: Center(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.start,
                          maxLength: 19,
                          focusNode: _udyanFocusNode,
                          controller: _udyamController,
                          readOnly: signupStateRef.udyamValidated,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onChanged: (value) {
                            ref
                                .read(personalLoanSignupProvider.notifier)
                                .setUdyamValidationRequired(value.isNotEmpty);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                            hintText: 'MSME Udyam No. (Optional)',
                            hintStyle: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                          ),
                        ),
                      ),
                    ),
                    signupStateRef.udyamValidated
                        ? Icon(
                            Icons.check_circle_outline_sharp,
                            color: Theme.of(context).colorScheme.primary,
                            size: 25,
                          )
                        : _verifyingUdyam
                            ? Lottie.asset(
                                'assets/animations/loading_spinner.json',
                                height: 50,
                                width: 50)
                            : TextButton(
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  _verifyUdyamDetails();
                                },
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
              const SpacerWidget(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      _verifyPersonalDetails();
                    },
                    child: Container(
                      width: RelativeSize.width(250, width),
                      height: RelativeSize.height(40, height),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: _creatingAccount
                            ? Lottie.asset(
                                'assets/animations/loading_spinner.json',
                                height: 50,
                                width: 50)
                            : Text(
                                "Continue",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
