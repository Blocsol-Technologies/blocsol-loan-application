import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class InvoiceLoanAccountSettings extends StatefulWidget {
  const InvoiceLoanAccountSettings({super.key});

  @override
  State<InvoiceLoanAccountSettings> createState() =>
      _InvoiceLoanAccountSettingsState();
}

class _InvoiceLoanAccountSettingsState
    extends State<InvoiceLoanAccountSettings> {
  final _controller = ValueNotifier<bool>(false);

  bool _notificationsOn = false;

  bool _deletingAccount = false;

  Future<void> _deleteAccountHandler() async {
    return;
  }

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        _notificationsOn = _controller.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Settings",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h3,
              fontWeight: AppFontWeights.medium,
              color: const Color.fromRGBO(75, 85, 95, 1),
            ),
          ),
          const SpacerWidget(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Notifications (${_notificationsOn ? 'On' : 'Off'})",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              AdvancedSwitch(
                height: 20,
                width: 35,
                activeColor: Theme.of(context).colorScheme.primary,
                controller: _controller,
              ),
            ],
          ),
          const SpacerWidget(
            height: 15,
          ),
          const Divider(
            color: Color.fromRGBO(205, 205, 205, 1),
            height: 1,
          ),
          const SpacerWidget(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();

              if (_deletingAccount) {
                return;
              }

              setState(() {
                _deletingAccount = true;
              });

              _deleteAccountHandler().then((_) {
                setState(() {
                  _deletingAccount = false;
                });
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delete Account",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.medium,
                    color: Colors.red,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
