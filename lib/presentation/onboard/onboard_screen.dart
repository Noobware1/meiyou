import 'package:flutter/material.dart';
import 'package:meiyou/core/config/routes/routes.dart';

import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/meiyou_core.dart';
import 'package:meiyou/core/utils/resources/modules/base_preferences.dart';
import 'package:meiyou/presentation/core/info_screen.dart';
import 'package:meiyou/presentation/onboard/steps/guides_step.dart';
import 'package:meiyou/presentation/onboard/steps/onboarding_step.dart';
import 'package:meiyou/presentation/onboard/steps/permission_step.dart';
import 'package:meiyou/presentation/onboard/steps/storage_step.dart';
import 'package:meiyou/presentation/onboard/steps/theme_step.dart';
import 'package:nice_dart/nice_dart.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  void rebuild() {
    setState(() {});
  }

  late final steps = <OnBoardingStep>[
    ThemeStep(),
    StorageStep(rebuild),
    PermissionStep(rebuild),
    GuidesStep(),
  ];

  int currentIndex = 0;

  void onCompleted(BuildContext context) {
    getIt.get<BasePreferences>().shownOnboardingFlow().set(true);
    context.goToHomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[currentIndex];
    final isLastStep = currentIndex == steps.lastIndex;
    return InfoScreen(
      icon: Icons.rocket_launch_outlined,
      heading: 'Welcome!',
      subtitleText:
          'Let\'s set some things up first. You can always change them later in the settings too.',
      acceptText: isLastStep ? 'Get Started' : 'Next',
      canAccept: step.isCompleted,
      onAccept: () {
        if (isLastStep) {
          onCompleted(context);
        } else {
          setState(() {
            currentIndex++;
          });
        }
      },
      child: step.build(context),
    );
  }
}
