import 'package:flutter/material.dart';

extension AsyncSnapshotUtils<T> on AsyncSnapshot<T> {
  bool get waiting => connectionState == ConnectionState.waiting;
  bool get done => connectionState == ConnectionState.done;
}
