part of 'main_page_bloc.dart';

abstract class MainPageState extends Equatable {
  final MainPageEntity? mainPageEntity;
  final MeiyouException? error;
  const MainPageState({this.mainPageEntity, this.error});

  @override
  List<Object> get props => [mainPageEntity!, error!];
}

class MainPageLoading extends MainPageState {
  const MainPageLoading();
}

class MainPageWithData extends MainPageState {
  const MainPageWithData(MainPageEntity mainPageEntity)
      : super(mainPageEntity: mainPageEntity);
}

class MainPageWithError extends MainPageState {
  const MainPageWithError(MeiyouException error) : super(error: error);
}
