import 'package:meiyou/core/resources/expections.dart';

abstract class ResponseState<T> {
  final T? data;
  final MeiyouException? error;

  const ResponseState({this.data, this.error});

  static ResponseState<E> tryWith<E>(E Function() fun) {
    try {
      return ResponseSuccess(fun());
    } catch (e, s) {
      return ResponseFailed(MeiyouException(e.toString(), stackTrace: s));
    }
  }

  static Future<ResponseState<E>> tryWithAsync<E>(
      Future<E> Function() fun) async {
    try {
      return ResponseSuccess(await fun());
    } catch (e, s) {
      return ResponseFailed(MeiyouException(e.toString(), stackTrace: s));
    }
  }
}

class ResponseSuccess<T> extends ResponseState<T> {
  const ResponseSuccess(T data) : super(data: data);

  @override
  String toString() {
    return 'ResponseSuccess($data)';
  }
}

class ResponseFailed<T> extends ResponseState<T> {
  const ResponseFailed(MeiyouException error) : super(error: error);

  @override
  String toString() {
    return 'ResponseFailed($error)';
  }
}
