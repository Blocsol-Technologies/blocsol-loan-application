import 'package:freezed_annotation/freezed_annotation.dart';

part 'liability_details_state.freezed.dart';

@freezed
class InvoiceLoanUserLiabilityData with _$InvoiceLoanUserLiabilityData {
  const factory InvoiceLoanUserLiabilityData({
    required num numClosedLiabilities,
    required num numOpenLiabilities,
    required num numOutstandingValue,
    required num numClosedValue,
    required bool fetchingLiabilityDetails
  }) = _InvoiceLoanUserLiabilityData;

  static const InvoiceLoanUserLiabilityData initial = InvoiceLoanUserLiabilityData(
    numClosedLiabilities: -1,
    numClosedValue: -1,
    numOpenLiabilities: -1,
    numOutstandingValue: -1, fetchingLiabilityDetails: false  );
}
