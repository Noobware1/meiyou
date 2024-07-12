import 'dart:async';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';

import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou/notifers/state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef LinkAndVideoNotifer = _LinkAndVideoNotifer;

class LinkAndVideoState extends LinkAndDataState<Video> {
  final int selectedSourceIndex;
  const LinkAndVideoState(int selectedIndex, this.selectedSourceIndex,
      List<LinkAndData<Video>> linkAndData)
      : super(selectedIndex, linkAndData);

  const LinkAndVideoState.intital()
      : selectedSourceIndex = -1,
        super.intital();

  LinkAndVideoState copyWith({
    int? selectedIndex,
    int? selectedSourceIndex,
    List<LinkAndData<Video>>? linkAndData,
  }) {
    return LinkAndVideoState(
      selectedIndex ?? this.selectedIndex,
      selectedSourceIndex ?? this.selectedSourceIndex,
      linkAndData ?? this.linkAndData,
    );
  }

  VideoSource? get source {
    try {
      return linkAndData[selectedIndex].second.sources[selectedSourceIndex];
    } catch (_) {
      return null;
    }
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinkAndVideoState &&
        other.selectedIndex == selectedIndex &&
        other.selectedSourceIndex == selectedSourceIndex &&
        const ListEquality().equals(other.linkAndData, linkAndData);
  }

  @override
  int get hashCode =>
      selectedIndex.hashCode ^
      selectedSourceIndex.hashCode ^
      linkAndData.hashCode;
}

class LinkAndDataState<T extends ContentData> {
  final int selectedIndex;
  final List<LinkAndData<T>> linkAndData;

  const LinkAndDataState(this.selectedIndex, this.linkAndData);

  const LinkAndDataState.intital()
      : selectedIndex = -1,
        linkAndData = const [];

  ContentDataLink get link => linkAndData[selectedIndex].first;

  T get data => linkAndData[selectedIndex].second;

  R when<R>({
    required R Function(int selectedIndex, List<LinkAndData<T>> linkAndData)
        data,
    required R Function() initial,
  }) {
    if (selectedIndex == -1) {
      return initial();
    } else {
      return data(selectedIndex, linkAndData);
    }
  }
}

abstract class LinkAndDataNotifer<Data extends ContentData,
    State extends LinkAndDataState<Data>> extends StateNotifer<State> {
  StreamSubscription<List<LinkAndData<Data>>>? _subscription;

  final void Function(Exception exception) _onError;

  LinkAndDataNotifer._(super.state, this._onError);

  static LinkAndVideoNotifer video(void Function(Exception exception) onError) {
    return _LinkAndVideoNotifer(onError);
  }

  @override
  void setState(State state) {
    if (isDisposed) return;
    super.setState(state);
  }

  void select(int index);

  State onData(List<Pair<ContentDataLink, Data>> data);

  State inital();

  void initStream(Stream<List<LinkAndData<Data>>> stream) async {
    setState(inital());
    try {
      await _subscription?.cancel();
    } catch (e) {
      _onError(_exceptionWrapper(e));
    }
    _subscription = stream.listen(
      (data) {
        setState(onData(data));
      },
      onDone: () async {
        await _subscription?.cancel();
        if (state.linkAndData.isEmpty) _onError(NoContentDataException());
      },
      onError: (error) async {
        await _subscription?.cancel();
        _onError(_exceptionWrapper(error));
      },
    );
  }

  @override
  FutureOr<void> onDispose() async {
    await _subscription?.cancel();
    super.onDispose();
  }
}

class _LinkAndVideoNotifer
    extends LinkAndDataNotifer<Video, LinkAndVideoState> {
  _LinkAndVideoNotifer(void Function(Exception exception) onError)
      : super._(const LinkAndVideoState.intital(), onError);

  @override
  void select(int index) {
    if (index == state.selectedIndex) return;
    setState(state.copyWith(selectedIndex: index));
  }

  void selectSource(int index) {
    if (index == state.selectedSourceIndex) return;
    setState(state.copyWith(selectedSourceIndex: index));
  }

  @override
  LinkAndVideoState onData(List<LinkAndData<Video>> data) {
    return state.copyWith(linkAndData: data);
  }

  @override
  LinkAndVideoState inital() => const LinkAndVideoState.intital();
}

class NoContentDataException implements Exception {
  NoContentDataException();

  @override
  String toString() {
    return 'No content data found';
  }
}

Exception _exceptionWrapper(dynamic e) {
  if (e is Exception) {
    return e;
  } else {
    return Exception(e.toString());
  }
}
