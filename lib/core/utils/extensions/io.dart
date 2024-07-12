import 'dart:io';

extension StringToFile on String {
  File toFile() => File(this);

  Directory toDirectory() => Directory(this);
}
