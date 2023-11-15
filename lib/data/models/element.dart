import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:ok_http_dart/dom.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class ElementObject {
  final Element element;

  ElementObject(this.element);

  String attr(String attr) {
    return trySync(() => element.attr(attr)) ?? '';
  }

  String text() {
    return element.text;
  }

  List<ElementObject> select(String selector) {
    return (trySync(() => element.select(selector)) ?? [])
        .mapAsList((it) => ElementObject(it));
  }

  ElementObject selectFirst(String selector) {
    return ElementObject(element.selectFirst(selector));
  }

  ElementObject? trySelectFirst(String selector) {
    return trySync(() => ElementObject(element.selectFirst(selector)));
  }
}
