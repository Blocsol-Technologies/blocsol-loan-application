// import 'package:blocsol_personal_credit/state/auth/auth_state.dart';
// import 'package:blocsol_personal_credit/utils/errors.dart';
// import 'package:blocsol_personal_credit/utils/http_service.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:blocsol_personal_credit/utils/schema.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'support_state.freezed.dart';
// part 'support_state.g.dart';

// class Message {
//   final String agent;
//   final String message;
//   final String actionTaken;
//   final String name;
//   final String phone;
//   final String email;
//   final String updatedAt;
//   final List<String> images;

//   Message({
//     required this.message,
//     required this.agent,
//     required this.actionTaken,
//     required this.name,
//     required this.phone,
//     required this.email,
//     required this.updatedAt,
//     required this.images,
//   });

//   factory Message.fromJson(Map<String, dynamic> json) {
//     List<String> imageList = [];

//     if (json['images'] != null) {
//       try {
//         for (var image in json['images'] as List<dynamic>) {
//           imageList.add(image as String);
//         }
//       } catch (e) {
//         print("error in Message.fromJson: when getting images $e");
//       }
//     }

//     return Message(
//       agent: json['agent'],
//       message: json['message'],
//       actionTaken: json['action_taken'],
//       name: json['name'],
//       phone: json['phone'],
//       email: json['email'],
//       updatedAt: json['updated_at'],
//       images: imageList,
//     );
//   }

//   bool isCustomerMessage() {
//     return agent == 'CONSUMER' || agent == 'CUSTOMER' || agent == 'customer';
//   }

//   String getReadableTime() {
//     try {
//       DateTime dateTime = DateTime.parse(updatedAt);
//       return DateFormat('dd MM yy hh:mm a').format(dateTime);
//     } catch (e) {
//       return '';
//     }
//   }
// }

// class SupportTicket {
//   final String transactionId;
//   final String providerId;
//   final String pan;
//   final List<Message> conversations;
//   final String chatLink;
//   final String id;
//   final String category;
//   final String subCategory;
//   final String createdAt;
//   final String updatedAt;
//   final String status;

//   SupportTicket({
//     required this.transactionId,
//     required this.providerId,
//     required this.pan,
//     required this.conversations,
//     required this.chatLink,
//     required this.id,
//     required this.category,
//     required this.subCategory,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.status,
//   });

//   factory SupportTicket.fromJson(Map<String, dynamic> json) {
//     try {
//       List<Message> messages = [];

//       try {
//         for (var message in json['conversations'] as List) {
//           messages.add(Message.fromJson(message));
//         }
//       } catch (e) {
//         print("error in SupportTicket.fromJson: when getting conversations $e");
//       }

//       return SupportTicket(
//         transactionId: json['transaction_id'],
//         providerId: json['provider_id'],
//         pan: json['pan'],
//         conversations: messages,
//         chatLink: json['chat_link'],
//         id: json['id'],
//         category: json['category'],
//         subCategory: json['sub_category'],
//         createdAt: json['created_at'],
//         updatedAt: json['updated_at'],
//         status: json['status'],
//       );
//     } catch (e, stackTrace) {
//       print("Error in SupportTicket.fromJson: $e");
//       print("stackTrace: $stackTrace");

//       return SupportTicket(
//         transactionId: '',
//         providerId: '',
//         pan: '',
//         conversations: [],
//         chatLink: '',
//         id: '',
//         category: '',
//         subCategory: '',
//         createdAt: '',
//         updatedAt: '',
//         status: '',
//       );
//     }
//   }

//   void addMessage(Message message) {
//     conversations.add(message);
//   }

//   String getReadableTime(String timestampString) {
//     try {
//       DateTime dateTime = DateTime.parse(timestampString);

//       return DateFormat('dd MM yy hh:mm a').format(dateTime);
//     } catch (e) {
//       return '';
//     }
//   }

//   Color getStatusColor() {
//     switch (status) {
//       case 'OPEN' || 'OPENED':
//         return Colors.green;
//       case 'CLOSED':
//         return Colors.red;
//       case 'PENDING' || 'PROCESSING' || 'PROCESS':
//         return Colors.orange;
//       default:
//         return Colors.black;
//     }
//   }
// }

