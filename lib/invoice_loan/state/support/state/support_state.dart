import 'package:blocsol_loan_application/invoice_loan/state/support/state/support_ticket.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_state.freezed.dart';

@freezed
class SupportStateData with _$SupportStateData {
  const factory SupportStateData({
    required String transactionId,
    required String providerId,
    required String issueId,

    required bool generatingSupportTicket,
    required bool fetchingAllSupportTickets,
    required bool fetchingSingleSupportTicket,
    required List<SupportTicket> supportTickets,
    required SupportTicket selectedSupportTicket,
    required bool sendingStatusRequest,
  }) = _SupportStateData;

  static var initial = SupportStateData(
    transactionId: '',
    providerId: '',
    issueId: '',
    generatingSupportTicket: false,
    fetchingAllSupportTickets: false,
    fetchingSingleSupportTicket: false,
    supportTickets: [],
    selectedSupportTicket: SupportTicket.demo(),
    sendingStatusRequest: false,
  );
}
