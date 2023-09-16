import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'add_space.dart';

class RetryConnection extends StatelessWidget {
  final VoidCallback onRetryConnection;
  final String retryReason;
  const RetryConnection(
      {super.key, required this.onRetryConnection, required this.retryReason});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton.icon(
          style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.black38),
            padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
            maximumSize: MaterialStatePropertyAll(Size(230, 100)),
            elevation: MaterialStatePropertyAll(10),
            backgroundColor: MaterialStatePropertyAll(Colors.white),
          ),
          onPressed: onRetryConnection,
          label: const Text(
            'Retry Connection',
            style: TextStyle(
                inherit: true,
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          icon: const Icon(
            Icons.refresh_rounded,
            color: Colors.black,
          )),
      addVerticalSpace(10),
      DefaultTextStyle(
        style: const TextStyle(
            inherit: true, fontSize: 18, fontWeight: FontWeight.w600),
        child: Text(
          retryReason,
          textAlign: TextAlign.center,
        ),
      ),
    ]);
    ;
  }
}
