// import 'package:blocsol_personal_credit/utils/errors.dart';
// import 'package:blocsol_personal_credit/utils/http_service.dart';
// import 'package:blocsol_personal_credit/utils/regex.dart';
// import 'package:blocsol_personal_credit/utils/schema.dart';
// import 'package:dio/dio.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'signup_state.freezed.dart';
// part 'signup_state.g.dart';

// @freezed
// class SignupStateData with _$SignupStateData {
//   const factory SignupStateData({
//     required String email,
//     required String imageURL,
//     required String phoneNumber,

//     // personal details
//     required String firstName,
//     required String lastName,
//     required String dob,
//     required String gender,
//     required String pan,
//     required String address,
//     required String city,
//     required String state,
//     required String pincode,
//     required String udyam,
//     required String companyName,
//     required bool udyamValidationRequired,
//     required bool udyamValidated,
//     required bool personalDetailsValidated,
//   }) = _SignupStateData;
// }

// @riverpod
// class SignupState extends _$SignupState {
//   @override
//   SignupStateData build() {
//     ref.keepAlive();
//     return const SignupStateData(
//       email: "",
//       imageURL: "",

//       // Phone Auth
//       phoneNumber: "",

//       // Personal details
//       firstName: "",
//       lastName: "",
//       dob: "",
//       gender: "",
//       pan: "",

//       // Address details
//       address: "",
//       city: "",
//       state: "",
//       pincode: "",
//       udyam: "",
//       companyName: "",

//       udyamValidationRequired: false,
//       udyamValidated: false,
//       personalDetailsValidated: false,
//     );
//   }

//   void updateEmailDetails(String email, String imageURL) {
//     state = state.copyWith(email: email, imageURL: imageURL);
//   }

//   void updatePhoneNumber(String phoneNumber) {
//     state = state.copyWith(phoneNumber: phoneNumber);
//   }

//   void setUdyamValidationRequired(bool value) {
//     state = state.copyWith(udyamValidationRequired: value);
//   }

//   void reset() {
//     state = const SignupStateData(
//       email: "",
//       imageURL: "",

//       // Phone Auth
//       phoneNumber: "",

//       // Personal details
//       firstName: "",
//       lastName: "",
//       dob: "",
//       gender: "",
//       pan: "",

//       // Address details
//       address: "",
//       city: "",
//       state: "",
//       pincode: "",
//       udyam: "",
//       companyName: "",

//       udyamValidationRequired: false,
//       udyamValidated: false,
//       personalDetailsValidated: false,
//     );
//   }

//   // Backend Functionality ================================================

//   // 2. Send Mobile OTP
//   Future<ServerResponse> sendMobileOTP(
//       String phoneNumber, String signature, CancelToken cancelToken) async {
//     try {
//       if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
//         return ServerResponse(
//             success: false, message: "Invalid Phone Number", data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService.get(
//           "/signup/mobile-validation/send-otp",
//           "",
//           cancelToken,
//           {"phoneNumber": phoneNumber, "signature": signature});

//       if (response.data['success']) {
//         state = state.copyWith(phoneNumber: phoneNumber);
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       }

//       return ServerResponse(
//           success: false, message: response.data['message'], data: null);
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/signup/mobile-validation/send-otp",
//           message: "Error occured when sending OTP",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occurred when sending OTP! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // 3. Verify Mobile OTP
//   Future<ServerResponse> verifyMobileOTP(
//       String phoneNumber, String otp, CancelToken cancelToken) async {
//     try {
//       if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
//         return ServerResponse(
//             success: false, message: "Invalid Phone Number", data: null);
//       }

//       if (!RegexProvider.otpRegex.hasMatch(otp)) {
//         return ServerResponse(
//             success: false, message: "Invalid OTP", data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .get("/signup/mobile-validation/verify-otp", "", cancelToken, {
//         "phoneNumber": phoneNumber,
//         "otp": otp,
//         "email": state.email,
//         "imageURL": state.imageURL
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       }

//       return ServerResponse(
//           success: false, message: response.data['message'], data: null);
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/signup/mobile-validation/verify-otp",
//           message: "Error occured when verifying OTP",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occurred when verifying OTP! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // 4. Send Personal Details
//   Future<ServerResponse> setPersonalDetails(String firstName, String lastName,
//       String dob, String gender, String pan, CancelToken cancelToken) async {
//     try {
//       if (state.udyamValidationRequired && !state.udyamValidated) {
//         return ServerResponse(
//             success: false, message: "Please validate Udyam", data: null);
//       }

