class NoLinksFound implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const NoLinksFound(this.message, {this.stackTrace});

  @override
  String toString() {
    return '$message\nStack Trace\n$stackTrace';
  }
}


class FailedToExtract implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const FailedToExtract(this.message, {this.stackTrace});

  @override
  String toString() {
    return '$message\nStack Trace\n$stackTrace';
  }
}


class MeiyouException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final MeiyouExceptionType? type;

  const MeiyouException(this.message, {this.stackTrace, this.type});

  @override
  String toString() {
    return '$message\nStack Trace\n$stackTrace\nException Type: $type';
  }

  factory MeiyouException.fromAuth([StackTrace? stack]) {
    return MeiyouException(
        'Authentication failed! Please double check if you verified meiyou successfully or try again',
        stackTrace: stack);
  }

  factory MeiyouException.fromTMDB() {
    return const MeiyouException('Failed Fetch Data From TMDB',
        type: MeiyouExceptionType.providerException);
  }

  factory MeiyouException.fromAnilist() {
    return const MeiyouException('Failed Fetch Data From Anilist',
        type: MeiyouExceptionType.providerException);
  }

  static T? tryWithSync<T>(T Function() fun,
      [void Function(Object e, StackTrace s)? onError]) {
    try {
      return fun.call();
    } catch (e, s) {
      onError?.call(e, s);
      return null;
    }
  }

  static Future<T?> tryWithAsync<T>(Future<T> Function() fun,
      [void Function(Object e, StackTrace s)? onError]) async {
    try {
      return await fun.call();
    } catch (e, s) {
      onError?.call(e, s);
      return null;
    }
  }

  static const empty = MeiyouException('');
}

enum MeiyouExceptionType { providerException, appException, other }
