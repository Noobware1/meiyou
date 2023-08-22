String sanitizeTitle(String title) {
  String resTitle = title.replaceAll(
    RegExp(
      r' *((dub)|(sub)|(uncensored)|(uncut)|(subbed)|(dubbed))',
      caseSensitive: true,
    ),
    '',
  );
  resTitle =
      resTitle.replaceAll(RegExp(r' *([^)]+audio)', caseSensitive: true), '');
  resTitle = resTitle.replaceAll(RegExp(r' BD( |$)', caseSensitive: true), '');
  resTitle = resTitle.replaceAll(RegExp(r'(TV)', multiLine: true), '');
  resTitle = resTitle.trim();
  if (resTitle.length > 99) resTitle = resTitle.substring(0, 99); // truncate
  return resTitle;
}