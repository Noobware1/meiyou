import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/presentation/onboard/steps/onboarding_step.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionStep implements OnBoardingStep {
  PermissionStep(this.listener);

  bool _isCompleted = false;

  @override
  final VoidCallback listener;

  @override
  bool get isCompleted => _isCompleted;

  void _onComplete(bool isCompleted) {
    _isCompleted = isCompleted;
    listener();
  }

  @override
  PermissionStepWidget build(BuildContext context) =>
      PermissionStepWidget(onCompleted: _onComplete);
}

class PermissionStepWidget extends OnBoardingStepWidget {
  const PermissionStepWidget({super.key, required super.onCompleted});

  @override
  State<PermissionStepWidget> createState() => _PermissionStepState();
}

class _PermissionStepState extends State<PermissionStepWidget> {
  bool manageExternalStoragePermission = false;

  void run<T>(Future<T> fun, void Function(T value) callback) {
    fun.then((value) {
      callback(value);
      if (manageExternalStoragePermission) {
        widget.onCompleted!(true);
      }
      setState(() {});
    });
  }

  Future<bool> _getStoragePermission() {
    if (!isMobile) return Future.value(true);
    const permission = Permission.manageExternalStorage;
    return permission.isDenied.then((isDenied) async {
      if (!isDenied) return true;
      return PermissionStatus.granted == await permission.request();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _BuildPermission(
        isGranted: manageExternalStoragePermission,
        onPressed: () {
          run(_getStoragePermission(), (value) {
            manageExternalStoragePermission = value;
          });
        },
        text: const PermissionText(
            label: 'Manage external storage permission',
            description: 'To install source extensions and more.'),
      ),
    ]);
  }
}

class _BuildPermission extends StatelessWidget {
  final bool isGranted;
  final PermissionText text;
  final VoidCallback onPressed;

  const _BuildPermission({
    required this.isGranted,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: text),
        const HorizontalSpace(15),
        _GrantButton(
          isGranted: isGranted,
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class PermissionText extends StatelessWidget {
  final String label;
  final String description;
  const PermissionText({
    super.key,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 15,
              color: context.theme.colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            )),
        const VerticalSpace(8.0),
        Text(description,
            style: TextStyle(
              fontSize: 12.5,
              color: context.theme.colorScheme.onSecondary,
            )),
      ],
    );
  }
}

class _GrantButton extends StatelessWidget {
  final bool isGranted;
  final VoidCallback onPressed;
  const _GrantButton({required this.isGranted, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: isGranted
          ? context.theme.colorScheme.onPrimary
          : context.theme.colorScheme.primary,
    );

    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            isGranted ? context.theme.colorScheme.primary : Colors.transparent,
          ),
          side: MaterialStatePropertyAll(isGranted
              ? null
              : BorderSide(color: context.theme.colorScheme.onSecondary)),
          elevation: MaterialStatePropertyAll(isGranted ? null : 0.0),
        ),
        onPressed: onPressed,
        child: isGranted
            ? Text('Granted', style: textStyle)
            : Text('Grant', style: textStyle));
  }
}
