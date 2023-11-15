part of 'selected_search_response_bloc.dart';

sealed class SelectedSearchResponseEvent extends Equatable {
  final BaseProvider provider;
  const SelectedSearchResponseEvent(this.provider);

  @override
  List<Object> get props => [provider];
}

final class FindBestSearchResponseFromList extends SelectedSearchResponseEvent {
  final List<SearchResponseEntity>? searchResponses;

  final MeiyouException? error;
  const FindBestSearchResponseFromList(
      this.searchResponses, this.error, super.provider);
}

final class SearchResponseWaiting extends SelectedSearchResponseEvent {
  final String title;
  const SearchResponseWaiting(this.title, super.provider);
}

final class SelectSearchResponseFromUserSelection
    extends SelectedSearchResponseEvent {
  final SearchResponseEntity searchResponse;
  const SelectSearchResponseFromUserSelection(
      this.searchResponse, super.provider);
}

final class LoadSavedSearchResponseFromCache
    extends SelectedSearchResponseEvent {
  final List<SearchResponseEntity>? searchResponses;
  final MeiyouException? error;
  const LoadSavedSearchResponseFromCache(
      this.searchResponses, this.error, super.provider);
}
