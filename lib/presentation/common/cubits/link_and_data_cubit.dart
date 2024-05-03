import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';

typedef LinkAndVideoCubit = LinkAndDataCubit<Video>;

class LinkAndDataState<T extends ContentData> {
  final int selectedIndex;
  final List<LinkAndData<T>> linkAndData;

  const LinkAndDataState(this.selectedIndex, this.linkAndData);

  const LinkAndDataState.intital()
      : selectedIndex = -1,
        linkAndData = const [];

  LinkAndDataState<T> copyWith({
    int? selectedIndex,
    List<LinkAndData<T>>? linkAndData,
  }) {
    return LinkAndDataState(
      selectedIndex ?? this.selectedIndex,
      linkAndData ?? this.linkAndData,
    );
  }

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

class LinkAndDataCubit<T extends ContentData> extends Cubit<LinkAndDataState<T>>
    with CloseableMixin {
  StreamSubscription<List<LinkAndData<T>>>? _subscription;

  final void Function(Exception exception) _onError;

  LinkAndDataCubit(void Function(Exception exception) onError)
      : _onError = onError,
        super(const LinkAndDataState.intital());

  @override
  void emit(LinkAndDataState<T> state) {
    if (isClosed) return;
    super.emit(state);
  }

  void select(int index) {
    if (index == state.selectedIndex) return;
    emit(state.copyWith(selectedIndex: index));
  }

  void initStream(Stream<List<LinkAndData<T>>> stream) async {
    emit(const LinkAndDataState.intital());
    try {
      await _subscription?.cancel();
    } catch (e) {
      _onError(_exceptionWrapper(e));
    }
    _subscription = stream.listen(
      (data) {
        emit(LinkAndDataState<T>(state.selectedIndex, data));
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
