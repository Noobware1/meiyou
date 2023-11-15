import 'package:equatable/equatable.dart';
import 'package:meiyou/data/repositories/providers_repository_impl.dart';

class ProvidersSettingsEntity extends Equatable {
  final DefaultProvider deaultMovieProvider;
  final DefaultProvider defaultAnimeProvider;

  const ProvidersSettingsEntity(
      {required this.deaultMovieProvider, required this.defaultAnimeProvider});

  @override
  List<Object?> get props => [deaultMovieProvider, defaultAnimeProvider];
}
