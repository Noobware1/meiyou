import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        elevation: 0.0,
      ),
      // : context.theme.colorScheme.background,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
