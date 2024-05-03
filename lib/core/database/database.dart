import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

class DataBase {
  late final Isar isar;

  DataBase(String directory) {
    isar = Isar.openSync(
      [],
      directory: directory,
      name: 'meiyou-db',
      inspector: kDebugMode,
    );
  }
}