// @freezed
// class SupportStateData with _$SupportStateData {
//   const factory SupportStateData({
//     required String transactionId,
//     required String providerId,
//     required String issueId,
//     required String pan,
//     required bool generatingSupportTicket,
//     required bool fetchingAllSupportTickets,
//     required bool fetchingSingleSupportTicket,
//     required List<SupportTicket> supportTickets,
//     required SupportTicket selectedSupportTicket,
//     required bool sendingStatusRequest,
//   }) = _SupportStateData;
// }

// @riverpod
// class SupportState extends _$SupportState {
//   @override
//   SupportStateData build() {
//     ref.keepAlive();
//     return SupportStateData(
//       transactionId: '',
//       providerId: '',
//       issueId: '',
//       pan: '',
//       fetchingAllSupportTickets: false,
//       fetchingSingleSupportTicket: false,
//       generatingSupportTicket: false,
//       supportTickets: [
//         // SupportTicket(
//         //   transactionId: '3ddb94f3-7e0e-431a-baeb-06fa78794a06',
//         //   providerId: 'Kotak',
//         //   pan: '06BBOPK6960P1ZS',
//         //   conversations: [
//         //     // Message(
//         //     //     agent: 'CONSUMER',
//         //     //     message: 'I am not able to complete the KYC',
//         //     //     actionTaken: 'No action taken',
//         //     //     name: 'Rahul',
//         //     //     phone: '9876543210',
//         //     //     email: '',
//         //     //     updatedAt: '2024-04-28T03:13:20Z',
//         //     //     images: []),
//         //     // Message(
//         //     //     agent: 'SUPPORT',
//         //     //     message: 'Tell me what is the problem',
//         //     //     actionTaken: 'No action taken',
//         //     //     name: 'Avijeet',
//         //     //     phone: '8360458365',
//         //     //     email: '',
//         //     //     updatedAt: '2024-05-28T03:13:20Z',
//         //     //     images: []),
//         //     // Message(
//         //     //     agent: 'CONSUMER',
//         //     //     message: 'I am not able to complete the KYC',
//         //     //     actionTaken: 'No action taken',
//         //     //     name: 'Rahul',
//         //     //     phone: '9876543210',
//         //     //     email: '',
//         //     //     updatedAt: '2024-04-28T03:13:20Z',
//         //     //     images: []),
//         //     // Message(
//         //     //     agent: 'SUPPORT',
//         //     //     message: 'Tell me what is the problem',
//         //     //     actionTaken: 'No action taken',
//         //     //     name: 'Avijeet',
//         //     //     phone: '8360458365',
//         //     //     email: '',
//         //     //     updatedAt: '2024-05-28T03:13:20Z',
//         //     //     images: []),
//         //     // Message(
//         //     //     agent: 'CONSUMER',
//         //     //     message: 'I am not able to complete the KYC',
//         //     //     actionTaken: 'No action taken',
//         //     //     name: 'Rahul',
//         //     //     phone: '9876543210',
//         //     //     email: '',
//         //     //     updatedAt: '2024-04-28T03:13:20Z',
//         //     //     images: []),
//         //     // Message(
//         //     //     agent: 'SUPPORT',
//         //     //     message: 'Tell me what is the problem',
//         //     //     actionTaken: 'No action taken',
//         //     //     name: 'Avijeet',
//         //     //     phone: '8360458365',
//         //     //     email: '',
//         //     //     updatedAt: '2024-05-28T03:13:20Z',
//         //     //     images: []),
//         //     // Message(
//         //     //     agent: 'CONSUMER',
//         //     //     message: 'I am not able to complete the KYC',
//         //     //     actionTaken: 'No action taken',
//         //     //     name: 'Rahul',
//         //     //     phone: '9876543210',
//         //     //     email: '',
//         //     //     updatedAt: '2024-04-28T03:13:20Z',
//         //     //     images: []),
//         //     // Message(
//         //     //     agent: 'SUPPORT',
//         //     //     message: 'Tell me what is the problem',
//         //     //     actionTaken: 'No action taken',
//         //     //     name: 'Avijeet',
//         //     //     phone: '8360458365',
//         //     //     email: '',
//         //     //     updatedAt: '2024-05-28T03:13:20Z',
//         //     //     images: []),
//         //   ],
//         //   chatLink: '',
//         //   id: '3ddb94f3-7e0e-431a-baeb-06fa78794a06',
//         //   category: 'ORDER',
//         //   subCategory: 'Fees/Charges related issues',
//         //   createdAt: '2024-04-28T03:13:20Z',
//         //   updatedAt: '2024-04-30T03:13:20Z',
//         //   status: 'OPEN',
//         // )
//       ],
//       selectedSupportTicket: SupportTicket(
//         transactionId: '',
//         providerId: '',
//         pan: '',
//         conversations: [],
//         chatLink: '',
//         id: '',
//         category: '',
//         subCategory: '',
//         createdAt: '',
//         updatedAt: '',
//         status: '',
//       ),
//       sendingStatusRequest: false,
//     );
//   }

