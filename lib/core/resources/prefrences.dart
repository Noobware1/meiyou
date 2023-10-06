import 'dart:convert';
import 'dart:io';

import 'package:meiyou/core/resources/expections.dart';

Future<void> saveData(
    {required String savePath,
    required String data,
    void Function()? onCompleted,
    void Function(MeiyouException error)? onError}) async {
  final file = File(savePath);
  if (!file.existsSync()) {
    file.createSync();
  }
  var write = await MeiyouException.tryWithAsync(
      () => file.writeAsString(data, flush: true), (e, s) {
    onError?.call(MeiyouException(e.toString(), stackTrace: s));
  });
  if (write != null) {
    onCompleted?.call();
  }
}

Future<E?> loadData<E>(
    {required String savePath,
    required E Function(dynamic data) transFormer,
    void Function(MeiyouException error)? onError}) async {
  // final data = ;
  return MeiyouException.tryWithAsync(() async {
    final file = File(savePath);
    final data = jsonDecode(await file.readAsString());
    return transFormer.call(data);
  }, (e, s) => onError?.call(MeiyouException(e.toString(), stackTrace: s)));
}
