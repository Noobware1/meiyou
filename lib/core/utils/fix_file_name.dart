String fixFileName(String title) {
  title = title.toLowerCase();
  return title.replaceAll(' ', '_').replaceAll('/', '').trim();
}

String? getFileNameFromUrl(String url) {
  final uri = Uri.tryParse(url);

  if (uri == null) return null;

  return _getFileNameFromString(uri.path);
}

String cleanString(String str) {
  return str
      .replaceAll(RegExp(r'[^\w\s]', caseSensitive: false, multiLine: true), '')
      .replaceAll('\n', '')
      .replaceAll(' ', '');
}

String getFileNameFromStr(String str) {
  final urlBased = getFileNameFromUrl(str);
  if (urlBased != null) return urlBased;
  return _getFileNameFromString(str);
}

String _getFileNameFromString(String str) {
  str = cleanString(str);

  return reduceListToLength(str.split(''), 10).join('').codeUnits.join('');
}

//chatgpt coming in with a clutch
List<T> reduceListToLength<T>(List<T> originalList, int desiredLength) {
  int originalLength = originalList.length;

  if (originalLength <= desiredLength) {
    return originalList; // If the original list is shorter or equal to the desired length, return it as-is.
  }

  // Calculate how many elements to remove from both ends to reach the desired length.
  int elementsToRemove = originalLength - desiredLength;

  // Calculate the number of elements to remove from the beginning and end.
  int elementsToRemoveFromStart = elementsToRemove ~/ 2; // Integer division.
  int elementsToRemoveFromEnd = elementsToRemove - elementsToRemoveFromStart;

  // Create a new list by removing the appropriate number of elements from both ends.
  List<T> reducedList = originalList.sublist(
      elementsToRemoveFromStart, originalLength - elementsToRemoveFromEnd);
  assert(reducedList.isNotEmpty);
  return reducedList;
}
