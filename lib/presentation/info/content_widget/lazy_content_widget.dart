import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';

import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/core/utils/resources/async_cubit.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/info_screen_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';

class LazyContentWidget extends StatefulWidget implements ContentWidget {
  const LazyContentWidget({super.key, required this.content});

  @override
  void Function() get onSelected => throw UnimplementedError();

  @override
  final LazyContent content;

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
    final results = await InjectKtor.get<SourceRepository>()
        .loadLazyContent(widget.content);
    results.when(success: (content) {
      InjectKtor.get<InfoScreenCubit>().addContent(content);
    }, error: (exception) {
      setState(() {
        state = AsyncValue.error(exception, StackTrace.current);
      });
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
