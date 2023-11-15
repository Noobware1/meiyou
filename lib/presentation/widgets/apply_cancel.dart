import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class AppyCancel extends StatelessWidget {
  final VoidCallback onApply;
  final VoidCallback onCancel;
  final ButtonStyle? buttonStyleForCancel;
  final ButtonStyle? buttonStyleForApply;

  const AppyCancel({
    super.key,
    required this.onApply,
    required this.onCancel,
    this.buttonStyleForCancel,
    this.buttonStyleForApply,
  });

  @override
  Widget build(BuildContext context) {
    final applyButtonStyle = ButtonStyle(
      padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
      animationDuration: animationDuration,
      surfaceTintColor:
          MaterialStatePropertyAll(context.theme.colorScheme.onSurface),
      backgroundColor:
          MaterialStatePropertyAll(context.theme.colorScheme.onSurface),
      elevation: const MaterialStatePropertyAll(8),
      // foregroundColor: const MaterialStatePropertyAll(Colors.black),
      overlayColor: MaterialStatePropertyAll(
          context.theme.colorScheme.brightness == Brightness.dark
              ? Colors.black45
              : Colors.white54),
    );

    final cancelButtonStyle = ButtonStyle(
      padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
      animationDuration: animationDuration,
      surfaceTintColor:
          MaterialStatePropertyAll(context.theme.colorScheme.onSurface),
      backgroundColor: MaterialStatePropertyAll(
          context.theme.colorScheme.brightness == Brightness.dark
              ? const Color.fromARGB(255, 28, 27, 32)
              : Colors.white60),
      elevation: const MaterialStatePropertyAll(8),
      overlayColor: MaterialStatePropertyAll(
          context.theme.colorScheme.brightness == Brightness.dark
              ? Colors.white54
              : Colors.black45),
    );

    final applyButtonStyleForMobile = applyButtonStyle.copyWith(
        padding: const MaterialStatePropertyAll(EdgeInsets.all(10)));

    final cancelButtonStyleForMobile = cancelButtonStyle.copyWith(
        padding: const MaterialStatePropertyAll(EdgeInsets.all(10)));

    ButtonStyle builBasedOnDevice(
        ButtonStyle buttonStyle, ButtonStyle buttonStyleForMobile) {
      if (isMobile) {
        return buttonStyleForMobile;
      }
      return buttonStyle;
    }

    return SizedBox(
      height: isMobile ? 40 : 60,
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onApply,
              style: buttonStyleForApply ??
                  builBasedOnDevice(
                      applyButtonStyle, applyButtonStyleForMobile),
              child: Text(
                'Apply',
                style: TextStyle(
                    color: context.theme.colorScheme.surface,
                    fontSize: isMobile ? 15 : 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          addHorizontalSpace(5),
          Expanded(
            child: ElevatedButton(
              onPressed: onCancel,
              style: buttonStyleForCancel ??
                  builBasedOnDevice(
                      cancelButtonStyle, cancelButtonStyleForMobile),
              child: Text('Cancel',
                  style: TextStyle(
                      color: context.theme.colorScheme.brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: isMobile ? 15 : 17,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
