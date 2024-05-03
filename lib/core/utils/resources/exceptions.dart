class LoadingException implements Exception {
  final String? message;

  LoadingException([this.message]);

  @override
  String toString() {
    return 'LoadingException: $message';
  }
}


