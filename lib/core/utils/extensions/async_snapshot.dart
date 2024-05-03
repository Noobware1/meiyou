import 'package:flutter/material.dart';

extension AsyncSnapshotExtensions<T> on AsyncSnapshot<T> {
  E when<E>({
    required E Function(T data) data,
    required E Function(Object? error, StackTrace? stackTrace) error,
    required E Function() loading,
  }) {
    if (hasError) {
      return error(error, stackTrace);
    } else if (hasData) {
      return data(data as T);
    } else {
      return loading();
    }
  }
}
