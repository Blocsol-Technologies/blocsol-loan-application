import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';

class AccountAggregatorInfo {
  final String name;
  final String assetPath;
  final String url;
  final String key;
  final int playStoreRating;
  String aaId = "";

  AccountAggregatorInfo({
    required this.name,
    required this.assetPath,
    required this.playStoreRating,
    this.url = "",
    required this.key,
  });

  static AccountAggregatorInfo demo() {
    return AccountAggregatorInfo(
        name: "Sahamati",
        playStoreRating: 5,
        assetPath: "assets/images/aa_logos/sahamati.png",
        key: "SAHAMATI");
  }

  void setId(String phone) {
    aaId = "$phone@${key.toLowerCase()}";
  }

  String getId() {
    return aaId;
  }
}

List<AccountAggregatorInfo> accountAggregatorInfoList = [
  AccountAggregatorInfo(
      name: "Anumati",
      playStoreRating: 3,
      assetPath: "assets/images/aa_logos/anumati.png",
      key: "ANUMATI",
      url: "https://google.com"),
  AccountAggregatorInfo(
      name: "Finvu",
      playStoreRating: 4,
      assetPath: "assets/images/aa_logos/finvu.png",
      key: "FINVU",
      url: "https://reactjssdk.finvu.in/"),
  AccountAggregatorInfo(
      name: "Onemoney",
      playStoreRating: 2,
      assetPath: "assets/images/aa_logos/onemoney.png",
      key: "ONEMONEY",
      url: "https://webrd.onemoney.in/uat/v1/"),
];

AccountAggregatorInfo getAccountAggregatorInfo(String accountAggregatorName) {
  AccountAggregatorInfo accountAggregatorInfo = AccountAggregatorInfo(
      name: "Sahamati",
      playStoreRating: 5,
      assetPath: "assets/images/aa_logos/sahamati.png",
      key: "SAHAMATI",
      url: "");
  double maxSimilarity = 0.0;

  for (var info in accountAggregatorInfoList) {
    double similarity = accountAggregatorName.similarityTo(info.name);
    if (similarity > maxSimilarity) {
      maxSimilarity = similarity;
      accountAggregatorInfo = info;
    }
  }

  if (maxSimilarity < 0.6) {
    return AccountAggregatorInfo(
        name: "Sahamati",
        playStoreRating: 5,
        assetPath: "assets/images/aa_logos/sahamati.png",
        key: "SAHAMATI",
        url: "");
  }

  return accountAggregatorInfo;
}

class LenderDetails {
  final String name;
  final String assetPath;
  final List<AccountAggregatorInfo> connectedAA;
  final bool show;

  LenderDetails({
    required this.name,
    required this.assetPath,
    required this.connectedAA,
    this.show = true,
  });
}

List<LenderDetails> lenderDetailsList = [
  LenderDetails(
      name: "SIDBI",
      assetPath: "assets/images/lender_logos/sidbi.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "DMI FINANCE PRIVATE LIMITED",
      assetPath: "assets/images/lender_logos/dmi.png",
      connectedAA: accountAggregatorInfoList,
      show: false),
  LenderDetails(
      name: "ICICI Bank",
      assetPath: "assets/images/lender_logos/icici.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "HDFC Bank",
      assetPath: "assets/images/lender_logos/hdfc.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "Central Bank",
      assetPath: "assets/images/lender_logos/central-bank.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "Punjab National Bank",
      assetPath: "assets/images/lender_logos/punjab-national.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "UCO Bank",
      assetPath: "assets/images/lender_logos/uco.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "Kotak Mahindra Bank",
      assetPath: "assets/images/lender_logos/kotak.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "Axis Bank",
      assetPath: "assets/images/lender_logos/axis.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "IDFC Bank",
      assetPath: "assets/images/lender_logos/idfc.jpeg",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "IDBI Bank",
      assetPath: "assets/images/lender_logos/idbi.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "IndusInd Bank",
      assetPath: "assets/images/lender_logos/indusind.png",
      connectedAA: accountAggregatorInfoList),
  LenderDetails(
      name: "Union Bank",
      assetPath: "assets/images/lender_logos/union.png",
      connectedAA: accountAggregatorInfoList),
];

Widget getLenderDetailsAssetURL(String bankName, String imageUrl) {
  String lenderDetailsAssetURL = "";
  double maxSimilarity = 0.0;

  for (var lenderDetails in lenderDetailsList) {
    double similarity = bankName.similarityTo(lenderDetails.name);
    if (similarity > maxSimilarity) {
      maxSimilarity = similarity;
      lenderDetailsAssetURL = lenderDetails.assetPath;
    }
  }

  if (maxSimilarity > 0.6) {
    return Image.asset(
      lenderDetailsAssetURL,
      fit: BoxFit.contain,
    );
  }
  return Image.network(
    alignment: Alignment.centerLeft,
    imageUrl,
    fit: BoxFit.contain,
    errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      return Image.asset("assets/images/lender_logos/bank.png");
    },
  );
}

List<AccountAggregatorInfo> getLenderConnectedAA(String bankName) {
  List<AccountAggregatorInfo> connectedAA = [];
  double maxSimilarity = 0.0;

  for (var lenderDetails in lenderDetailsList) {
    double similarity = bankName.similarityTo(lenderDetails.name);
    if (similarity > maxSimilarity) {
      maxSimilarity = similarity;
      connectedAA = lenderDetails.connectedAA;
    }
  }

  return connectedAA;
}
