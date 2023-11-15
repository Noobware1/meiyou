import 'package:meiyou/core/resources/expections.dart';

abstract class ResponseState<T> {
  final T? data;
  final MeiyouException? error;

  const ResponseState({this.data, this.error});
}

class ResponseSuccess<T> extends ResponseState<T> {
  const ResponseSuccess(T data) : super(data: data);
}

class ResponseFailed<T> extends ResponseState<T> {
  const ResponseFailed(MeiyouException error) : super(error: error);

  factory ResponseFailed.fromTMDB() {
    return ResponseFailed(MeiyouException.fromTMDB());
  }

  factory ResponseFailed.fromAnilist() {
    return ResponseFailed(MeiyouException.fromAnilist());
  }

  factory ResponseFailed.defaultError(Object expection, StackTrace stackTrace) {
    return ResponseFailed(MeiyouException(expection.toString(),
        stackTrace: stackTrace, type: MeiyouExceptionType.other));
  }

  factory ResponseFailed.onHttpUnSuccesful(String provider) {
    return ResponseFailed(MeiyouException(
        'Failed to get data from ${provider.toUpperCase()}',
        type: MeiyouExceptionType.providerException));
  }
}
