import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_liabilities_state.freezed.dart';

@freezed
class AllLiabilitiesState with _$AllLiabilitiesState {
  const factory AllLiabilitiesState({
    required List<LoanDetails> liabilities,
    required bool fetchingLiabilitiess,
    required int liabilitiessFetchTime,

    required List<LoanDetails> closedLiabilities,
    required bool fetchingClosedLiabilities,
    required int closedLiabilitiessFetchTime,
  }) = _AllLiabilitiesState;

  static var initial = const AllLiabilitiesState(
    liabilities: [],
    fetchingLiabilitiess: false,
    liabilitiessFetchTime: 0,

    closedLiabilities: [],
    fetchingClosedLiabilities: false,
    closedLiabilitiessFetchTime: 0,
  );
}
