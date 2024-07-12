import 'package:flutter/material.dart';

class GroupedListView<Key, Value> extends StatelessWidget {
  final Map<Key, List<Value>> group;
  final Widget Function(BuildContext, Value) itemBuilder;
  final Widget Function(BuildContext, Key) groupHeaderBuilder;
  final Widget Function(BuildContext)? seperatorBuilder;
  final ScrollController? controller;
  const GroupedListView({
    super.key,
    required this.group,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    this.seperatorBuilder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    context as GroupedListElement<Key, Value>;

    Widget builder(BuildContext context, int index) {

    }

    return seperatorBuilder != null
        ? ListView.separated(
            controller: controller,
            itemCount: context.,
            separatorBuilder: (context, index) => seperatorBuilder!(context),
            itemBuilder: builder,
          )
        : ListView.builder(
            controller: controller,
            itemCount: context.itemCount,
            itemBuilder: builder,
          );
  }


}

class a extends StatefulWidget {

}

class GroupedListElement<Key, Value> extends StatelessElement {
  late final List<Object?> _cacheList;
  late final List<int> _keyIndexes;

  GroupedListElement(GroupedListView<Key, Value> super.widget) {
    final itemCount =
        widget.group.values.fold(0, (prev, element) => prev + element.length);
    final keyCount = widget.group.keys.length;
    _cacheList = List.filled(itemCount, null, growable: false);
    _keyIndexes = List.filled(keyCount, 0, growable: false);
    var keyIndex = 0;
    var i = 0;
    for (final key in widget.group.keys) {
      _cacheList[i++] = key;
      _keyIndexes[keyIndex++] = i;
      for (final value in widget.group[key]!) {
        _cacheList[i++] = value;
      }
    }
  }

  @override
  void update(covariant StatelessWidget newWidget) {
    super.update(newWidget);
    
  }

  @override
  GroupedListView<Key, Value> get widget =>
      super.widget as GroupedListView<Key, Value>;

  T get<T>(int index) => _cacheList[index] as T;

int get itemCount => _cacheList.length;



}
