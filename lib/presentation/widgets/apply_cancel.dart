import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
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

  static const _applyButtonStyle = ButtonStyle(
      padding: MaterialStatePropertyAll(EdgeInsets.all(15)),
      animationDuration: animationDuration,
      backgroundColor: MaterialStatePropertyAll(Colors.white),
      elevation: MaterialStatePropertyAll(8),
      foregroundColor: MaterialStatePropertyAll(Colors.black),
      overlayColor: MaterialStatePropertyAll(Colors.black54),
      textStyle: MaterialStatePropertyAll(TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600)));

  static const _cancelButtonStyle = ButtonStyle(
      padding: MaterialStatePropertyAll(EdgeInsets.all(15)),
      animationDuration: animationDuration,
      backgroundColor: MaterialStatePropertyAll(
        Color.fromARGB(255, 28, 27, 32),
      ),
      elevation: MaterialStatePropertyAll(8),
      foregroundColor: MaterialStatePropertyAll(Colors.white),
      overlayColor: MaterialStatePropertyAll(Colors.white54),
      textStyle: MaterialStatePropertyAll(TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)));

  static final _applyButtonStyleForMobile = _applyButtonStyle.copyWith(
      textStyle: const MaterialStatePropertyAll(TextStyle(
          color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600)),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(10)));

  static final _cancelButtonStyleForMobile = _cancelButtonStyle.copyWith(
      textStyle: const MaterialStatePropertyAll(TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(10)));

  @override
  Widget build(BuildContext context) {
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
                      _applyButtonStyle, _applyButtonStyleForMobile),
              child: const Text('Apply'),
            ),
          ),
          addHorizontalSpace(5),
          Expanded(
            child: ElevatedButton(
              onPressed: onCancel,
              style: buttonStyleForCancel ??
                  builBasedOnDevice(
                      _cancelButtonStyle, _cancelButtonStyleForMobile),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
