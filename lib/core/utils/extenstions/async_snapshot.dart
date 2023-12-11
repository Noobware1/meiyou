import 'package:flutter/material.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';

extension AsyncSnapshotUtils<T> on AsyncSnapshot<T> {
  bool get waiting => connectionState == ConnectionState.waiting;
  bool get done => connectionState == ConnectionState.done;
}

extension AsyncSnapshotResponsestateUtils<T>
    on AsyncSnapshot<ResponseState<T>> {
  Widget when(
      {required Widget Function(T data) data,
      required Widget Function(MeiyouException error) error,
      required Widget Function() loading}) {
    if (done && this.data is ResponseSuccess) {
      return data(this.data!.data as T);
    } else if (done && this.data is ResponseFailed) {
      return error(this.data!.error!);
    } else {
      return loading();
    }
  }
}
