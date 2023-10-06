import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/initialization_view/intialise_view_type.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases_container/meta_provider_repository_container.dart';
import 'package:meiyou/core/utils/extenstions/async_snapshot.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/usecases/get_media_details_usecase.dart';
import 'package:meiyou/presentation/widgets/info.dart';
import 'package:meiyou/presentation/widgets/info/loading_widget.dart';
import 'package:meiyou/presentation/widgets/retry_connection.dart';

class LoadInfo extends StatefulWidget {
  final MetaResponseEntity metaResponse;
  final InitaliseViewType type;
  const LoadInfo({super.key, required this.metaResponse, required this.type});

  @override
  State<LoadInfo> createState() => _LoadInfoState();
}

class _LoadInfoState extends State<LoadInfo> {
  Future<ResponseState<MediaDetailsEntity>>? media;

  @override
  void initState() {
    fetchInfo();
    super.initState();
  }

  void fetchInfo() {
    setState(() {
      media = RepositoryProvider.of<MetaProviderRepositoryContainer>(context)
          .get<GetMediaDetailUseCase>()
          .call(widget.metaResponse);
    });
  }

  @override
  void didUpdateWidget(covariant LoadInfo oldWidget) {
    if (oldWidget.metaResponse != widget.metaResponse) {
      setState(() {
        fetchInfo();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: media,
      builder: (context, snapshot) {
        if (snapshot.waiting) {
          return const LoadingWidget();
        } else if (snapshot.done && snapshot.data is ResponseSuccess) {
          return InfoPage(
            type: widget.type,
            media: snapshot.data!.data!,
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: RetryConnection(
                    onRetryConnection: () => fetchInfo(),
                    retryReason: snapshot.data?.error?.toString() ?? ''),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    media = null;
    super.dispose();
  }
}
