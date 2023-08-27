part of 'watch_view_bloc.dart';

sealed class WatchViewState extends Equatable {
  final UseCase? usecase;
  const WatchViewState(this.usecase);
  
  @override
  List<Object> get props => [usecase!];
}

final class WatchViewWithUseCase extends WatchViewState {
  const WatchViewWithUseCase(UseCase usecase): super(usecase)
}

final class WatchViewWithoutUseCase extends WatchViewState{
  const WatchViewWithoutUseCase() : super(null)
}
