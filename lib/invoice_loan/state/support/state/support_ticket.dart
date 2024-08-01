import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    try {
      List<String> imageList = [];

      if (json['images'] != null) {
        for (var image in json['images'] as List<dynamic>) {
          imageList.add(image as String);
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
    } catch (e, stackTrace) {
      ErrorInstance(
        message: "Error occured when parsing Message.fromJson! Contact Support",
        exception: e,
        trace: stackTrace,
      ).reportError();
      return demo();
    }
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

  static Message demo() {
    return Message(
      agent: '',
      message: '',
      actionTaken: '',
      name: '',
      phone: '',
      email: '',
      updatedAt: '',
      images: [],
    );
  }
}

class SupportTicket {
  final String transactionId;
  final String providerId;
  final String gst;
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
    required this.gst,
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

      for (var message in json['conversations'] as List) {
        messages.add(Message.fromJson(message));
      }

      return SupportTicket(
        transactionId: json['transaction_id'],
        providerId: json['provider_id'],
        gst: json['gst'],
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
        message:
            "Error occured when parsing SupportTicket.fromJson! Contact Support",
        exception: e,
        trace: stackTrace,
      ).reportError();

      return SupportTicket(
        transactionId: '',
        providerId: '',
        gst: '',
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

  static SupportTicket demo() {
    return SupportTicket(
      transactionId: '',
      providerId: '',
      gst: '',
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
