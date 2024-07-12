import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/logger.dart';

import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou/notifers/async_notifer.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';

class LazyContentWidget extends StatefulWidget implements ContentWidget {
  const LazyContentWidget({super.key, required this.content});

  @override
  void Function() get onSelected => throw UnimplementedError();

  @override
  final LazyContent content;

  @override
  ContentProgress? get contentProgress => null;

  @override
  State<LazyContentWidget> createState() => _LazyContentState();
}

class _LazyContentState extends State<LazyContentWidget> {
  AsyncValue<LazyContent> state = const AsyncValue<LazyContent>.loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final results =
        await getIt.get<SourceRepository>().loadLazyContent(widget.content);
    results.when(success: (content) {
      getIt.get<InfoScreenNotifer>().addContent(content);
    }, error: (exception) {
      setState(() {
        state = AsyncValue.error(exception, StackTrace.current);
      });
      logRat.logError(exception.toString(), exception);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (state.hasError) {
      return error(state.error!, state.stackTrace!);
    } else {
      return loading();
    }
  }

  Widget error(Object error, StackTrace stackTrace) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
