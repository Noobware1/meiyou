import 'package:flutter/material.dart';

class GroupedListView<Key, Value> extends Widget {
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
  GroupedListElement<Key, Value> createElement() =>
      GroupedListElement<Key, Value>(this);
}

class GroupedListElement<Key, Value> extends ComponentElement {
  static final List<Object?> emptyList = List.filled(0, null);
  late List<Object?> _cacheList;

  GroupedListElement(GroupedListView<Key, Value> super.widget) {
    _init(widget);
  }

  void _init(GroupedListView<Key, Value> widget) {
    final itemCount =
        widget.group.values.fold(0, (prev, element) => prev + element.length) +
            widget.group.keys.length;

    _cacheList = List.filled(itemCount, null, growable: false);
    var i = 0;
    for (final key in widget.group.keys) {
      _cacheList[i++] = key;
      for (final value in widget.group[key]!) {
        _cacheList[i++] = value;
      }
    }
  }

  @override
  void update(GroupedListView<Key, Value> newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _init(newWidget);
    rebuild(force: true);
  }

  @override
  void unmount() {
    super.unmount();
    _cacheList = emptyList;
  }

  @override
  GroupedListView<Key, Value> get widget =>
      super.widget as GroupedListView<Key, Value>;

  T get<T>(int index) => _cacheList[index] as T;

  int get itemCount => _cacheList.length;

  @override
  Widget build() {
    Widget builder(BuildContext _, int index) {
      final element = get<Object>(index);
      if (element is Key) {
        return widget.groupHeaderBuilder(this, element as Key);
      } else {
        return widget.itemBuilder(this, element as Value);
      }
    }

    final itemCount = this.itemCount;

    return widget.seperatorBuilder != null
        ? ListView.separated(
            controller: widget.controller,
            itemCount: itemCount,
            separatorBuilder: (context, index) =>
                widget.seperatorBuilder!(context),
            itemBuilder: builder,
          )
        : ListView.builder(
            controller: widget.controller,
            itemCount: itemCount,
            itemBuilder: builder,
          );
  }

  @override
  void deactivate() {
    super.deactivate();
    _cacheList = emptyList;
  }
}
