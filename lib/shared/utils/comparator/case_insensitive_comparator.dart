import 'dart:core';

class CaseInsensitiveComparator {
  static int compare(String a, String b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  }
}
