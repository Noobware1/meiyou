class NoAssetException implements Exception {
  const NoAssetException();

  @override
  String toString() {
    return 'NoAssetException: No assets Found';
  }
}
