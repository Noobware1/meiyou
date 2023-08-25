part of 'selected_search_response_bloc.dart';

sealed class SelectedSearchResponseEvent extends Equatable {
  const SelectedSearchResponseEvent();

  @override
  List<Object> get props => [];
}

final class FindBestSearchResponseFromList extends SelectedSearchResponseEvent {
  final List<SearchResponseEntity>? searchResponses;
  final ProviderType type;
  final MeiyouException? error;
  const FindBestSearchResponseFromList(
      this.searchResponses, this.type, this.error);
}

final class SearchResponseWaiting extends SelectedSearchResponseEvent {
  final String title;
  const SearchResponseWaiting(this.title);
}

final class SelectSearchResponseFromUserSelection
    extends SelectedSearchResponseEvent {
  final SearchResponseEntity searchResponse;
  const SelectSearchResponseFromUserSelection(this.searchResponse);
}
