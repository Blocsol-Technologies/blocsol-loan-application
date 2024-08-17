import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/support/http_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/support/state/support_state.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'support.g.dart';

@riverpod
class PersonalLoanSupportState extends _$PersonalLoanSupportState {
  @override
  PersonalLoanSupportStateData build() {
    ref.keepAlive();
    return PersonalLoanSupportStateData(
      transactionId: '',
      providerId: '',
      issueId: '',
      pan: '',
      fetchingAllSupportTickets: false,
      fetchingSingleSupportTicket: false,
      generatingSupportTicket: false,
      supportTickets: [
        // SupportTicket(
        //   transactionId: '3ddb94f3-7e0e-431a-baeb-06fa78794a06',
        //   providerId: 'Kotak',
        //   pan: '06BBOPK6960P1ZS',
        //   conversations: [
        //     // Message(
        //     //     agent: 'CONSUMER',
        //     //     message: 'I am not able to complete the KYC',
        //     //     actionTaken: 'No action taken',
        //     //     name: 'Rahul',
        //     //     phone: '9876543210',
        //     //     email: '',
        //     //     updatedAt: '2024-04-28T03:13:20Z',
        //     //     images: []),
        //     // Message(
        //     //     agent: 'SUPPORT',
        //     //     message: 'Tell me what is the problem',
        //     //     actionTaken: 'No action taken',
        //     //     name: 'Avijeet',
        //     //     phone: '8360458365',
        //     //     email: '',
        //     //     updatedAt: '2024-05-28T03:13:20Z',
        //     //     images: []),
        //     // Message(
        //     //     agent: 'CONSUMER',
        //     //     message: 'I am not able to complete the KYC',
        //     //     actionTaken: 'No action taken',
        //     //     name: 'Rahul',
        //     //     phone: '9876543210',
        //     //     email: '',
        //     //     updatedAt: '2024-04-28T03:13:20Z',
        //     //     images: []),
        //     // Message(
        //     //     agent: 'SUPPORT',
        //     //     message: 'Tell me what is the problem',
        //     //     actionTaken: 'No action taken',
        //     //     name: 'Avijeet',
        //     //     phone: '8360458365',
        //     //     email: '',
        //     //     updatedAt: '2024-05-28T03:13:20Z',
        //     //     images: []),
        //     // Message(
        //     //     agent: 'CONSUMER',
        //     //     message: 'I am not able to complete the KYC',
        //     //     actionTaken: 'No action taken',
        //     //     name: 'Rahul',
        //     //     phone: '9876543210',
        //     //     email: '',
        //     //     updatedAt: '2024-04-28T03:13:20Z',
        //     //     images: []),
        //     // Message(
        //     //     agent: 'SUPPORT',
        //     //     message: 'Tell me what is the problem',
        //     //     actionTaken: 'No action taken',
        //     //     name: 'Avijeet',
        //     //     phone: '8360458365',
        //     //     email: '',
        //     //     updatedAt: '2024-05-28T03:13:20Z',
        //     //     images: []),
        //     // Message(
        //     //     agent: 'CONSUMER',
        //     //     message: 'I am not able to complete the KYC',
        //     //     actionTaken: 'No action taken',
        //     //     name: 'Rahul',
        //     //     phone: '9876543210',
        //     //     email: '',
        //     //     updatedAt: '2024-04-28T03:13:20Z',
        //     //     images: []),
        //     // Message(
        //     //     agent: 'SUPPORT',
        //     //     message: 'Tell me what is the problem',
        //     //     actionTaken: 'No action taken',
        //     //     name: 'Avijeet',
        //     //     phone: '8360458365',
        //     //     email: '',
        //     //     updatedAt: '2024-05-28T03:13:20Z',
        //     //     images: []),
        //   ],
        //   chatLink: '',
        //   id: '3ddb94f3-7e0e-431a-baeb-06fa78794a06',
        //   category: 'ORDER',
        //   subCategory: 'Fees/Charges related issues',
        //   createdAt: '2024-04-28T03:13:20Z',
        //   updatedAt: '2024-04-30T03:13:20Z',
        //   status: 'OPEN',
        // )
      ],
      selectedSupportTicket: SupportTicket(
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
      ),
      sendingStatusRequest: false,
    );
  }

  void reset() {
    state = PersonalLoanSupportStateData(
      transactionId: '',
      providerId: '',
      issueId: '',
      pan: '',
      generatingSupportTicket: false,
      fetchingAllSupportTickets: false,
      fetchingSingleSupportTicket: false,
      supportTickets: [],
      selectedSupportTicket: SupportTicket(
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
      ),
      sendingStatusRequest: false,
    );
  }

  void setSelectSupportTicket(SupportTicket supportTicket) {
    state = state.copyWith(selectedSupportTicket: supportTicket);
  }

  void setIssueDetails(
      String providerId, String transactionId, String issueId, String pan) {
    state = state.copyWith(
      providerId: providerId,
      transactionId: transactionId,
      issueId: issueId,
      pan: pan,
    );
  }

  void addMessageToSelectedSupportTicket(Message message) {
    var selectedSupportTicket = state.selectedSupportTicket;
    selectedSupportTicket.addMessage(message);
    state = state.copyWith(selectedSupportTicket: selectedSupportTicket);
  }

  void setSupportContext(String transactionId, String providerId) {
    state = state.copyWith(
      transactionId: transactionId,
      providerId: providerId,
    );
  }

  Future<ServerResponse> fetchAllSupportTickets(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(fetchingAllSupportTickets: true);

    var response = await PersonalLoanSupportHttpController()
        .fetchAllSupportTickets(authToken, cancelToken);

    state = state.copyWith(fetchingAllSupportTickets: false);

    if (response.success) {
      state = state.copyWith(supportTickets: response.data);
    }

    return response;
  }

  Future<ServerResponse> fetchSingleSupportTicket(
      CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(fetchingSingleSupportTicket: true);

    var response = await PersonalLoanSupportHttpController()
        .fetchSingleSupportTicket(state.transactionId, state.providerId,
            state.issueId, authToken, cancelToken);

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
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(generatingSupportTicket: true);

    var response = await PersonalLoanSupportHttpController().raiseSupportIssue(
      category,
      subCategory,
      status,
      message,
      images,
      state.transactionId,
      state.providerId,
      authToken,
      cancelToken,
    );

    state = state.copyWith(generatingSupportTicket: false);

    return response;
  }

  Future<ServerResponse> sendStatusRequest(CancelToken cancelToken) async {
    var (authToken, _) = ref.read(authProvider.notifier).getAuthTokens();

    state = state.copyWith(sendingStatusRequest: true);

    var response = await PersonalLoanSupportHttpController().sendStatusRequest(
        state.issueId,
        state.transactionId,
        state.providerId,
        authToken,
        cancelToken);

    if (response.success) {
      await fetchSingleSupportTicket(cancelToken);
    }

    state = state.copyWith(sendingStatusRequest: false);

    return response;
  }
}
