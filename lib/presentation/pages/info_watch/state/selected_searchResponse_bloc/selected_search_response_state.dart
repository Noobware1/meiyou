part of 'selected_search_response_bloc.dart';

sealed class SelectedSearchResponseState extends Equatable {
  final String title;
  final SearchResponseEntity searchResponse;

  const SelectedSearchResponseState(
      {required this.title, this.searchResponse = SearchResponseEntity.empty});

  @override
  List<Object> get props => [title, searchResponse];
}

final class SelectedSearchResponseFinding extends SelectedSearchResponseState {
  const SelectedSearchResponseFinding(String title)
      : super(title: 'Finding: $title');
}

final class SelectedSearchResponseFound extends SelectedSearchResponseState {
  const SelectedSearchResponseFound(
      String title, SearchResponseEntity searchResponse)
      : super(title: 'Found: $title', searchResponse: searchResponse);
}

final class SelectedSearchResponseNotFound extends SelectedSearchResponseState {
  final MeiyouException error;
  const SelectedSearchResponseNotFound(String title, this.error)
      : super(title: 'Not Found: $title');
}