//   void reset() {
//     state = SupportStateData(
//       transactionId: '',
//       providerId: '',
//       issueId: '',
//       pan: '',
//       generatingSupportTicket: false,
//       fetchingAllSupportTickets: false,
//       fetchingSingleSupportTicket: false,
//       supportTickets: [],
//       selectedSupportTicket: SupportTicket(
//         transactionId: '',
//         providerId: '',
//         pan: '',
//         conversations: [],
//         chatLink: '',
//         id: '',
//         category: '',
//         subCategory: '',
//         createdAt: '',
//         updatedAt: '',
//         status: '',
//       ),
//       sendingStatusRequest: false,
//     );
//   }

//   void setSelectSupportTicket(SupportTicket supportTicket) {
//     state = state.copyWith(selectedSupportTicket: supportTicket);
//   }

//   void setIssueDetails(
//       String providerId, String transactionId, String issueId, String pan) {
//     state = state.copyWith(
//       providerId: providerId,
//       transactionId: transactionId,
//       issueId: issueId,
//       pan: pan,
//     );
//   }

//   void addMessageToSelectedSupportTicket(Message message) {
//     var selectedSupportTicket = state.selectedSupportTicket;
//     selectedSupportTicket.addMessage(message);
//     state = state.copyWith(selectedSupportTicket: selectedSupportTicket);
//   }

//   void setSupportContext(String transactionId, String providerId) {
//     state = state.copyWith(
//       transactionId: transactionId,
//       providerId: providerId,
//     );
//   }

//   Future<ServerResponse> fetchAllSupportTickets(CancelToken cancelToken) async {
//     try {
//       var (authToken, _) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       var httpService = HttpService();

//       state = state.copyWith(fetchingAllSupportTickets: true);

//       var response = await httpService
//           .get("/ondc/get-all-support-tickets", authToken, cancelToken, {});

//       state = state.copyWith(fetchingAllSupportTickets: false);

//       if (response.data['success']) {
//         List<SupportTicket> formatedSupportTickets = [];

//         try {
//           List<dynamic> supportTickets =
//               response.data['data']?['support_tickets'] ?? [];

//           formatedSupportTickets = supportTickets
//               .map((item) => SupportTicket.fromJson(item))
//               .toList();
//         } catch (err, stackTrace) {
//           var errorInstance = ErrorInstance(
//             path:
//                 "lib/state/auth/user_data/msme/support/msme_support_state.dart",
//             message: "_",
//             exception: err,
//             trace: stackTrace,
//           );

//           errorInstance.reportError();
//           formatedSupportTickets = [];
//         }

//         state = state.copyWith(supportTickets: formatedSupportTickets);

//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(fetchingAllSupportTickets: false);
//       var errorInstance = ErrorInstance(
//         path: "lib/state/auth/user_data/msme/support/msme_support_state.dart",
//         message: "_",
//         exception: e,
//         trace: stackTrace,
//       );

//       errorInstance.reportError();

//       const defaultErrorString =
//           "Error occured when fetching support tickets! Contact Support...";

//       if (e is DioException) {
//         return ServerResponse(
//             success: false,
//             message: e.response?.data['message'] ?? defaultErrorString,
//             data: null);
//       }

//       return ServerResponse(
//           success: false, message: defaultErrorString, data: null);
//     }
//   }

//   Future<ServerResponse> fetchSingleSupportTicket(
//       CancelToken cancelToken) async {
//     try {
//       var (authToken, _) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       var httpService = HttpService();

//       state = state.copyWith(fetchingSingleSupportTicket: true);

//       var response = await httpService.post(
//           "/ondc/get-single-support-ticket-details", authToken, cancelToken, {
//         'transaction_id': state.transactionId,
//         'provider_id': state.providerId,
//         'issue_id': state.issueId,
//       });

//       if (response.data['success']) {
//         // var _ = await httpService
//         //     .post("/ondc/raise-issue-status-request", authToken, cancelToken, {
//         //   'transaction_id': state.transactionId,
//         //   'provider_id': state.providerId,
//         //   'issue_id': state.issueId,
//         // });

