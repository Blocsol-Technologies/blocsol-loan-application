import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WindowPopup extends StatefulWidget {
  final CreateWindowAction createWindowAction;

  const WindowPopup({super.key, required this.createWindowAction});

  @override
  State<WindowPopup> createState() => _WindowPopupState();
}

class _WindowPopupState extends State<WindowPopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          Expanded(
            child: InAppWebView(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              windowId: widget.createWindowAction.windowId,
              onCloseWindow: (controller) {
                Navigator.pop(context);
              },
              onCreateWindow: (controller, createWindowAction) async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return WindowPopup(createWindowAction: createWindowAction);
                  },
                );
                return true;
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var url = navigationAction.request.url;

                bool isUrlValid =
                    url != null && url.hasScheme && url.host.isNotEmpty;

                if (isUrlValid) {
                  return NavigationActionPolicy.ALLOW;
                } else {
                  return NavigationActionPolicy.CANCEL;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
