import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/utils/resources/async_cubit.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class InfoScreenCubit extends AsyncCubit<InfoPage> {
  final SourceRepository _sourceRepository;
  final ContentItem _contentItem;
  InfoScreenCubit(this._sourceRepository, this._contentItem) : super.loading() {
    _load();
  }

  void _load() {
    return future(() => _sourceRepository
        .getInfoPage(InjectKtor.get<SelectedSource>().state!, _contentItem)
        .then((value) => value.getOrThrow()));
  }

  void retry() => _load();

  void addContent(Content content) {
    assert(state.hasValue);
    emitData(state.asData!.value.copyWith(content: content));
  }
}
