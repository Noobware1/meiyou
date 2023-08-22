import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/utils/colors.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class AddToListButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? width;
  const AddToListButton({super.key, required this.onTap, this.width});

  static const _borderRadius = BorderRadius.all(Radius.circular(15));

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: animationDuration,
      borderRadius: _borderRadius,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: _borderRadius,
        splashColor: context.primaryColor,
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: width ?? context.screenWidth,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey),
              borderRadius: _borderRadius),
          child: Text(
            'ADD TO LIST',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: getPrimaryColor(context),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
