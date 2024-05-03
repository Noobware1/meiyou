import 'package:flutter/material.dart';

abstract mixin class PlayerUiInterface {
  BuildContext get context;

  Widget playPauseButton();

  Widget seekBar();
  
}
