bool isURL(String input) {
  // Regular expression for a simple URL check
  RegExp urlRegExp = RegExp(
    r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$",
    caseSensitive: false,
    multiLine: false,
  );

  return urlRegExp.hasMatch(input);
}

bool isFilePath(String input) {
  // Regular expression for a simple file path check
  RegExp filePathRegExp = RegExp(
    r"^(\/([a-zA-Z0-9_\-]+\/)*[a-zA-Z0-9_\-]+\.[a-zA-Z0-9]+)?$",
    caseSensitive: false,
    multiLine: false,
  );

  return filePathRegExp.hasMatch(input);
}