extension StringBufferExtensions on StringBuffer {
  void writeWithMiddleDot(String text) {
    write(' ');
    write('\u00B7');
    write(' ');
    write(text);
  }
}
