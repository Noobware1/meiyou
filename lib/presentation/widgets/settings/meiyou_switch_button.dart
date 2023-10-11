import 'package:flutter/material.dart';
import 'package:meiyou/core/resources/colors.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class MeiyouSwitchButton extends StatefulWidget {
  final void Function(bool value) onChanged;
  final TextStyle? style;
  final String label;
  final bool initalValue;
  const MeiyouSwitchButton(
      {super.key,
      required this.onChanged,
      this.style,
      required this.label,
      required this.initalValue});

  @override
  State<MeiyouSwitchButton> createState() => _MeiyouSwitchButtonState();
}

class _MeiyouSwitchButtonState extends State<MeiyouSwitchButton> {
  late bool _value = widget.initalValue;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.button,
      elevation: 0.0,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _value = _value ? false : true;
          });
          widget.onChanged(_value);
        },
        child: Row(
          children: [
            addHorizontalSpace(20),
            Expanded(
                child: Text(
              widget.label,
              style: widget.style,
            )),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Switch.adaptive(
                    activeTrackColor:
                        context.theme.colorScheme.primary.withOpacity(0.4),
                    inactiveThumbColor: getBaseColorFromThemeMode(
                        context, context.themeBloc.state.themeMode),
                    inactiveTrackColor: getBaseColorFromThemeMode(
                            context, context.themeBloc.state.themeMode)
                        .withOpacity(0.4),
                    activeColor: context.theme.colorScheme.primary,
                    value: context.themeBloc.state.isAmoled,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                      widget.onChanged(_value);
                    }),
              ),
            ),
            addHorizontalSpace(10),
          ],
        ),
      ),
    );
  }
}
