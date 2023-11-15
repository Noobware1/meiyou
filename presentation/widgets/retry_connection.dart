import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

import '../../lib/presentation/widgets/add_space.dart';

class RetryConnection extends StatelessWidget {
  final VoidCallback onRetryConnection;
  final String retryReason;
  const RetryConnection(
      {super.key, required this.onRetryConnection, required this.retryReason});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton.icon(
              style: ButtonStyle(
                  maximumSize: const MaterialStatePropertyAll(Size(230, 100)),
                  padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
                  backgroundColor: MaterialStatePropertyAll(
                      context.theme.colorScheme.onSurface),
                  elevation: const MaterialStatePropertyAll(8),
                  // foregroundColor: const MaterialStatePropertyAll(Colors.black),
                  overlayColor: MaterialStatePropertyAll(
                      context.theme.colorScheme.brightness == Brightness.dark
                          ? Colors.black45
                          : Colors.white54)),
              onPressed: onRetryConnection,
              label: Text(
                'Retry Connection',
                style: TextStyle(
                    color: context.theme.colorScheme.surface,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              icon: Icon(
                Icons.refresh_rounded,
                color: context.theme.colorScheme.surface,
              )),
          addVerticalSpace(10),
          Text(retryReason,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ]);
  }
}
