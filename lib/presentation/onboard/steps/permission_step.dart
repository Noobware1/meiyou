import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/extensions/target_platfrom.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';
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

@override
  void didChangeDependencies() {
    super.didChangeDependencies();
 ;
  }


  void run<T>(Future<T> fun, void Function(T value) callback) {
    fun.then((value) {
      callback(value);
      if (manageExternalStoragePermission) {
        widget.onCompleted!(true);
      }
      setState(() {});
    });
  }

  Future<bool> _getStoragePermission(bool platfromIsMobile) {
    if (!platfromIsMobile) return Future.value(true);
    const permission = Permission.manageExternalStorage;
    return permission.isDenied.then((isDenied) async {
      if (!isDenied) return true;
      return PermissionStatus.granted == await permission.request();
    });
  }

  @override
  Widget build(BuildContext context) {
final bool platfromIsMobile  =  context.theme.platform.isMobile;
    return Column(children: [
      _BuildPermission(
        isGranted: manageExternalStoragePermission,
        onPressed: () {
          run(_getStoragePermission(platfromIsMobile), (value) {
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
              fontSize: MobileFontSize.normal,
              color: context.theme.colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            )),
        const VerticalSpace(8.0),
        Text(description,
            style: context.theme.textTheme.bodyMedium!
                .copyWith(color: context.theme.colorScheme.onSurfaceVariant)),
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
    return OutlinedButton(
        onPressed: onPressed, child: Text(isGranted ? 'Granted' : 'Grant'));
  }
}
