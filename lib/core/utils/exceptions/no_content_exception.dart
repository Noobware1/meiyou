class NoContentException implements Exception {
  const NoContentException();

  @override
  String toString() {
    return 'NoContentException: No content found';
  }
}
