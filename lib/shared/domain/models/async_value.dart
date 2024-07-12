class AsyncValue<T> {
  final T? _value;
  final Object? _error;
  final StackTrace? _stackTrace;
  final bool _isLoading;
  final bool _isNoData;

  const AsyncValue._({
    T? value,
    Object? error,
    StackTrace? stackTrace,
    bool isLoading = false,
    bool isNoData = false,
  })  : _value = value,
        _error = error,
        _stackTrace = stackTrace,
        _isLoading = isLoading,
        _isNoData = isNoData;

  const AsyncValue.data(T value) : this._(value: value);

  const AsyncValue.error(Object error, [StackTrace? stackTrace])
      : this._(error: error);

  const AsyncValue.loading() : this._(isLoading: true);

  const AsyncValue.noData() : this._(isNoData: true);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncValue<T> &&
          runtimeType == other.runtimeType &&
          _value == other._value &&
          _error == other._error &&
          _isLoading == other._isLoading &&
          _isNoData == other._isNoData;

  @override
  int get hashCode =>
      _value.hashCode ^
      _error.hashCode ^
      _isLoading.hashCode ^
      _isNoData.hashCode;

  @override
  String toString() {
    return 'AsyncValue{value: $_value, error: $_error, isLoading: $_isLoading, isNoData: $_isNoData}';
  }
}

extension AsyncValueExt<T> on AsyncValue<T> {
  bool get hasData => _value != null;

  bool get isError => _error != null;

  bool get isLoading => _isLoading;

  bool get isNoData => _isNoData;

  T getOrThrow() {
    if (hasData) {
      return _value!;
    } else {
      throw _error!;
    }
  }

  T? getOrNull() {
    if (hasData) {
      return _value;
    } else {
      return null;
    }
  }

  Object? errorOrNull() {
    if (isError) {
      return _error;
    } else {
      return null;
    }
  }

  StackTrace? stackTraceOrNull() {
    if (isError) {
      return _stackTrace;
    } else {
      return null;
    }
  }

  E when<E>(
    E Function(T value) success,
    E Function(Object error, StackTrace? stackTrace) error,
    E Function() loading,
    E Function() noData,
  ) {
    if (hasData) {
      return success(getOrThrow());
    } else if (isError) {
      return error(_error!, _stackTrace);
    } else if (isLoading) {
      return loading();
    } else {
      return noData();
    }
  }
}
