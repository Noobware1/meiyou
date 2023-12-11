part of 'async_cubit.dart';

class AsyncState<T> extends Equatable {
  final T? data;
  final MeiyouException? error;
  const AsyncState({this.data, this.error});

  @override
  List<Object> get props => [];

  Widget when(
      {required Widget Function(T data) data,
      required Widget Function(MeiyouException error) error,
      required Widget Function() loading}) {
    if (this is AsyncStateSuccess) {
      return data(this.data as T);
    } else if (this is AsyncStateFailed) {
      return error(this.error!);
    } else {
      return loading();
    }
  }
}

final class AsyncStateLoading<T> extends AsyncState<T> {
  const AsyncStateLoading();
}

final class AsyncStateSuccess<T> extends AsyncState<T> {
  const AsyncStateSuccess(T data) : super(data: data);
}

final class AsyncStateFailed<T> extends AsyncState<T> {
  const AsyncStateFailed(MeiyouException error) : super(error: error);
}
