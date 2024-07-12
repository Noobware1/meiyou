import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/toast.dart';
import 'package:meiyou/presentation/onboard/steps/onboarding_step.dart';
import 'package:meiyou/presentation/core/button.dart';
import 'package:meiyou/presentation/core/space.dart';

class GuidesStep implements OnBoardingStep {
  @override
  bool get isCompleted => true;

  @override
  GuidesStepWidget build(BuildContext context) => const GuidesStepWidget();

  @override
  VoidCallback? get listener => null;
}

class GuidesStepWidget extends StatelessWidget {
  const GuidesStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
            'Are you new to Meiyou? We recommend checking out the getting started guide.'),
        const VerticalSpace(10),
        Button(
          onPressed: () {
            makeToast(
              'Not Implemented Yet LOL!',
            );
          },
          text: 'Getting started guide',
        ),
        const VerticalSpace(10),
        Divider(height: 2, color: context.theme.colorScheme.onSurfaceVariant),
        const VerticalSpace(10),
        const Text('Reinstalling Meiyou?'),
        const VerticalSpace(10),
        Button(
          onPressed: () {
            makeToast(
              'Not Implemented Yet LOL!',
            );
          },
          text: 'Restore Backup',
        ),
      ],
    );
  }
}
