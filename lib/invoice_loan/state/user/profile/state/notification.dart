enum Notificationtype { info, success, error }

extension NotificationTypeExtension on Notificationtype {
  String get value {
    switch (this) {
      case Notificationtype.info:
        return 'info';
      case Notificationtype.success:
        return 'success';
      case Notificationtype.error:
        return 'error';
    }
  }
}

class IbcNotification {
  final String id;
  final String title;
  final String message;
  final Notificationtype type;
  final int deliveredAt;
  final bool deleted;
  final num deletedAt;
  final bool seen;

  IbcNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.deliveredAt,
    required this.deleted,
    required this.deletedAt,
    required this.seen,
  });

  factory IbcNotification.fromJson(Map<String, dynamic> json) {
    Notificationtype type = Notificationtype.info;

    if (json['type'] == 'info') {
      type = Notificationtype.info;
    } else if (json['type'] == 'success') {
      type = Notificationtype.success;
    } else if (json['type'] == 'error') {
      type = Notificationtype.error;
    }

    return IbcNotification(
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

  static IbcNotification demo() {
    return IbcNotification(
      id: '',
      title: '',
      message: '',
      deliveredAt: 0,
      deleted: false,
      deletedAt: 0,
      type: Notificationtype.info,
      seen: false,
    );
  }
}
