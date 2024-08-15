import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_details_state.freezed.dart';

class Address {
  final String streetAddress;
  final String state;
  final String city;
  final String pincode;

  Address({
    this.streetAddress = "",
    this.state = "",
    this.city = "",
    this.pincode = "",
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
          streetAddress: json['line1'] ?? "",
          state: json['state'] ?? "",
          city: json['city'] ?? "",
          pincode: json['pincode'] ?? "");
    } catch (e) {
      return Address();
    }
  }

  static Address getNew() {
    return Address();
  }
}

class Notification {
  final String title;
  final String message;
  final String id;
  final num deliveredAt;
  final num deletedAt;
  final bool deleted;

  Notification({
    this.title = "",
    required this.message,
    required this.id,
    this.deliveredAt = 0,
    this.deletedAt = 0,
    this.deleted = false,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    try {
      return Notification(
        title: json['title'] ?? "",
        message: json['message'] ?? "",
        id: json['id'] ?? "",
        deliveredAt: json['deliveredAt'] ?? 0,
        deletedAt: json['deletedAt'] ?? 0,
        deleted: json['deleted'] ?? false,
      );
    } catch (e) {
      return Notification(message: "", id: "");
    }
  }
}

class NotificationsData {
  final bool seen;
  final List<Notification> notifications;

  NotificationsData({
    this.seen = false,
    required this.notifications,
  });

  factory NotificationsData.fromJson(Map<String, dynamic> json) {
    try {
      List<Notification> notifications = [];

      for (var notification in json['notifications']) {
        notifications.add(Notification.fromJson(notification));
      }

      return NotificationsData(
        seen: json['seen'] ?? false,
        notifications: notifications,
      );
    } catch (e) {
      return NotificationsData(notifications: []);
    }
  }

  static NotificationsData getNew() {
    return NotificationsData(notifications: []);
  }
}

@freezed
class AccountDetailsData with _$AccountDetailsData {
  const factory AccountDetailsData({
    // Personal Details
    required String name,
    required String imageURL,
    required String email,
    required String phone,
    required String dob,
    required String gender,
    required Address address,
    required String pan,
    required String udyam,
    required String companyName,
    required NotificationsData notifications,
  }) = _AccountDetailsData;
}
