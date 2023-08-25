import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/colors.dart';

class DefaultGrey extends StatelessWidget {
  final Widget child;
  const DefaultGrey({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return  DefaultTextStyle(
          style: defaultGrey,
          child:
              SizedBox(width: MediaQuery.of(context).size.width, child: child));
  
  }
}

