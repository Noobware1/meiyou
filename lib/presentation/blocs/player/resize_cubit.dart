// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou_extenstions/extenstions.dart';
import 'package:meiyou_extenstions/meiyou_extenstions.dart';

enum ResizeMode {
  Normal,
  Zoom,
  Stretch;

  BoxFit toBoxFit() {
    switch (this) {
      case ResizeMode.Zoom:
        return BoxFit.cover;
      case ResizeMode.Stretch:
        return BoxFit.fill;
      case ResizeMode.Normal:
      default:
        return BoxFit.contain;
    }
  }

  @override
  String toString() {
    return super.toString().substringAfter('ResizeMode.');
  }
}

class ResizeCubit extends Cubit<ResizeMode> {
  ResizeCubit() : super(ResizeMode.Normal);

  void resize(BuildContext context) {
    switch (state) {
      case ResizeMode.Normal:
        emit(ResizeMode.Zoom);
        break;
      case ResizeMode.Zoom:
        emit(ResizeMode.Stretch);
        break;
      case ResizeMode.Stretch:
        emit(ResizeMode.Normal);
        break;
      default:
    }
    showSnackBar(context, text: state.toString());
  }
}
