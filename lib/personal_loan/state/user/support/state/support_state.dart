import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'support_state.freezed.dart';

class Message {
  final String agent;
  final String message;
  final String actionTaken;
  final String name;
  final String phone;
  final String email;
  final String updatedAt;
  final List<String> images;

  Message({
    required this.message,
    required this.agent,
    required this.actionTaken,
    required this.name,
    required this.phone,
    required this.email,
    required this.updatedAt,
    required this.images,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    List<String> imageList = [];

    if (json['images'] != null) {
      try {
        for (var image in json['images'] as List<dynamic>) {
          imageList.add(image as String);
        }
      } catch (e, stackTrace) {
        ErrorInstance(
          message: e.toString(),
          exception: e,
          trace: stackTrace,
        ).reportError();
      }
    }

    return Message(
      agent: json['agent'],
      message: json['message'],
      actionTaken: json['action_taken'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      updatedAt: json['updated_at'],
      images: imageList,
    );
  }

  bool isCustomerMessage() {
    return agent == 'CONSUMER' || agent == 'CUSTOMER' || agent == 'customer';
  }

  String getReadableTime() {
    try {
      DateTime dateTime = DateTime.parse(updatedAt);
      return DateFormat('dd MM yy hh:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }
}

class SupportTicket {
  final String transactionId;
  final String providerId;
  final String pan;
  final List<Message> conversations;
  final String chatLink;
  final String id;
  final String category;
  final String subCategory;
  final String createdAt;
  final String updatedAt;
  final String status;

  SupportTicket({
    required this.transactionId,
    required this.providerId,
    required this.pan,
    required this.conversations,
    required this.chatLink,
    required this.id,
    required this.category,
    required this.subCategory,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    try {
      List<Message> messages = [];

      try {
        for (var message in json['conversations'] as List) {
          messages.add(Message.fromJson(message));
        }
      } catch (e, stackTrace) {
        ErrorInstance(
          message: e.toString(),
          exception: e,
          trace: stackTrace,
        ).reportError();
      }

      return SupportTicket(
        transactionId: json['transaction_id'],
        providerId: json['provider_id'],
        pan: json['pan'],
        conversations: messages,
        chatLink: json['chat_link'],
        id: json['id'],
        category: json['category'],
        subCategory: json['sub_category'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        status: json['status'],
      );
    } catch (e, stackTrace) {
      ErrorInstance(
        message: e.toString(),
        exception: e,
        trace: stackTrace,
      ).reportError();

      return SupportTicket(
        transactionId: '',
        providerId: '',
        pan: '',
        conversations: [],
        chatLink: '',
        id: '',
        category: '',
        subCategory: '',
        createdAt: '',
        updatedAt: '',
        status: '',
      );
    }
  }

  void addMessage(Message message) {
    conversations.add(message);
  }

  String getReadableTime(String timestampString) {
    try {
      DateTime dateTime = DateTime.parse(timestampString);

      return DateFormat('dd MM yy hh:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  Color getStatusColor() {
    switch (status) {
      case 'OPEN' || 'OPENED':
        return Colors.green;
      case 'CLOSED':
        return Colors.red;
      case 'PENDING' || 'PROCESSING' || 'PROCESS':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}

@freezed
class PersonalLoanSupportStateData with _$PersonalLoanSupportStateData {
  const factory PersonalLoanSupportStateData({
    required String transactionId,
    required String providerId,
    required String issueId,
    required String pan,
    required bool generatingSupportTicket,
    required bool fetchingAllSupportTickets,
    required bool fetchingSingleSupportTicket,
    required List<SupportTicket> supportTickets,
    required SupportTicket selectedSupportTicket,
    required bool sendingStatusRequest,
  }) = _PersonalLoanSupportStateData;
}