//         state = state.copyWith(fetchingSingleSupportTicket: false);
//         try {
//           var supportTicket =
//               SupportTicket.fromJson(response.data['data']['support_ticket']);
//           state = state.copyWith(selectedSupportTicket: supportTicket);
//           return ServerResponse(
//               success: true, message: response.data['message'], data: null);
//         } catch (err, stackTrace) {
//           var errorInstance = ErrorInstance(
//             path:
//                 "lib/state/auth/user_data/msme/support/msme_support_state.dart",
//             message: "_",
//             exception: err,
//             trace: stackTrace,
//           );

//           errorInstance.reportError();
//           return ServerResponse(
//               success: false, message: response.data['message'], data: null);
//         }
//       } else {
//         state = state.copyWith(fetchingSingleSupportTicket: false);
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(fetchingSingleSupportTicket: false);
//       var errorInstance = ErrorInstance(
//         path: "lib/state/auth/user_data/msme/support/msme_support_state.dart",
//         message: "_",
//         exception: e,
//         trace: stackTrace,
//       );

//       errorInstance.reportError();

//       const defaultErrorString =
//           "Error occured when fetching support tickets! Contact Support...";

//       if (e is DioException) {
//         return ServerResponse(
//             success: false,
//             message: e.response?.data['message'] ?? defaultErrorString,
//             data: null);
//       }

//       return ServerResponse(
//           success: false, message: defaultErrorString, data: null);
//     }
//   }

//   Future<ServerResponse> raiseSupportIssue(
//       String category,
//       String subCategory,
//       String status,
//       String message,
//       List<String> images,
//       CancelToken cancelToken) async {
//     try {
//       var (authToken, _) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       var httpService = HttpService();

//       state = state.copyWith(generatingSupportTicket: true);

//       var response = await httpService
//           .post("/ondc/generate-support-ticket", authToken, cancelToken, {
//         'transaction_id': state.transactionId,
//         'provider_id': state.providerId,
//         'category': category,
//         'sub_category': subCategory,
//         'status': status,
//         'message': message,
//         'images': images,
//       });

//       state = state.copyWith(generatingSupportTicket: false);

//       if (response.data['success']) {
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(generatingSupportTicket: false);
//       var errorInstance = ErrorInstance(
//         path: "lib/state/auth/user_data/msme/support/msme_support_state.dart",
//         message: "_",
//         exception: e,
//         trace: stackTrace,
//       );

//       errorInstance.reportError();

//       const defaultErrorString =
//           "Error occured when fetching support tickets! Contact Support...";

//       if (e is DioException) {
//         return ServerResponse(
//             success: false,
//             message: e.response?.data['message'] ?? defaultErrorString,
//             data: null);
//       }

//       return ServerResponse(
//           success: false, message: defaultErrorString, data: null);
//     }
//   }

//   Future<ServerResponse> sendStatusRequest(CancelToken cancelToken) async {
//     try {
//       var (authToken, _) =
//           await ref.read(authStateProvider.notifier).getAuthToken();

//       var httpService = HttpService();

//       state = state.copyWith(sendingStatusRequest: true);

//       var response = await httpService
//           .post("/ondc/raise-issue-status-request", authToken, cancelToken, {
//         'transaction_id': state.transactionId,
//         'provider_id': state.providerId,
//         'issue_id': state.issueId,
//       });

//       if (response.data['success']) {
//         state = state.copyWith(sendingStatusRequest: false);
//         return ServerResponse(
//             success: true, message: response.data['message'], data: null);
//       } else {
//         state = state.copyWith(sendingStatusRequest: false);
//         return ServerResponse(
//             success: false, message: response.data['message'], data: null);
//       }
//     } catch (e, stackTrace) {
//       state = state.copyWith(sendingStatusRequest: false);
//       var errorInstance = ErrorInstance(
//         path: "lib/state/auth/user_data/msme/support/msme_support_state.dart",
//         message: "_",
//         exception: e,
//         trace: stackTrace,
//       );

//       errorInstance.reportError();

//       const defaultErrorString =
//           "Error occured when sending support ticket status request! Contact Support...";

//       if (e is DioException) {
//         return ServerResponse(
//             success: false,
//             message: e.response?.data['message'] ?? defaultErrorString,
//             data: null);
//       }

//       return ServerResponse(
//           success: false, message: defaultErrorString, data: null);
//     }
//   }
// }
