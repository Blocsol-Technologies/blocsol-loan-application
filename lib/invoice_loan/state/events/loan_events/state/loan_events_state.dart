class LoanEvent {
  final String messageId;
  final String transactionId;
  final String providerId;
  final String gst;
  final String message;
  final bool success;
  final String context;
  final num stepNumber;
  final num nextStepNumber;
  bool consumed;
  final num timeStamp;
  final num priority;

  LoanEvent({
    required this.messageId,
    required this.transactionId,
    required this.providerId,
    required this.gst,
    required this.message,
    required this.success,
    required this.context,
    required this.stepNumber,
    required this.nextStepNumber,
    required this.consumed,
    required this.timeStamp,
    required this.priority,
  });

  factory LoanEvent.fromJson(Map<String, dynamic> json) {
    return LoanEvent(
      messageId: json['messageId'] ?? "",
      transactionId: json['transactionId'] ?? "",
      providerId: json['providerId'] ?? "",
      gst: json['gst'] ?? "",
      message: json['message'] ?? "",
      success: json['success'] ?? false,
      context: json['context'] ?? "",
      stepNumber: json['stepNumber'] ?? 0,
      nextStepNumber: json['nextStepNumber'] ?? 0,
      consumed: json['consumed'] ?? false,
      timeStamp: json['timeStamp'] ?? 0,
      priority: json['priority'] ?? 0,
    );
  }

  static LoanEvent demo() {
    return LoanEvent(
      messageId: "",
      transactionId: "",
      providerId: "",
      gst: "",
      message: "",
      success: false,
      context: "",
      stepNumber: 0,
      nextStepNumber: 0,
      consumed: false,
      timeStamp: 0,
      priority: 0,
    );
  }

  void updateConsumed(bool consumed) {
    this.consumed = consumed;
  }
}
