import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/support/state/support_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/support/state/support_ticket.dart';
import 'package:blocsol_loan_application/invoice_loan/state/support/support_http_controller.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'support.g.dart';

@riverpod
class InvoiceLoanSupport extends _$InvoiceLoanSupport {
  @override
  SupportStateData build() {
    ref.keepAlive();
    return SupportStateData.initial;
  }

  void reset() {
    state = SupportStateData.initial;
  }

  void setSelectSupportTicket(SupportTicket supportTicket) {
    state = state.copyWith(selectedSupportTicket: supportTicket);
  }

  void addMessageToSelectedSupportTicket(Message message) {
    var selectedSupportTicket = state.selectedSupportTicket;
    selectedSupportTicket.addMessage(message);
    state = state.copyWith(selectedSupportTicket: selectedSupportTicket);
  }

  void setSupportContext(String transactionId, String providerId) {
    state = state.copyWith(
        transactionId: transactionId, providerId: providerId);
  }

  Future<ServerResponse> fetchAllSupportTickets(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(fetchingAllSupportTickets: true);

    var response = await SupportHttpController().fetchAllSupportTickets(
        authToken, cancelToken);

    if (response.success) {
      state = state.copyWith(
          supportTickets: response.data,
          fetchingAllSupportTickets:
              (response.data as List<SupportTicket>).isNotEmpty);
    }

    return response;
  }

  Future<ServerResponse> fetchSingleSupportTicket(
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(fetchingSingleSupportTicket: true);

    var response = await SupportHttpController().fetchSingleSupportTicketDetails(
        state.selectedSupportTicket.id,
        state.selectedSupportTicket.transactionId,
        state.selectedSupportTicket.providerId,
        authToken,
        cancelToken);

    state = state.copyWith(fetchingSingleSupportTicket: false);

    if (response.success) {
      state = state.copyWith(selectedSupportTicket: response.data);
    }

    return response;
  }

  Future<ServerResponse> raiseSupportIssue(
      String category,
      String subCategory,
      String status,
      String message,
      List<String> images,
      CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(generatingSupportTicket: true);

    var response = await SupportHttpController().raiseSupportIssue(
        message,
        status,
        category,
        subCategory,
        state.transactionId,
        state.providerId,
        images,
        authToken,
        cancelToken);

    state = state.copyWith(generatingSupportTicket: false);

    return response;
  }

  Future<ServerResponse> askForStatusUpdate(CancelToken cancelToken) async {
    var (_, authToken) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(sendingStatusRequest: true);

    var response = await SupportHttpController().askForStatusUpdate(state.issueId,
        state.transactionId, state.providerId, authToken, cancelToken);

    state = state.copyWith(sendingStatusRequest: false);

    return response;
  }
}
