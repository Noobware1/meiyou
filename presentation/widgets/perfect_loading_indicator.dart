import 'package:flutter/material.dart';

class PerfectLoadingIndicator extends StatelessWidget {
  const PerfectLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
