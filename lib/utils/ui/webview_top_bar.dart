import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewTopBar extends StatelessWidget {
  final InAppWebViewController? controller;
  const WebviewTopBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Positioned(
      top: 0,
      child: Container(
        width: width,
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                if (controller == null) {
                  return;
                }

                bool canGoBack = await controller!.canGoBack();

                if (canGoBack) {
                  await controller!.goBack();
                }
              },
              icon: Icon(
                Icons.arrow_back,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SpacerWidget(
              width: 30,
            ),
            IconButton(
              onPressed: () async {
                await controller!.reload();
              },
              icon: Icon(
                Icons.refresh,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
