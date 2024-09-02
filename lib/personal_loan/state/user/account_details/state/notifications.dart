enum PlNotificationType { info, success, error }

extension PlNotificationTypeExtension on PlNotificationType {
  String get value {
    switch (this) {
      case PlNotificationType.info:
        return 'info';
      case PlNotificationType.success:
        return 'success';
      case PlNotificationType.error:
        return 'error';
    }
  }
}

class PlNotification {
  final String id;
  final String title;
  final String message;
  final PlNotificationType type;
  final int deliveredAt;
  final bool deleted;
  final num deletedAt;
  bool seen;

  PlNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.deliveredAt,
    required this.deleted,
    required this.deletedAt,
    required this.seen,
  });

  factory PlNotification.fromJson(Map<String, dynamic> json) {
    PlNotificationType type = PlNotificationType.info;

    if (json['type'] == 'info') {
      type = PlNotificationType.info;
    } else if (json['type'] == 'success') {
      type = PlNotificationType.success;
    } else if (json['type'] == 'error') {
      type = PlNotificationType.error;
    }

    return PlNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: type,
      deliveredAt: json['deliveredAt'],
      deleted: json['deleted'],
      deletedAt: json['deletedAt'],
      seen: json['seen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'deliveredAt': deliveredAt,
      'deleted': deleted,
      'deletedAt': deletedAt,
      'type': type.value,
      'seen': seen,
    };
  }

  static PlNotification demo() {
    return PlNotification(
      id: '',
      title: '',
      message: '',
      deliveredAt: 0,
      deleted: false,
      deletedAt: 0,
      type: PlNotificationType.info,
      seen: false,
    );
  }

  void markRead(bool val) {
    seen = val;
  }
}