//       if (!RegexProvider.panRegex.hasMatch(pan)) {
//         return ServerResponse(
//             success: false, message: "Invalid Pan", data: null);
//       }

//       if (firstName.isEmpty ||
//           lastName.isEmpty ||
//           dob.isEmpty ||
//           gender.isEmpty) {
//         return ServerResponse(
//             success: false,
//             message:
//                 "First Name, Last Name. DOB and Gender fields cannot be empty",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/signup/personal-details-authentication", "", cancelToken, {
//         "phoneNumber": "8360458365",
//         "firstName": firstName,
//         "lastName": lastName,
//         "dob": dob,
//         "gender": gender.toLowerCase(),
//         "pan": pan
//       });

//       if (response.data['success']) {
//         state = state.copyWith(
//           firstName: firstName,
//           lastName: lastName,
//           dob: dob,
//           gender: gender,
//           pan: pan,
//           personalDetailsValidated: true,
//         );

//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       }

//       return ServerResponse(
//           success: false, message: response.data['message'], data: null);
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/signup/personal-details-authentication",
//           message: "Error occured when verifying Personal Details",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occurred when verifying Personal Details! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // 4 b. Verify Udyam details
//   Future<ServerResponse> verifyUdyamNumber(
//       String udyam, CancelToken cancelToken) async {
//     try {
//       if (!RegexProvider.udyamRegex.hasMatch(udyam)) {
//         return ServerResponse(
//             success: false, message: "Invalid MSME Number", data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/signup/udyam-verification", "", cancelToken, {
//         "phoneNumber": state.phoneNumber,
//         "udyam": udyam,
//       });

//       if (response.data['success']) {
//         state = state.copyWith(
//           udyamValidated: true,
//           udyam: udyam,
//           companyName: response.data['companyName'] ?? "",
//         );

//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       }

//       return ServerResponse(
//           success: false, message: response.data['message'], data: null);
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/signup/udyam-verification",
//           message: "Error occured when verifying OTP",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occurred when verifying MSME number! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // 5. Add Address Details
//   Future<ServerResponse> addAddressDetails(String address, String city,
//       String stateVal, String pincode, CancelToken cancelToken) async {
//     try {
//       if (address.isEmpty ||
//           city.isEmpty ||
//           stateVal.isEmpty ||
//           pincode.isEmpty) {
//         return ServerResponse(
//             success: false,
//             message: "Please fill all the address fields",
//             data: null);
//       }
//       var httpService = HttpService();
//       var response = await httpService
//           .post("/signup/address-details-authentication", "", cancelToken, {
//         "phoneNumber": state.phoneNumber,
//         "firstLine": address,
//         "secondLine": address,
//         "city": city,
//         "state": stateVal,
//         "pincode": pincode,
//       });

//       if (response.data['success']) {
//         state = state.copyWith(
//           address: address,
//           city: city,
//           state: stateVal,
//           pincode: pincode,
//         );

//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       }

//       return ServerResponse(
//           success: false, message: response.data['message'], data: null);
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/signup/adress-details-authentication",
//           message: "Error occured when adding address details",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occurred when adding address details! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }

//   // 6. Set password
//   Future<ServerResponse> setPassword(
//       String password, CancelToken cancelToken) async {
//     try {
//       if (!RegexProvider.passwordRegex.hasMatch(password)) {
//         return ServerResponse(
//             success: false,
//             message:
//                 "Invalid password. It must have 8 characters, 1 uppercase, 1 lowercase, 1 number and 1 special character",
//             data: null);
//       }

//       var httpService = HttpService();
//       var response = await httpService
//           .post("/signup/final-registration", "", cancelToken, {
//         "phoneNumber": state.phoneNumber,
//         "password": password,
//       });

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true,
//             message: response.data['message'],
//             data: {"token": response.data['data']['token']});
//       }

//       return ServerResponse(
//           success: false, message: response.data['message'], data: null);
//     } catch (e, stackTrace) {
//       var err = ErrorInstance(
//           exception: e,
//           path: "/signup/final-registration",
//           message: "Error occured when adding password details",
//           trace: stackTrace);

//       await err.reportError();

//       var errString = e is DioException
//           ? e.response?.data['message']
//           : "Error occurred when adding password details! Contact Support...";

//       return ServerResponse(success: false, message: errString, data: null);
//     }
//   }
// }
