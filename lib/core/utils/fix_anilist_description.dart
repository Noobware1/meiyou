fixAnilistDescription(String text) {
  return text.replaceAll(RegExp(r'<.*?>'), '');
}
