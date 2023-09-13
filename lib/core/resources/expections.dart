class MeiyouException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final MeiyouExceptionType? type;

  const MeiyouException(this.message, {this.stackTrace, this.type});

  @override
  String toString() {
    return 'MeiyouException\n$message\nStack Trace\n$stackTrace\nException Type: $type';
  }

  factory MeiyouException.fromTMDB() {
    return const MeiyouException('Failed Fetch Data From TMDB',
        type: MeiyouExceptionType.providerException);
  }

  factory MeiyouException.fromAnilist() {
    return const MeiyouException('Failed Fetch Data From Anilist',
        type: MeiyouExceptionType.providerException);
  }

  static const empty = MeiyouException('');
}

enum MeiyouExceptionType { providerException, appException, other }
