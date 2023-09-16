import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/presentation/widgets/episode_holder.dart';
import 'package:meiyou/presentation/widgets/not_found.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';
import 'package:meiyou/presentation/widgets/watch/state/movie_view/state/bloc/fetch_movie_bloc.dart';

class MovieView extends StatelessWidget {
  final void Function(SelectedServer server)? onServerSelected;
  const MovieView({
    super.key,
    this.onServerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchMovieBloc, FetchMovieState>(
      builder: (context, state) {
        if (state is FetchMovieSuccess) {
          return EpisodeHolder(
            onTap: () {
              VideoServerListView.showDialog(
                  context, state.movie!.url, onServerSelected);
            },
            number: 0,
            title: state.movie!.title,
            desc: state.movie!.description,
            thumbnail: state.movie!.cover,
            rated: state.movie!.rated,
          );
        } else if (state is FetchMovieFailed) {
          return const NotFound();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      listener: (a, b) {
        if (b is FetchMovieFailed) {
          showSnackBAr(context, text: b.error!.toString());
        }
      },
      listenWhen: (a, b) => b is FetchMovieFailed,
    );
  }
}
