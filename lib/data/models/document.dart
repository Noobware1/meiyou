import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/data/models/element.dart';
import 'package:ok_http_dart/dom.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class DocumentObject {
  final Document document;

  const DocumentObject(this.document);

  List<ElementObject> select(String selector) {
    return (trySync(() => document.select(selector)) ?? [])
        .mapAsList((it) => ElementObject(it));
  }

  ElementObject selectFirst(String selector) {
    return ElementObject(document.selectFirst(selector));
  }

  ElementObject? trySelectFirst(String selector) {
    return trySync(() => ElementObject(document.selectFirst(selector)));
  }
}
