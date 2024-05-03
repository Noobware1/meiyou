import 'package:flutter/material.dart';

abstract interface class OnBoardingStep {
  bool get isCompleted;

  abstract final VoidCallback? listener;

  Widget build(BuildContext context);
}

abstract class OnBoardingStepWidget extends StatefulWidget {
  final void Function(bool isCompleted)? onCompleted;
  const OnBoardingStepWidget({this.onCompleted, super.key});
}
